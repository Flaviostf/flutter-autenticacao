import 'package:autenticacao/models/user_model.dart';
import 'package:autenticacao/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  GlobalKey<FormState> formStateKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scafoldStateKey = GlobalKey<ScaffoldState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  UserModel user = UserModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Conta'),
        centerTitle: true,
      ),
      key: scafoldStateKey,
      body: Center(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formStateKey,
            child: Consumer<LoginProvider>(
              builder: (_, loginProvider, __) {
                return ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(16),
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Nome Completo'),
                      autocorrect: false,
                      validator: (name) {
                        return name.isEmpty ? 'Campo Obrigatírio' : null;
                      },
                      onSaved: (name) => user.name = name,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'E-mail'),
                      autocorrect: false,
                      validator: (email) {
                        return email.isEmpty ? 'Campo Obrigatírio' : null;
                      },
                      onSaved: (email) => user.email = email,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Senha'),
                      autocorrect: false,
                      obscureText: true,
                      validator: (pass) {
                        return pass.isEmpty ? 'Campo Obrigatírio' : null;
                      },
                      onSaved: (pass) => user.password = pass,
                      controller: passwordController,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Confirme a senha'),
                      autocorrect: false,
                      obscureText: true,
                      validator: (confirmPass) {
                        return confirmPass.isEmpty
                            ? 'Campo Obrigatírio'
                            : confirmPass != passwordController.text
                                ? 'As senhas devem ser iguais'
                                : null;
                      },
                      controller: confirmPasswordController,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    RaisedButton(
                      onPressed: loginProvider.loading
                          ? null
                          : () {
                              if (formStateKey.currentState.validate()) {
                                formStateKey.currentState.save();
                                loginProvider.signUp(
                                  user: user,
                                  onError: (e) {
                                    scafoldStateKey.currentState.showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Falha ao criar a conta: $e'),
                                          backgroundColor: Colors.red),
                                    );
                                  },
                                  onSuccess: (success) {
                                    Navigator.of(context).pop();
                                  },
                                );
                              }
                            },
                      color: Theme.of(context).primaryColor,
                      disabledColor:
                          Theme.of(context).primaryColor.withAlpha(100),
                      textColor: Colors.white,
                      child: loginProvider.loading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white))
                          : Text(
                              'Criar Conta',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
