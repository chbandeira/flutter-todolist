import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertodolist/app/app_controller.dart';
import 'package:fluttertodolist/app/core/utils/constants.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Modular.get<AppController>().themeSwitchNotifier,
      builder: (context, isDarkTheme, child) => MaterialApp(
        title: Constants.title,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        ),
        initialRoute: '/',
        onGenerateRoute: Modular.generateRoute,
        navigatorKey: Modular.navigatorKey,
      ),
    );
  }
}
