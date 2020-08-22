import 'package:autenticacao/providers/login_provider.dart';
import 'package:autenticacao/providers/user_provider.dart';
import 'package:autenticacao/screens/home/home_screen.dart';
import 'package:autenticacao/screens/login/login_screen.dart';
import 'package:autenticacao/screens/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginProvider(),
          lazy: false,
        ),
        Provider(
          create: (_) => UserProvider(),
          lazy: false,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Color(0xff283e4a),
          primaryColor: Color(0xff283e4a),
        ),
        // initialRoute: '/login',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/signup':
              return MaterialPageRoute(
                builder: (_) => SignupScreen(),
              );
            case '/home':
              return MaterialPageRoute(
                builder: (_) => HomeScreen(settings.arguments as UserModel),
              );
            case '/login':
            default:
              return MaterialPageRoute(
                builder: (_) => LoginScreen(),
              );
          }
        },
      ),
    );
  }
}
