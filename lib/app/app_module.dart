import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertodolist/app/app_controller.dart';
import 'package:fluttertodolist/app/app_widget.dart';
import 'package:fluttertodolist/app/core/services/local_store_service.dart';
import 'package:fluttertodolist/app/core/services/local_store_service_impl.dart';
import 'package:fluttertodolist/app/core/services/user_service.dart';
import 'package:fluttertodolist/app/core/services/user_service_impl.dart';
import 'package:fluttertodolist/app/core/utils/route_names.dart';
import 'package:fluttertodolist/app/modules/home/home_module.dart';
import 'package:fluttertodolist/app/modules/item/item_module.dart';
import 'package:fluttertodolist/app/modules/item/repositories/item_repository.dart';
import 'package:fluttertodolist/app/modules/item/repositories/item_repository_impl.dart';
import 'package:fluttertodolist/app/modules/login/login_module.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        Bind<UserService>((i) => UserServiceImpl()),
        Bind<LocalStoreService>((i) => LocalStoreServiceImpl()),
        Bind<ItemRepository>((i) => ItemRepositoryImpl()),
        Bind((i) => AppController()),
      ];

  @override
  Widget get bootstrap => AppWidget();

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute, module: LoginModule()),
        Router(RouteNames.home, module: HomeModule()),
        Router(RouteNames.item, module: ItemModule()),
      ];
}
