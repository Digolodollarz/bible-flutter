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
    {String theme = 'blue', bool autoDark = true, bool autoDarkBlack = false, double fontSize}) {
  Brightness brightness = Brightness.light;

  bool _autoDark = autoDark && _goDark();
  if (theme == 'dark' || theme == 'black' || _autoDark) {
    brightness = Brightness.dark;
  }
  ThemeData base = ThemeData(
    fontFamily: 'Rubik',
    brightness: brightness,
  );

  base = base.copyWith(textTheme: _getTextTheme(base.textTheme, fontSize??16));

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
  );
}

ThemeData _getDarkAppTheme(ThemeData base) {
  return base.copyWith(
    brightness: Brightness.dark,
    indicatorColor: Colors.red[400],
    accentColor: Colors.red[400],
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
    backgroundColor: Colors.white,
  );
}

ThemeData _getBlueAppTheme() {}

ThemeData _getBrownAppTheme() {}

ThemeData _getCustomAppTheme() {}

_getTextTheme(TextTheme base, double fontSize) {
  return base.apply(fontFamily: 'Nunito').copyWith(
        body1: base.body1.copyWith(
          fontFamily: 'Nunito',
          fontSize: fontSize,
        ),
        body2: base.body2.copyWith(
          fontFamily: 'Nunito',
          fontSize: fontSize + 4,
        ),
        display1: base.display1.copyWith(
          fontFamily: 'Rubik',
          fontSize: fontSize + 8,
        ),
        display2: base.display2.copyWith(
          fontFamily: 'Rubik',
          fontSize: fontSize + 10,
        ),
        display3: base.display3.copyWith(
          fontFamily: 'Rubik',
          fontSize: fontSize + 14,
        ),
        headline: base.headline.copyWith(
          fontFamily: 'Rubik',
          fontSize: fontSize + 10,
        ),
      );
}

bool _goDark() {
  //TODO: Fix this method to make use of the system dark/light mode
  int hour = DateTime.now().hour;
  return hour < 6 || hour > 19;
}
