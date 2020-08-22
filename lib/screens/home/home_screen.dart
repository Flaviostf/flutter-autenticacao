import 'package:autenticacao/models/user_model.dart';
import 'package:autenticacao/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen(this.user);

  UserModel user;

  @override
  Widget build(BuildContext context) {
    final login = context.watch<LoginProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              login.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: Text(
              'Sair',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(35),
        child: Text(
          'Bem Vindo ${user.name}',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
