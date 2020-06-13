import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertodolist/app/core/utils/route_names.dart';
import 'package:fluttertodolist/app/modules/login/services/login_service.dart';

class SigInButton extends StatelessWidget {
  final _loginService = Modular.get<LoginService>();

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.white,
      splashColor: Colors.grey,
      onPressed: () => _handleSignIn().then((isSignIn) {
        if (isSignIn) {
          Modular.to.pushNamed(RouteNames.home);
        }
      }).catchError(
        (error) => print(error),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 20,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
                image: AssetImage('assets/images/google_logo.png'),
                height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _handleSignIn() async => await _loginService.signIn();
}
