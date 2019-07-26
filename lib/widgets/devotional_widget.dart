import 'dart:async';

import 'package:bible/database.dart';
import 'package:bible/models.dart';
import 'package:bible/pages/read_page.dart';
import 'package:flutter/material.dart';

class DevotionalWidget extends StatefulWidget {
  final scaffoldKey;

  DevotionalWidget({Key key, this.scaffoldKey}) : super(key: key);

  @override
  DevotionalWidgetState createState() {
    return new DevotionalWidgetState();
  }
}

class DevotionalWidgetState extends State<DevotionalWidget> {
  final DatabaseProvider db = DatabaseProvider();

  int offset = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Devotional>(
      future: getDevotional(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text(
                              snapshot.data.header,
                              style: Theme.of(context).textTheme.headline,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Container(
                              child: Text(
                                  _parseDevotionalText(snapshot.data.text))),
                        ],
                      ),
                    ),
                  ),
                ),
                buildBottomNav(snapshot.data.verse, context)
              ],
            );
          } else {
            return Text('Data is null');
          }
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Center buildBottomNav(String verseText, BuildContext context) {
    return new Center(
      child: Row(
        children: <Widget>[
          IconButton(
              onPressed: () {
                setState(() {
                  offset--;
                });
              },
              icon: Icon(Icons.arrow_back)),
          Expanded(
            child: FutureBuilder<Chapter>(
              future: _parseVerse(verseText, context),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                } else if (snapshot.data == null) {
                  return Text('From $verseText');
                }

                return RaisedButton(
                  child: Text(verseText),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) =>
                          _buildChapterModalBottomSheet(context, verseText),
                    );
                  },
                );
              },
            ),
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  offset++;
                });
              },
              icon: Icon(Icons.arrow_forward)),
        ],
      ),
    );
  }

  String _parseDevotionalText(String text) {
    text = text.trim();
    text = text.replaceAll('<P>', '');
    return text;
  }

  Widget _buildChapterModalBottomSheet(BuildContext context, String verseText) {
    RegExp bookNameExp = RegExp(r"(\d )?[a-z]+", caseSensitive: false);
    RegExp chapterExp = RegExp(r"(?:[a-z] )(\d+)", caseSensitive: false);
    RegExp verseExp = RegExp(r"(?:\d+:)(\d+)", caseSensitive: false);
    String bookName;
    int chapter;
    int verse;

    if (bookNameExp.hasMatch(verseText)) {
      bookName = bookNameExp.firstMatch(verseText).group(0);
    }
    if (chapterExp.hasMatch(verseText)) {
      chapter = int.tryParse(chapterExp.firstMatch(verseText).group(1));
    }
    if (verseExp.hasMatch(verseText)) {
      verse = int.tryParse(verseExp.firstMatch(verseText).group(1));
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      child: ReadPage(
        book: Book(name: bookName),
        chapter: Chapter(chapter: chapter, name: bookName),
      ),
    );
  }

  Future<Chapter> _parseVerse(String verseText, BuildContext context) async {
    RegExp bookNameExp = RegExp(r"(\d )?[a-z]+", caseSensitive: false);
    RegExp chapterExp = RegExp(r"(?:[a-z] )(\d+)", caseSensitive: false);
    RegExp verseExp = RegExp(r"(?:\d+:)(\d+)", caseSensitive: false);
    String bookName;
    int chapter;
    int verse;

    if (bookNameExp.hasMatch(verseText)) {
      bookName = bookNameExp.firstMatch(verseText).group(0);
    }
    if (chapterExp.hasMatch(verseText)) {
      chapter = int.tryParse(chapterExp.firstMatch(verseText).group(1));
    }
    if (verseExp.hasMatch(verseText)) {
      verse = int.tryParse(verseExp.firstMatch(verseText).group(1));
    }

    if (bookName == null || chapter == null) {
      print('Cant figure this out $verseText');
      return null;
    }

    await db.openDefault(context);
    Book book = await db.findBook(bookName);
    if (book == null) {
      return null;
    }
    return Chapter(
      id: chapter,
      chapter: chapter,
      book: book.id,
      name: book.name,
    );
  }

  Future<Devotional> getDevotional(BuildContext context) async {
    var now = DateTime.now();
    final diff = now.difference(new DateTime(now.year, 1, 1, 0, 0));
    int dayOfYear = diff.inDays + offset;
    if (dayOfYear > 365) dayOfYear -= 365;
    if (dayOfYear < 0) dayOfYear += 365;
    final id = int.parse("17$dayOfYear");
    await db.openDefault(context);
    return db.getDevotional(id);
  }

  Future getBook(BuildContext context, String verseText) async {
    await db.openDefault(context);
  }
}
