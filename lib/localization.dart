import 'dart:async';

import 'package:bible/application.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _values = {
    'en': {
      'app_title': 'Holy Bible',
      'bible': 'Bible',
      'devotional': 'Devotional',
      'notes': 'Notes',
      'title': 'Title',
      'body': 'Body',
      'text_table': 't_bbe',
      'key_table': 'key_english',
      'text_table_alt': 't_shona',
      'key_table_alt': 'key_shona',
    },
    'sn': {
      'app_title': 'Bhaibheri',
      'bible': 'Bhaibheri',
      'devotional': 'Munamato',
      'notes': 'Manotsi',
      'title': 'Musoro',
      'body': 'Muviri',
      'text_table': 't_shona',
      'key_table': 'key_shona',
      'text_table_alt': 't_bbe',
      'key_table_alt': 'key_english',
    },
  };

  String text(String key) {
    return _values[locale.languageCode][key];
  }

  String get appTitle {
    return _values[locale.languageCode]['app_title'];
  }

  String get title {
    return _values[locale.languageCode]['title'];
  }

  String get bible {
    return _values[locale.languageCode]['bible'];
  }

  String get devotional {
    return _values[locale.languageCode]['devotional'];
  }

  String get notes {
    return _values[locale.languageCode]['notes'];
  }

  String get body {
    return _values[locale.languageCode]['body'];
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  final Locale newLocale;

  const AppLocalizationsDelegate({this.newLocale});

  @override
  bool isSupported(Locale locale) {
    return application.supportedLanguagesCodes.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(
        AppLocalizations(newLocale ?? locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return true;
  }
}
