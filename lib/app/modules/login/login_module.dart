import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertodolist/app/modules/login/login_page.dart';
import 'package:fluttertodolist/app/modules/login/services/login_service.dart';
import 'package:fluttertodolist/app/modules/login/services/login_service_impl.dart';

class LoginModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind<LoginService>((i) => LoginServiceImpl(), lazy: false),
      ];

  @override
  List<Router> get routers => [
        Router('/', child: (context, args) => LoginPage()),
      ];
}
