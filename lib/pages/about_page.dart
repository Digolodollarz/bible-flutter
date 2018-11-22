import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Holy Bible in Shona and English',
                  style: Theme.of(context).textTheme.headline,
                ),
                Text(
                  '\nThis application contains offline text for the Holy Bible'
                      'in English and Shona. \n'
                      'The Application is free for all, and contains no adverts.'
                      'We neither collect nor store any of your data.'
                      '\n\n'
                      'If you have any queries, please contact us at '
                      'bible.app@diggle.tech. Alternatively, place a call to'
                      ' +263774883687'
                      '\n\n'
                      '\u00a9 2016 - ${DateTime.now().year} Digolodollarz Technologies',
                  style: Theme.of(context).textTheme.body2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
