import 'package:bible/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends StatefulWidget {
  final Widget child;

  const AppState({Key key, this.child}) : super(key: key);

  @override
  _AppStateState createState() => _AppStateState();

  static _AppStateState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_AppState) as _AppState).data;
  }
}

class _AppStateState extends State<AppState> {
  bool loading = true;
  String _theme;
  bool _autoDark;
  bool _autoDarkBlack;
  double _fontSize;

  String get theme => _theme;

  bool get autoDark => _autoDark;

  bool get autoDarkBlack => _autoDarkBlack;

  double get fontSize => _fontSize;

  void onThemeChange(String theme) {
    setState(() {
      _theme = theme;
    });
  }

  void onAutoDarkChange(bool value) {
    setState(() {
      _autoDark = value;
    });
  }

  void onAutoDarkBlackChange(bool value) {
    setState(() {
      _autoDarkBlack = value;
    });
  }

  void onFontSizeChanged(double value){
    setState(() {
      _fontSize = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _AppState(
      data: this,
      child: widget.child,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      this._autoDark = preferences.getBool(PREFS_KEY_AUTO_DARK) ?? true;
      this._theme = preferences.getString(PREFS_KEY_THEME) ?? 'blue';
      this._autoDarkBlack = preferences.getBool(PREFS_KEY_DARK_BLACK) ?? false;
      this._fontSize = preferences.getDouble(PREFS_KEY_FONT_SIZE) ?? 16;
    });
  }
}

class _AppState extends InheritedWidget {
  final _AppStateState data;

  const _AppState({
    Key key,
    @required Widget child,
    this.data,
  })  : assert(child != null),
        super(key: key, child: child);

  static _AppState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(_AppState) as _AppState;
  }

  @override
  bool updateShouldNotify(_AppState old) {
    return true;
  }
}
