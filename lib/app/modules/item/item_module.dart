import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertodolist/app/modules/item/item_page.dart';
import 'package:fluttertodolist/app/modules/item/repositories/item_repository.dart';
import 'package:fluttertodolist/app/modules/item/repositories/item_repository_impl.dart';

class ItemModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind<ItemRepository>((i) => ItemRepositoryImpl(), lazy: false),
      ];

  @override
  List<Router> get routers => [
        Router('/', child: (context, args) => ItemPage()),
      ];
}
