import 'package:fluttertodolist/app/core/services/local_store_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStoreServiceImpl implements LocalStoreService {
  @override
  Future<dynamic> get(String key) async {
    var shared = await SharedPreferences.getInstance();
    return shared.get(key);
  }

  @override
  Future<bool> put(String key, dynamic value) async {
    var shared = await SharedPreferences.getInstance();
    if (value is bool) {
      return shared.setBool(key, value);
    }
    if (value is String) {
      return shared.setString(key, value);
    }
    if (value is int) {
      return shared.setInt(key, value);
    }
    if (value is double) {
      return shared.setDouble(key, value);
    }
    return false;
  }

  @override
  Future<bool> delete(String key) async {
    var shared = await SharedPreferences.getInstance();
    return shared.remove(key);
  }
}
