import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertodolist/app/core/models/user_model.dart';
import 'package:fluttertodolist/app/core/services/user_service.dart';
import 'package:fluttertodolist/app/core/utils/constants.dart';
import 'package:fluttertodolist/app/modules/home/components/home_switch_list_tile.dart';
import 'package:fluttertodolist/app/modules/item/repositories/item_repository.dart';
import 'package:fluttertodolist/app/modules/login/services/login_service.dart';

class HomeDrawer extends StatefulWidget {
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  final _loginService = Modular.get<LoginService>();
  final _userService = Modular.get<UserService>();
  final _itemRepository = Modular.get<ItemRepository>();

  UserModel _currentUser = UserModel();

  @override
  void initState() {
    super.initState();
    _userService.findCurrentUser().then((value) {
      setState(() {
        _currentUser = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: _buildCircleAvatar(_currentUser.photoUrl),
            accountName: Text(_currentUser.name ?? ''),
            accountEmail: Text(_currentUser.email ?? ''),
          ),
          HomeSwitchListTile(),
          Divider(),
          ListTile(
            leading: Icon(Icons.done_all),
            title: Text('Done all'),
            onTap: () {
              _itemRepository.doneAll();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.delete_sweep),
            title: Text('Delete all done'),
            onTap: () {
              _itemRepository.removeAllDone();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('About'),
            onTap: () => showAboutDialog(
                context: context,
                applicationVersion: Constants.version,
                applicationName: Constants.title,
                applicationIcon: Icon(Constants.icon),
                children: [
                  Text(
                    Constants.developer,
                    textAlign: TextAlign.center,
                  ),
                ]),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign out'),
            onTap: () => _loginService.signOut().whenComplete(() {
              Modular.to.popUntil(ModalRoute.withName(Modular.initialRoute));
            }),
          ),
          Divider(),
        ],
      ),
    );
  }

  CircleAvatar _buildCircleAvatar(photoUrl) {
    if (photoUrl == null) {
      return CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.account_circle,
          size: 75.0,
        ),
      );
    }
    return CircleAvatar(backgroundImage: NetworkImage(photoUrl));
  }
}
