import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertodolist/app/core/models/user_model.dart';
import 'package:fluttertodolist/app/core/services/local_store_service.dart';
import 'package:fluttertodolist/app/core/services/user_service.dart';

class UserServiceImpl implements UserService {
  final _dbService = Modular.get<LocalStoreService>();

  Future<void> saveUser(UserModel user) async {
    await _dbService.put('name', user.name);
    await _dbService.put('email', user.email);
    await _dbService.put('photoUrl', user.photoUrl);
  }

  Future<UserModel> findCurrentUser() async {
    UserModel user = UserModel();
    await _dbService.get('name').then((value) => user.name = value);
    await _dbService.get('email').then((value) => user.email = value);
    await _dbService.get('photoUrl').then((value) => user.photoUrl = value);
    return Future.value(user);
  }

  @override
  Future<void> cleanCurrentUser() async {
    await _dbService.delete('name');
    await _dbService.delete('email');
    await _dbService.delete('photoUrl');
  }
}
