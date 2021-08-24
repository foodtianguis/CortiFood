import 'dart:convert';

import 'package:dartxero/MiBD/miJason.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'MiVariablesGlobales.dart' as Vloca;

class MyPreferences {
  static const AUTOMATIC = "automatic";
  static const USER = "user";
  static const PASSWORD = "password";

  static final MyPreferences instance = MyPreferences._internal();

  //Campos a manejar
  SharedPreferences _sharedPreferences;
  bool automatic = false;
  String user = "";
  String password = "";

  MyPreferences._internal() {}

  factory MyPreferences() => instance;

  Future<SharedPreferences> get preferences async {
    if (_sharedPreferences != null) {
      return _sharedPreferences;
    } else {
      _sharedPreferences = await SharedPreferences.getInstance();
      automatic = _sharedPreferences.getBool(AUTOMATIC);
      user = _sharedPreferences.getString(USER);
      password = _sharedPreferences.getString(PASSWORD);

      if (automatic == null) {
        automatic = false;
        user = "";
        password = "";
      }
      return _sharedPreferences;
    }
  }

  Future<bool> commit() async {
    if (automatic) {
      await _sharedPreferences.setBool(AUTOMATIC, true);
      await _sharedPreferences.setString(USER, user);
      await _sharedPreferences.setString(PASSWORD, password);
    } else {
      await _sharedPreferences.setBool(AUTOMATIC, false);
      await _sharedPreferences.setString(USER, "");
      await _sharedPreferences.setString(PASSWORD, "");
      await _sharedPreferences.clear();
    }
  }

  Future<MyPreferences> init() async {
    _sharedPreferences = await preferences;
    return this;
  }
}
