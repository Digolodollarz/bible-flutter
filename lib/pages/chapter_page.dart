import 'dart:io';

import 'package:bible/database.dart';
import 'package:bible/models.dart';
import 'package:bible/pages/read_page.dart';
import 'package:flutter/material.dart';

class ChapterListPage extends StatefulWidget {
  final List<Chapter> chapters;
  final Book book;

  const ChapterListPage({Key key, this.chapters, this.book}) : super(key: key);

  @override
  ChapterListPageState createState() {
    return new ChapterListPageState();
  }
}

class ChapterListPageState extends State<ChapterListPage> {
  final DatabaseProvider db = DatabaseProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.book.name}'),
      ),
      body: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ChapterList(
              book: widget.book,
              chapters: snapshot.data,
            );
          } else if (snapshot.hasError) {
            return Text('Error');
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
        future: _getChapters(),
      ),
    );
  }

  Future<List<Chapter>> _getChapters() async {
    await db.openDefault(context);
    return db.getChapters(widget.book);
  }
}

class ChapterList extends StatelessWidget {
  final List<Chapter> chapters;
  final Book book;

  const ChapterList({Key key, this.chapters, this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return AndroidListCard(
          child: ListTile(
            onTap: () => _goToChapter(context, chapters[index]),
            title: Text(
              '${chapters[index].name} ${chapters[index].chapter}',
              style: Theme.of(context).textTheme.body1,
            ),
          ),
        );
      },
      itemCount: this.chapters.length,
    );
  }

  _goToChapter(BuildContext context, Chapter chapter) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return ReadPage(
        book: this.book,
        chapter: chapter,
      );
    }));
  }
}

class AndroidListCard extends StatelessWidget {
  final Widget child;

  const AndroidListCard({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: child,
      ),
    );
  }
}

