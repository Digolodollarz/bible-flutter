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

  String get theme => _theme;

  bool get autoDark => _autoDark;

  bool get autoDarkBlack => _autoDarkBlack;

  void onThemeChange(String theme) {
    setState(() {
      _theme = theme;
    });
  }

  void onAutoDarkChange(bool value) {
    setState(() {
      _autoDark = value;
      print('Autodark is ${value ? "dark" : "bright"}');
    });
  }

  void onAutoDarkBlackChange(bool value) {
    setState(() {
      _autoDarkBlack = value;
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
