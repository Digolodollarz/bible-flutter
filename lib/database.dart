import 'dart:async';
import 'dart:io';

import 'package:bible/localization.dart';
import 'package:bible/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

const String DATA_INITIALISED = "DATA_INITIALISED";
final String databaseName = "bible-data.db";

class DatabaseProvider {
  BuildContext context;
  Database db;
  String keyTable = 'key_english';
  String keyTableAlt = 'key_shona';
  String textTable = 't_bbe';
  String textTableAlt = 't_shona';
  final _lock = new Lock();

  Future openDefault(BuildContext context) async {
//    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, databaseName);
    await this.open(path);
    this.context = context;
    this.keyTable = AppLocalizations.of(context).text('key_table');
    this.textTable = AppLocalizations.of(context).text('text_table');
    this.keyTableAlt = AppLocalizations.of(context).text('key_table_alt');
    this.textTableAlt = AppLocalizations.of(context).text('text_table_alt');
  }

  Future open(String path) async {
    if (db != null) return;
    await _lock.synchronized(() async {
      // Check again once entering the synchronized block
      if (db != null) return;
      await _prepareDatabase();
      db = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {},
      );
    });
  }

  Future<Book> getBook(int id) async {
    List<Map> devotionals = await db.query(
      keyTable,
      columns: [columnBook, columnName],
      where: "$columnBook = ?",
      whereArgs: [id],
    );
    if (devotionals.length > 0) {
      return Book.fromMap(devotionals.first);
    }
    return null;
  }

  ///Method return a book from the database based on the passed name
  ///The method searches both of the key_tables, with priority to the current
  ///language table.
  Future<Book> findBook(String name) async {
    List<Map> books = await db.query(
      keyTable,
      columns: [columnBook, columnName],
      where: "$columnName = ?",
      whereArgs: [name],
    );
    if (books.length > 0) {
      return Book.fromMap(books.first);
    } else {
      books = await db.query(
        keyTableAlt,
        columns: [columnBook, columnName],
        where: "$columnName = ?",
        whereArgs: [name],
      );
      if (books.length > 0) {
        return Book.fromMap(books.first);
      } else {
        books = await db.query(
          keyTable,
          columns: [columnBook, columnName],
          where: "$columnName LIKE '%${name.substring(0, 3)}%'",
        );
        if (books.length == 1) {
          return Book.fromMap(books.first);
        } else {
          books = await db.query(
            keyTableAlt,
            columns: [columnBook, columnName],
            where: "$columnName LIKE '%${name.substring(0, 3)}%'",
          );
          if (books.length == 1) {
            return Book.fromMap(books.first);
          }
        }
      }
    }
    return null;
  }

  Future<List<Book>> getBooks() async {
    if (db == null) {
      print('null db');
    }
    List<Map> books = await db.query(keyTable);
    if (books.length > 0) {
      return books.map((book) => Book.fromMap(book)).toList();
    }
    return null;
  }

  Future<List<Chapter>> getChapters(Book book) async {
    List<Map> chapters = await db.query(textTable,
        where: "$columnBook = ?",
        columns: [columnBook, columnChapter],
        whereArgs: [book.id],
        distinct: true);

    if (chapters.length > 0) {
      return chapters
          .map((chapter) => Chapter.fromAddBook(chapter, book))
          .toList();
    }
    return null;
  }

  Future<List<Verse>> getVerses(Chapter chapter) async {
    List<Map> verses = List();
    int book = chapter.book;

    if (book == null) {
      var _book = await this.findBook(chapter.name);
      book = _book?.id;
    }

    if (book != null) {
      verses = await db.query(
        textTable,
        where: "$columnBook = ? AND $columnChapter = ?",
        whereArgs: [book, chapter.chapter],
      );
    } else {
      throw ArgumentError.value(chapter, 'Failed to read the chapter');
    }

    if (verses.length > 0) {
      return verses.map((verse) => Verse.fromMap(verse)).toList();
    }

    verses = await db.query(textTable);
    if (verses.length > 0) {
      return verses.map((verse) => Verse.fromMap(verse)).toList();
    }
    throw Exception('Database returns : ' + verses.toString());
  }

  Future<List<Verse>> searchText(String queryText) async {
    List<Map> verses = await db.query(
      "$textTable left join $keyTable on $textTable.b = $keyTable.b",
      where: "$columnText LIKE '%$queryText%'",
    );
    if (verses.length < 1) {
      verses = await db.query(
        "$textTable left join $keyTable on $textTable.b = $keyTable.b",
        where: "$columnText LIKE '%$queryText%'",
      );
    }
    if (verses.length > 0) {
      return verses.map((verse) => Verse.fromMap(verse)).toList();
    }
    return List();
  }

  Future<Devotional> insertDevotional(Devotional dev) async {
    dev.id = await db.insert(devotionalTable, dev.toMap());
    return dev;
  }

  Future<Devotional> getDevotional(int id) async {
    try {
      List<Map> devs = await db.query(
        devotionalTable,
        columns: [
          columnId,
          columnHeader,
          columnDevotionalVerse,
          columnDevotionalText,
        ],
        where: "$columnId = ?",
        whereArgs: [id],
      );
      if (devs.length > 0) {
        return Devotional.fromMap(devs.first);
      }
    } on DatabaseException catch (e) {
      print(e);
      throw e;
    }
    return null;
  }

  Future<int> deleteDevotional(int id) async {
    return await db
        .delete(devotionalTable, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> updateDevotional(Devotional dev) async {
    return await db.update(devotionalTable, dev.toMap(),
        where: "$columnId = ?", whereArgs: [dev.id]);
  }

  Future<Note> insertNote(Note note) async {
    try {
      note.id = await db.insert(noteTable, note.toMap());
    } on DatabaseException catch (e) {
      if (e.isNoSuchTableError()) {
        await _createNotesTable();
        note.id = await db.insert(noteTable, note.toMap());
      }
    }
    return note;
  }

  Future<List<Note>> getNotes() async {
    List<Map> notes = await db.query(
        "$noteTable left join $keyTable on $noteTable.bookId = $keyTable.b");
    if (notes.length > 0) {
      return notes.map((note) => Note.fromMap(note)).toList();
    }
    return List<Note>();
  }

  Future<int> deleteNote(int id) async {
    return await db.delete(noteTable, where: "$columnId = ?", whereArgs: [id]);
  }

  Future close() async => db.close();

  _prepareDatabase({bool overwrite = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(DATA_INITIALISED) ?? false) {
      return;
    }

    // Construct a file path to copy database to
//    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, databaseName);

    // Only copy if the database doesn't exist or to clear errors
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      // Load database from asset and copy
      ByteData data = await rootBundle.load(join('assets', databaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Save copied asset to documents
      await new File(path).writeAsBytes(bytes);
      print('created new database');
    }

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {},
    );

    List<Map> devotionalTableColumns =
        await db.rawQuery("PRAGMA table_info($devotionalTable)");
    if (devotionalTableColumns.length > 0) {
      devotionalTableColumns.forEach((c) => print(c));
    }

    List<Map> noteTableColumns = await db.rawQuery("PRAGMA table_info(notes)");
    if (noteTableColumns.length > 0) {
      noteTableColumns.forEach((c) => print(c));
    } else {
      _createNotesTable();
    }

    List<Map> shonaTextTableColumns =
        await db.rawQuery("PRAGMA table_info(t_shona)");
    if (shonaTextTableColumns.length > 0) {
      bool valid = false;
      shonaTextTableColumns.forEach((c) {
        print(c);
        if (c['_id'] != null) {
          valid = true;
        }
      });
      if (valid) return;
      await db.execute("DROP TABLE IF EXISTS text_temp");
      await db.execute("CREATE TABLE text_temp as SELECT * from t_shona");
      await db.execute("DROP TABLE t_shona");
      await db.execute("CREATE TABLE t_shona ($columnId INTEGER PRIMARY KEY,"
          "$columnBook INTEGER, "
          "$columnChapter INTEGER, "
          "$columnVerse INTEGER, "
          "$columnText TEXT)");
      await db.execute("INSERT INTO t_shona"
          "($columnId, $columnBook, $columnChapter, $columnVerse, $columnText)"
          "SELECT "
          "rowid as $columnId, $columnBook, $columnChapter, $columnVerse, $columnText"
          " from text_temp");
      shonaTextTableColumns = await db.rawQuery("PRAGMA table_info(t_shona)");
      if (shonaTextTableColumns.length > 0) {
        valid = false;
        shonaTextTableColumns.forEach((c) {
          print(c);
          if (c['_id'] != null) {
            valid = true;
          }
        });
        if (valid) {
          await db.execute("DROP TABLE text_temp");
        }
      }
    }
    prefs.setBool(DATA_INITIALISED, true);
  }

  Future _createNotesTable() async {
    return await db.execute(
        "CREATE TABLE $noteTable ($columnId INTEGER PRIMARY KEY,"
        " $columnTitle TEXT, $columnNoteText TEXT,"
        " $columnNoteChapter INTEGER, $columnStartVerse INTEGER, $columnEndVerse INTEGER,"
        " $columnNoteBook INTEGER)");
  }
}
