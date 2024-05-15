import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:todo_list/authentication/register.dart';
import 'package:todo_list/authentication/sign_in.dart';
import 'package:todo_list/main.dart';
import 'package:todo_list/models/user.dart';
import 'package:todo_list/service/auth_service.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});
  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final AuthService _authService = AuthService();

  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  // Instanciez votre service d'authentification
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CustomUser?>(
      stream: _authService.user, // Utilisez le flux d'utilisateur de votre service d'authentification
      builder: (BuildContext context, AsyncSnapshot<CustomUser?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SpinKitFoldingCube(
            color: Color.fromARGB(255, 15, 64, 129),
            size: 35.0,
          );
        } else {
          if (snapshot.hasData) {
            // L'utilisateur est authentifié, renvoyez Home avec l'uid
            return Home(uid: snapshot.data!.uid);
          } else {
            if (showSignIn) {
              return SignIn(toggleView: toggleView);
            } else {
              return Register(toggleView: toggleView);
            }
          }
        }
      },
    );
  }
}