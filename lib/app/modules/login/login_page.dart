import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertodolist/app/core/utils/constants.dart';
import 'package:fluttertodolist/app/core/utils/route_names.dart';
import 'package:fluttertodolist/app/modules/login/components/signin_button.dart';
import 'package:fluttertodolist/app/modules/login/services/login_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginService = Modular.get<LoginService>();
  @override
  void initState() {
    super.initState();
    _autoSignIn();
  }

  void _autoSignIn() async {
    if (await _loginService.isSignedIn()) {
      Modular.to.pushNamed(RouteNames.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.assignment_turned_in,
                  color: Colors.white,
                  size: 50,
                ),
                SizedBox(width: 10),
                Text(
                  Constants.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'KaushanScript',
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            SigInButton(),
          ],
        ),
      ),
    );
  }
}
