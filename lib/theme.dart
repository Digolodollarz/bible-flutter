import 'package:flutter/material.dart';

ThemeData getAppTheme(Brightness brightness) {
  ThemeData _base = ThemeData(
    fontFamily: 'Rubik',
    brightness: brightness,
  );
  return brightness == Brightness.dark
      ? _getDarkAppTheme(_base)
      : _getLightAppTheme(_base);
}

ThemeData _getLightAppTheme(ThemeData base) {

  return base.copyWith(
    primaryColor: Colors.lightBlue,
    backgroundColor: Colors.grey[100],
    accentColor: Colors.red[200],
    indicatorColor: Colors.red[400],
    textTheme: _getTextTheme(base.textTheme),
  );
}

ThemeData _getDarkAppTheme(ThemeData base) {
  return base.copyWith(
    brightness: Brightness.dark,
    indicatorColor: Colors.red[400],
    accentColor: Colors.red[200],
    textTheme: _getTextTheme(base.textTheme),
//    backgroundColor: Colors.black,
  );
}

ThemeData _getRedAppTheme(ThemeData base){
  return base.copyWith(
    primaryColor: Colors.red,
    primaryColorLight: Colors.red[400],
    primaryColorDark: Colors.red[700],
    indicatorColor: Colors.blue[400],
    accentColor: Colors.blue[500],
    textTheme: _getTextTheme(base.textTheme),
    backgroundColor: Colors.white,
  );
}

ThemeData _getBlueAppTheme(){

}

ThemeData _getBrownAppTheme(){

}

ThemeData _getCustomAppTheme(){

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
