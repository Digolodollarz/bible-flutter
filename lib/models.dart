final columnId = '_id';
final columnBook = 'b';
final columnName = 'n';
final columnNameAlt = '_n';
final columnVId = 'id';
final columnChapter = 'c';
final columnVerse = 'v';
final columnText = 't';

final String devotionalTable = "devotional";
final String noteTable = "notes";
final String columnHeader = "header";
final String columnDevotionalVerse = "verse";
final String columnDevotionalText = "text";
final String columnNoteText = "note";
final String columnTitle = "title";
final String columnStartVerse = "startVerse";
final String columnEndVerse = "endVerse";
final String columnNotes = "notes";
final String columnNote = "note";
final String columnNoteBook = "bookId";
final String columnNoteChapter = "chapter";
//final String columnNoteBookName = "bookName";

class Book {
  int id;
  String name;
  String altName;

  Book({this.id, this.name, this.altName});

  Book.fromMap(Map<String, dynamic> map) {
    id = map[columnBook];
    name = map[columnName];
    altName = map[columnNameAlt];
  }
}

class Chapter {
  int id;
  int book;
  String name;
  int chapter;

  Chapter({this.id, this.book, this.name, this.chapter});

  Chapter.fromMap(Map<String, dynamic> map) {
    this.id = map[columnId];
    this.name = map[columnName];
    this.book = map[columnBook];
    this.chapter = map[columnChapter];
  }

  Chapter.fromAddBook(Map<String, dynamic> map, Book book) {
    this.id = map[columnId];
    this.name = book.name;
    this.book = book.id;
    this.chapter = map[columnChapter];
  }

  @override
  String toString() {
    return '$name($book) $chapter';
  }


}

class Verse {
  int id;
  int book;
  int chapter;
  int verse;
  String text;
  String bookName;

  Verse.fromMap(Map<String, dynamic> map) {
    this.id = map[columnVId];
    this.book = map[columnBook];
    this.chapter = map[columnChapter];
    this.verse = map[columnVerse];
    this.text = map[columnText];
    this.bookName = map[columnName];
  }

  @override
  String toString() {
    return bookName.toString() +
        (book?.toString() ?? 'Book') +
        (chapter?.toString() ?? 'Chapter') +
        (verse?.toString() ?? 'Verse') +
        (text?.toString() ?? 'Text');
  }
}

class Devotional {
  int id;
  String header;
  String verse;
  String text;

  Devotional({this.id, this.header, this.verse, this.text});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnHeader: header,
      columnDevotionalVerse: verse,
      columnDevotionalText: text,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Devotional.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    header = map[columnHeader];
    verse = map[columnDevotionalVerse];
    text = map[columnDevotionalText];
  }
}

class Note {
  int id;
  String title;
  String text;
  String bookName;
  int chapter;
  int startVerse;
  int endVerse;
  int book;

  Note(
      {this.id,
      this.title,
      this.text,
      this.bookName,
      this.chapter,
      this.startVerse,
      this.endVerse,
      this.book});

  Note.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    text = map[columnNoteText];
    bookName = map[columnName];
    chapter = map[columnNoteChapter];
    startVerse = map[columnStartVerse];
    endVerse = map[columnEndVerse];
    book = map[columnNoteBook];

  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnId: id,
      columnTitle: title,
      columnNoteText: text,
      columnNoteChapter: chapter,
      columnStartVerse: startVerse,
      columnEndVerse: endVerse,
      columnNoteBook: book,
    };
    return map;
  }

  @override
  String toString() {
    return 'Note: '
        'Book $book'
        'Chapter $chapter'
        'Start Verse $startVerse'
        'End Verse $endVerse';
  }


}
