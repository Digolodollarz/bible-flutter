import 'dart:async';

import 'package:bible/application.dart';
import 'package:bible/database.dart';
import 'package:bible/models.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ReadPage extends StatefulWidget {
  final Book book;
  final Chapter chapter;

  const ReadPage({Key key, @required this.book, @required this.chapter})
      : super(key: key);

  @override
  _ReadPageState createState() => _ReadPageState(this.book, this.chapter);
}

class _ReadPageState extends State<ReadPage> {
  final DatabaseProvider db = DatabaseProvider();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PersistentBottomSheetController bottomSheetController;
  Book book;
  Chapter chapter;
  List<Verse> verses;
  List<int> selectedIndices = List();

  _ReadPageState(this.book, this.chapter) {}

  @override
  Widget build(BuildContext context) {
    if (this.book == null || this.chapter == null) {
      return Container(
        color: Colors.redAccent,
        child: Text("""Fatal Error. Please retry.
        Error caused by no either no book or chapter passed."""),
      );
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: FutureBuilder(
          future: db.openDefault(context).then((v) => db.getBook(book.id)),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data.name);
            }
            return Text(this.book.name);
          },
        ),
        actions: <Widget>[_buildTranslateMenu(context)],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  _buildTranslateMenu(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.translate),
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry>[
          PopupMenuItem(
            child: ListTile(
              title: Text('Shona'),
              onTap: () {
                application.onLocaleChanged(Locale('sn'));
                Navigator.of(context).pop();
              },
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              title: Text('English'),
              onTap: () {
                application.onLocaleChanged(Locale('en'));
                Navigator.of(context).pop();
              },
            ),
          ),
        ];
      },
    );
  }

  Widget _buildBody() {
    return Container(
      child: FutureBuilder<List<Verse>>(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return _buildVerseList(context);
            } else {
              return Center(
                child: Text('Database returned nothing.'),
              );
            }
          } else if (snapshot.hasError) {
            return Text("""An error occured (READ).
              The error is :
              ${snapshot.error}""");
          }
          return Center(child: CircularProgressIndicator());
        },
        future: _getChapter(),
      ),
    );
  }

  Widget _buildVerseList(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return VerseItem(
          verse: this.verses[index],
          isSelected: selectedIndices.contains(index),
          index: index,
          isSelectionMode: selectedIndices.length > 0,
          callback: () => _onSelectElement(index),
        );
      },
      itemCount: this.verses.length,
    );
  }

  Future<List<Verse>> _getChapter() async {
    await db.openDefault(context);
    var v = await db.getVerses(this.chapter);
    Book b;
    if (this.chapter.book != null)
      b = await db.getBook(this.chapter.book);
    else
      b = await db.findBook(this.chapter.name);
    this.verses = v ?? this.verses;
    this.book = b ?? this.book;
    return this.verses;
  }

  _update() async {
    var v = await db.getVerses(this.chapter);
    var b = await db.getBook(this.chapter.book);
    setState(() {
      this.verses = v ?? this.verses;
      this.book = b ?? this.book;
    });
  }

  _onSelectElement(index) {
    setState(() {
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index);
      } else {
        selectedIndices.add(index);
      }
    });
//    if (selectedIndices.length > 0) {
//       _showBottomSheet(context);
//    } else {
//      if (this.bottomSheetController != null) {
//        this.bottomSheetController.close();
//        print('closed');
//      }
//    }
  }

  BottomAppBar _buildBottomAppBar() {
    if (this.selectedIndices.length > 0) {
      return BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: new Text(
                  this.selectedIndices.length.toString(),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildModalBottomSheet(context),
                );
              },
              icon: Icon(Icons.note_add),
            ),
            IconButton(
              onPressed: _shareVerses,
              icon: Icon(Icons.share),
            ),
          ],
        ),
      );
    }
    return null;
  }

  _buildModalBottomSheet(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text('Add Note'),
          NoteForm(saveCallback: _saveNote),
        ],
      ),
    );
  }

  _saveNote(Note note) {
//    Sort this list then take the smallest index as the startVerse;
//    The last verse is the largest index;
    this.selectedIndices.sort();
    note.startVerse = this.selectedIndices.first;
    note.endVerse = this.selectedIndices.last;

    note.book = this.book.id;
    note.bookName = this.book.name;
    note.chapter = this.chapter.chapter;

    _storeNote(note).then((val) {
      Navigator.pop(context);
      setState(() {
        this.selectedIndices.clear();
      });
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text('Added ${note.title}')),
      );
    }).catchError((error) {
      print(error);
    });
  }

  _shareVerses() {
    var _shareText = StringBuffer('${this.book.name} ${this.chapter.chapter}');
    for (var i = 0; i < this.verses.length; i++) {
      if (this.selectedIndices.contains(i)) {
        _shareText.write('\n${this.verses[i].verse} ${this.verses[i].text}');
      }
    }
    _shareText.write('\nHoly Bible with Shona FREE');
    Share.share(_shareText.toString());
  }

  Future _storeNote(Note note) async {
    await db.openDefault(context);
    return await db.insertNote(note);
  }
}

class VerseItem extends StatefulWidget {
  final int index;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback callback;
  final Verse verse;

  const VerseItem(
      {Key key,
      this.index,
      this.isSelected,
      this.isSelectionMode,
      this.callback,
      this.verse})
      : super(key: key);

  @override
  _VerseItemState createState() => _VerseItemState();
}

class _VerseItemState extends State<VerseItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.isSelected
          ? Theme.of(context).accentColor
          : Theme.of(context).backgroundColor,
      child: ListTile(
        onTap: widget.isSelectionMode ? widget.callback : null,
        onLongPress: widget.callback,
        title: Text(
          "${widget.index + 1}. ${widget.verse.text}",
          style: Theme.of(context).textTheme.body1,
        ),
      ),
    );
  }
}

class NoteForm extends StatefulWidget {
  final void Function(Note) saveCallback;

  const NoteForm({Key key, this.saveCallback}) : super(key: key);

  @override
  _NoteFormState createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final _formKey = GlobalKey<FormState>();
  Note note = Note();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return ('You need to type something');
              }
            },
            onSaved: (v) => note.title = v,
          ),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return ('You need to type something');
              }
            },
            onSaved: (v) => note.text = v,
          ),
          RaisedButton(
            child: Text('Save'),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                widget.saveCallback(note);
              }
            },
          ),
        ],
      ),
    );
  }
}
