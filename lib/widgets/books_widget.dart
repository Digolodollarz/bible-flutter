import 'dart:async';

import 'package:bible/database.dart';
import 'package:bible/models.dart';
import 'package:bible/pages/chapter_page.dart';
import 'package:flutter/material.dart';

class BooksWidget extends StatefulWidget {
  final Book book;

  const BooksWidget({Key key, this.book}) : super(key: key);

  @override
  _BooksWidgetState createState() {
    return _BooksWidgetState(currentBook: this.book);
  }
}

class _BooksWidgetState extends State<BooksWidget> {
  final db = DatabaseProvider();
  Book currentBook;

  _BooksWidgetState({this.currentBook});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: _getBooks(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            return BookList(snapshot.data, (book) => _goToBook(book));
          } else {
            return Text('Something is wrong');
          }
        } else if (snapshot.hasError) {
          return Text("""
          Error reading from the database.
          The error is ${snapshot.error}.
          Please try again :-);          
          """);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Future<List<Book>> _getBooks() async {
    await db.openDefault(context);
    return db.getBooks();
  }

  _goToBook(Book book) {
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return ChapterListPage(book: book);
    }));
  }
}

class BookList extends StatelessWidget {
  final List<Book> books;
  final callback;

  BookList(this.books, this.callback);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                onTap: () => callback(books[index]),
                title: Text(
                  '${books[index].name}',
                  style: Theme.of(context).textTheme.body1,
                ),
                subtitle: Text('${books[index].altName}'),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
            ),
          );
        },
        itemCount: books.length,
      ),
    );
  }

  _goToBook(Book book) {
    print(book.name);
  }
}
