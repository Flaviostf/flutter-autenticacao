import 'package:autenticacao/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider {
  Future<void> createUser(UserModel user) async {
    final String id = user.id;
    await Firestore.instance.document('users/$id').setData(toMap(user));
  }

  Map<String, dynamic> toMap(UserModel user) {
    return {'name': user.name, 'email': user.email};
  }
}
