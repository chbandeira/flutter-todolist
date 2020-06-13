import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertodolist/app/app_controller.dart';

class HomeSwitchListTile extends StatefulWidget {
  @override
  _HomeSwitchListTileState createState() => _HomeSwitchListTileState();
}

class _HomeSwitchListTileState extends State<HomeSwitchListTile> {
  @override
  Widget build(BuildContext context) {
    AppController _appController = Modular.get<AppController>();
    return ValueListenableBuilder<bool>(
      valueListenable: _appController.themeSwitchNotifier,
      builder: (context, isDarkTheme, child) => SwitchListTile(
        value: isDarkTheme,
        onChanged: (value) {
          setState(() {
            _appController.changeTheme(value);
          });
        },
        secondary: const Icon(Icons.tonality),
        title: Text('Dark theme'),
      ),
    );
  }
}
