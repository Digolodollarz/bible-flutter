import 'dart:async';

import 'package:bible/database.dart';
import 'package:bible/models.dart';
import 'package:bible/pages/read_page.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class NotesWidget extends StatefulWidget {
  @override
  _NotesWidgetState createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {
  DatabaseProvider db = DatabaseProvider();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _getNotes(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return _buildNotesList(context, snapshot.data);
            } else {
              return Text('Nothing to see here.');
            }
          } else if (snapshot.hasError) {
            return Text("""Something terrible happened
          ${snapshot.error}
          Please try again later.""");
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<List<Note>> _getNotes() async {
    await db.openDefault(context);
    return db.getNotes();
  }

  Future _deleteNote(id) async {
    await db.openDefault(context);
    var deleted = await db.deleteNote(id);
    if (deleted != null) {
      setState(() {
        db.getNotes();
      });
    }
  }

  _buildNotesList(BuildContext context, List<Note> notes) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final _note = notes[index];
        return InkWell(
          onTap: () {
            final Book _book = Book(
                id: _note.book, name: _note.bookName);
            final Chapter _chapter = Chapter(
              id: _note.chapter,
              chapter: _note.chapter,
              book: _note.book,
              name: _note.bookName,
            );
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) {
                  return ReadPage(
                    book: _book,
                    chapter: _chapter,
                  );
                }));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          notes[index].title,
                          style: Theme.of(context).textTheme.body2,
                        ),
                        Text(
                          notes[index].text ?? '',
                          style: Theme.of(context).textTheme.body1,
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  final Book _book = Book(
                                      id: _note.book, name: _note.bookName);
                                  final Chapter _chapter = Chapter(
                                    id: _note.chapter,
                                    chapter: _note.chapter,
                                    book: _note.book,
                                    name: _note.bookName,
                                  );
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return ReadPage(
                                      book: _book,
                                      chapter: _chapter,
                                    );
                                  }));
                                },
                                child: Text(
                                  '${notes[index].bookName} '
                                  '${notes[index].chapter} : '
                                  '${notes[index].startVerse}-'
                                  '${notes[index].endVerse}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .body1
                                      .copyWith(),
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              IconButton(
                                icon: Icon(Icons.share),
                                onPressed: () {
                                  Share.share('${notes[index].title} \n'
                                      '${notes[index].text}\n'
                                      '${notes[index].bookName} '
                                      '${notes[index].chapter} : '
                                      '${notes[index].startVerse}'
                                      '-${notes[index].endVerse}\n'
                                      'Holy Bible with Shona FREE');
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_forever),
                                onPressed: () => _deleteNote(notes[index].id),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
          ),
        );
      },
      itemCount: notes.length,
    );
  }
}
