import 'package:fluttertodolist/app/core/models/user_model.dart';

abstract class UserService {
  Future<void> saveUser(UserModel user);
  Future<UserModel> findCurrentUser();
  Future<void> cleanCurrentUser();
}
