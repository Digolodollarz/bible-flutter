import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SharedPreferences _prefs;
  bool autoDark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        child: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              SharedPreferences prefs = snapshot.data;
              autoDark = prefs.getBool('auto_dark') ?? true;
              return Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text('Auto dark mode'),
                      ),
                      Checkbox(
                        value: autoDark,
                        onChanged: (newValue) {
                          prefs
                              .setBool('auto_dark', newValue)
                              .then((result) => this.setState(() {
                                    autoDark = result;
                                  }));
                        },
                      )
                    ],
                  )
                ],
              );
            } else if (snapshot.data == null) {
              return Text('Failed to load settings');
            } else if (snapshot.hasError) {
              return Text('Error. ${snapshot.error}');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
