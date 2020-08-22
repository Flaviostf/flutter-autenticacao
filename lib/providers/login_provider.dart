import 'package:autenticacao/helpers/firebase_errors.dart';
import 'package:autenticacao/models/user_model.dart';
import 'package:autenticacao/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class LoginProvider extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore firestore = Firestore.instance;
  final UserProvider userProvider = UserProvider();
  UserModel user = UserModel();

  LoginProvider();

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> signUp(
      {UserModel user, Function onSuccess, Function onError}) async {
    loading = true;
    try {
      final authResult = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);

      user.id = authResult.user.uid;
      await userProvider.createUser(user);
      onSuccess(authResult.user.uid);
      notifyListeners();
    } on PlatformException catch (e) {
      onError(getErrorMessage(e.code));
    }
    loading = false;
  }

  Future<void> signIn(
      {String email,
      String password,
      Function onSuccess,
      Function onError}) async {
    try {
      loading = true;
      final authResult = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      await _loadCurrentUser(firebaseUser: authResult.user);
      onSuccess(user.name);
    } on PlatformException catch (e) {
      onError(getErrorMessage(e.code));
    }
    loading = false;
  }

  Future<void> _loadCurrentUser({FirebaseUser firebaseUser}) async {
    final FirebaseUser currentUser = firebaseUser ?? await auth.currentUser();
    if (currentUser != null) {
      final DocumentSnapshot docUser =
          await firestore.collection('users').document(currentUser.uid).get();
      user = UserModel.fromDocument(docUser);
      notifyListeners();
    }
  }

  void signOut() {
    auth.signOut();
    user = null;
    notifyListeners();
  }
}
