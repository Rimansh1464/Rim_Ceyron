import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocalizationStuff {
  LocalizationStuff(this.locale);

  final Locale? locale;

  static LocalizationStuff? of(BuildContext? context) {
    return Localizations.of<LocalizationStuff>(context!, LocalizationStuff);
  }

  Map<String, String>? _localizedValues;

  Future<void> load() async {
    String jsonStringValues =
    await rootBundle.loadString('lib/utils/Language/${locale!.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    _localizedValues =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String? translate(String key) {
    return _localizedValues![key];
  }

  // static member to have simple access to the delegate from Material App
  static const LocalizationsDelegate<LocalizationStuff> delegate =
  _DemoLocalizationsDelegate();
}

class _DemoLocalizationsDelegate
    extends LocalizationsDelegate<LocalizationStuff> {
  const _DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return [
      'fr','es','it','ar','hi','zh','pt','ru','en'
    ].contains(locale.languageCode);
  }

  @override
  Future<LocalizationStuff> load(Locale locale) async {
    LocalizationStuff localization = new LocalizationStuff(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<LocalizationStuff> old) => false;
}
