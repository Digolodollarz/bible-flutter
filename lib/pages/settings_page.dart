import 'package:bible/app_state.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String PREFS_KEY_AUTO_DARK = 'auto_dark';
const String PREFS_KEY_THEME = 'theme';
const String PREFS_KEY_DARK_BLACK = "dark_black";

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final SharedPreferences prefs = snapshot.data;
            return Column(
              children: <Widget>[
                Card(
                  margin: EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Theme Settings",
                          style: Theme.of(context).textTheme.body2,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(child: Text('Color'),),
                            DropdownButton<String>(
                              value: prefs.getString(PREFS_KEY_THEME) ?? 'Blue',
                              items: <String>['Blue', 'Red', 'Dark', 'Black']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value.toLowerCase(),
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                prefs.setString(PREFS_KEY_THEME, newValue).then((result) {
                                  AppState.of(context).onThemeChange(newValue);
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('Auto dark mode'),
                            ),
                            Checkbox(
                              value: prefs.getBool(PREFS_KEY_AUTO_DARK)??true,
                              onChanged: (newValue) {
                                prefs
                                    .setBool(PREFS_KEY_AUTO_DARK, newValue)
                                    .then((result) {
                                  AppState.of(context).onAutoDarkChange(newValue);
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('AMOLED Black dark theme'),
                            ),
                            Checkbox(
                              value: prefs.getBool(PREFS_KEY_DARK_BLACK)??false,
                              onChanged: (newValue) {
                                prefs
                                    .setBool(PREFS_KEY_DARK_BLACK, newValue)
                                    .then((result) {
                                  AppState.of(context).onAutoDarkBlackChange(newValue);
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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
    );
  }
}

class ThemeColor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
