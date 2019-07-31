import 'package:flutter/material.dart';

//ThemeData getAppTheme(Brightness brightness) {
//  ThemeData _base = ThemeData(
//    fontFamily: 'Rubik',
//    brightness: brightness,
//  );
//  return brightness == Brightness.dark
//      ? _getDarkAppTheme(_base)
//      : _getLightAppTheme(_base);
//}

ThemeData getAppTheme(
    {String theme = 'blue', bool autoDark = true, bool autoDarkBlack = false}) {
  Brightness brightness = Brightness.light;

  bool _autoDark = autoDark && _goDark();
  print("We should be ${_autoDark ? 'Auto Dark' : 'Auto Light'}");
  if (theme == 'dark' || theme == 'black' || _autoDark) {
    print("We Dem Dark");
    brightness = Brightness.dark;
  }
  ThemeData base = ThemeData(
    fontFamily: 'Rubik',
    brightness: brightness,
  );

  if (brightness == Brightness.dark) if (autoDarkBlack || theme == 'black')
    return _getBlackAppTheme(base);
  else
    return _getDarkAppTheme(base);

  switch (theme) {
    case 'red':
    case 'Red':
      return _getRedAppTheme(base);
  }

  return _getLightAppTheme(base);
}

ThemeData _getLightAppTheme(ThemeData base) {
  return base.copyWith(
    primaryColor: Colors.lightBlue,
    backgroundColor: Colors.grey[100],
    accentColor: Colors.red[400],
    indicatorColor: Colors.red[400],
    textTheme: _getTextTheme(base.textTheme),
  );
}

ThemeData _getDarkAppTheme(ThemeData base) {
  return base.copyWith(
    brightness: Brightness.dark,
    indicatorColor: Colors.red[400],
    accentColor: Colors.red[400],
    textTheme: _getTextTheme(base.textTheme),
//    backgroundColor: Colors.black,
  );
}

ThemeData _getBlackAppTheme(ThemeData base) {
  return base.copyWith(
    brightness: Brightness.dark,
    indicatorColor: Colors.red[400],
    accentColor: Colors.red[400],
    canvasColor: Colors.black,
    primaryColor: Color(0xff111111),
    backgroundColor: Colors.black,
    cardColor: Colors.black,
    scaffoldBackgroundColor: Color(0xff222222),
    textTheme: _getTextTheme(base.textTheme),

//    backgroundColor: Colors.black,
  );
}

ThemeData _getRedAppTheme(ThemeData base) {
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

ThemeData _getBlueAppTheme() {}

ThemeData _getBrownAppTheme() {}

ThemeData _getCustomAppTheme() {}

_getTextTheme(TextTheme base) {
  return base.apply(fontFamily: 'Nunito').copyWith(
        body1: base.body1.copyWith(
          fontFamily: 'Nunito',
          fontSize: 16.0,
        ),
        body2: base.body2.copyWith(
          fontFamily: 'Nunito',
          fontSize: 20.0,
        ),
        display1: base.display1.copyWith(
          fontFamily: 'Rubik',
          fontSize: 24.0,
        ),
        display2: base.display2.copyWith(
          fontFamily: 'Rubik',
          fontSize: 26.0,
        ),
        display3: base.display3.copyWith(
          fontFamily: 'Rubik',
          fontSize: 30.0,
        ),
        headline: base.headline.copyWith(
          fontFamily: 'Rubik',
          fontSize: 26.0,
        ),
      );
}

bool _goDark() {
  //TODO: Fix this method to make use of the system dark/light mode
  int hour = DateTime.now().hour;
  print('Time: $hour');
  return hour < 6 || hour > 19;
}
