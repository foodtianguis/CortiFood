import 'dart:io';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleModel extends ChangeNotifier {
  static const localeValueList = ['es', 'en'];

  //
  static const kLocaleIndex = 'kLocaleIndex';

  static int _localeIndex;

  int get localeIndex => _localeIndex;

  static Locale get locale {
    var value = localeValueList[_localeIndex].split("-");
    return Locale(value[0], value.length == 2 ? value[1] : '');
  }

  LocaleModel() {
    _localeIndex = StorageManager.sharedPreferences.getInt(kLocaleIndex) ?? 0;
  }

  switchLocale() {
    _localeIndex = 1 - _localeIndex;
    notifyListeners();
    StorageManager.sharedPreferences.setInt(kLocaleIndex, _localeIndex);
  }

  static String localeName(index, context) {
    switch (index) {
      case 0:
        return 'Español';
      case 1:
        return 'English';
      default:
        return '';
    }
  }
}

class StorageManager {
  static SharedPreferences sharedPreferences;

  static Directory temporaryDirectory;

  static LocalStorage localStorage;

  static init() async {
    temporaryDirectory = await getTemporaryDirectory();
    sharedPreferences = await SharedPreferences.getInstance();
    localStorage = LocalStorage('LocalStorage');
    await localStorage.ready;
  }
}