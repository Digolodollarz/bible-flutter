import 'package:flutter/material.dart';

ThemeData getAppTheme(Brightness brightness) {
  return brightness == Brightness.dark
      ? _getDarkAppTheme()
      : _getLightAppTheme();
}

ThemeData _getLightAppTheme() {
  ThemeData base = ThemeData(
    fontFamily: 'Rubik',
    brightness: Brightness.light,
  );

  return base.copyWith(
    primaryColor: Colors.lightBlue,
    backgroundColor: Colors.grey[100],
    accentColor: Colors.red[200],
    indicatorColor: Colors.red[400],
    textTheme: _getTextTheme(base.textTheme),
  );
}

ThemeData _getDarkAppTheme() {
  ThemeData base = ThemeData(
    fontFamily: 'Rubik',
    brightness: Brightness.dark,
  );
  return base.copyWith(
    indicatorColor: Colors.red[400],
    accentColor: Colors.red[200],
    textTheme: _getTextTheme(base.textTheme),
  );
}

_getTextTheme(TextTheme base) {
  return base.apply(fontFamily: 'Nunito').copyWith(
        body1: base.body1.copyWith(
          fontFamily: 'Nunito',
          fontSize: 20.0,
        ),
        body2: base.body2.copyWith(
          fontFamily: 'Nunito',
          fontSize: 22.0,
        ),
        display1: base.display1.copyWith(
          fontFamily: 'Rubik',
          fontSize: 28.0,
        ),
        display2: base.display2.copyWith(
          fontFamily: 'Rubik',
          fontSize: 30.0,
        ),
        display3: base.display3.copyWith(
          fontFamily: 'Rubik',
          fontSize: 34.0,
        ),
        headline: base.headline.copyWith(
          fontFamily: 'Rubik',
          fontSize: 28.0,
        ),
      );
}
