import 'package:autenticacao/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formStateKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entrar'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      key: scaffoldStateKey,
      body: Center(
        child: Consumer<LoginProvider>(
          builder: (_, loginProvider, __) {
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: formStateKey,
                child: ListView(
                  padding: EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: <Widget>[
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(hintText: 'Usuário'),
                      validator: (user) {
                        return user.isEmpty ? 'Campo Obrigatório' : null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(hintText: 'Senha'),
                      obscureText: true,
                      validator: (pass) {
                        return pass.isEmpty ? 'Campo Obrigatório' : null;
                      },
                      autocorrect: false,
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                          padding: EdgeInsets.zero,
                          child: Text('Criar Conta'),
                          onPressed: () {
                            Navigator.of(context).pushNamed('/signup');
                          },
                        )),
                    SizedBox(
                      height: 16,
                    ),
                    RaisedButton(
                        onPressed: loginProvider.loading
                            ? null
                            : () {
                                if (formStateKey.currentState.validate()) {
                                  loginProvider.signIn(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    onError: (e) {
                                      scaffoldStateKey.currentState
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text('Falha ao Logar: $e'),
                                            backgroundColor: Colors.red),
                                      );
                                    },
                                    onSuccess: (s) {
                                      Navigator.of(context)
                                          .pushReplacementNamed('/home',
                                              arguments: loginProvider.user);
                                    },
                                  );
                                }
                              },
                        child: loginProvider.loading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white))
                            : Text(
                                'Entrar',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                        color: Theme.of(context).primaryColor,
                        disabledColor:
                            Theme.of(context).primaryColor.withAlpha(100)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
