abstract class LocalStoreService {
  Future<dynamic> get(String key);
  Future<bool> put(String key, dynamic value);
  Future<bool> delete(String key);
}
