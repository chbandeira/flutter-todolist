import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertodolist/app/modules/home/home_page.dart';
import 'package:fluttertodolist/app/modules/item/item_page.dart';

class HomeModule extends ChildModule {
  @override
  List<Bind> get binds => [];

  @override
  List<Router> get routers => [
        Router('/', child: (context, args) => HomePage()),
        Router('/item', child: (context, args) => ItemPage()),
      ];
}
