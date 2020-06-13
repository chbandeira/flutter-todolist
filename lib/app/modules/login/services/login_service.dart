abstract class LoginService {
  Future<bool> isSignedIn();
  Future<bool> signIn();
  Future<void> signOut();
}
