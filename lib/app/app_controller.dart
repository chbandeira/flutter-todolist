import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertodolist/app/core/services/local_store_service.dart';

class AppController {
  final _localStorageService = Modular.get<LocalStoreService>();
  final _valueNotifier = ValueNotifier<bool>(false);

  AppController() {
    _localStorageService
        .get('brightness_theme')
        .then((value) => _valueNotifier.value = value ?? false);
  }

  ValueNotifier<bool> get themeSwitchNotifier => _valueNotifier;

  changeTheme(bool value) {
    _valueNotifier.value = value;
    _localStorageService.put('brightness_theme', _valueNotifier.value);
  }
}
