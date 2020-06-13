import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertodolist/app/modules/login/services/login_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertodolist/app/core/models/user_model.dart';
import 'package:fluttertodolist/app/core/services/user_service.dart';

class LoginServiceImpl implements LoginService {
  final _userService = Modular.get<UserService>();

  @override
  Future<bool> isSignedIn() async {
    try {
      return await GoogleSignIn().isSignedIn();
    } catch (error) {
      print(error);
    }
    return Future.value(false);
  }

  @override
  Future<bool> signIn() async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final googleSignIn = GoogleSignIn();

      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult =
          await firebaseAuth.signInWithCredential(credential);

      final FirebaseUser user = authResult.user;
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await firebaseAuth.currentUser();
      assert(user.uid == currentUser.uid);

      await _userService.saveUser(UserModel(
        name: googleSignIn.currentUser.displayName,
        email: googleSignIn.currentUser.email,
        photoUrl: googleSignIn.currentUser.photoUrl,
      ));

      return true;
    } catch (error) {
      print(error);
    }
    return false;
  }

  @override
  Future<void> signOut() async {
    try {
      await GoogleSignIn().disconnect();
      await _userService.cleanCurrentUser();
    } catch (error) {
      print(error);
    }
  }
}
