import 'package:bible/models.dart';
import 'package:flutter/material.dart';

class VerseList extends StatelessWidget {
  final List<Verse> verses;

  const VerseList({Key key, @required this.verses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text("${index+1}. ${this.verses[index].text}",
          style: Theme.of(context).textTheme.body1,),
        );
      },
      itemCount: this.verses.length,
    );
  }
}