

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/service/auth_service.dart';
import 'package:todo_list/service/database_service.dart';
import 'package:todo_list/shared/input_decoration_auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({super.key, required void Function() this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool passwordVisible = true;
  bool _passwordConfirmed = false;
  final AuthService _authService = AuthService();

  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  late String email;
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? const CircularProgressIndicator()
        : Scaffold(
            backgroundColor: const Color.fromARGB(249, 238, 232, 232),
            body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50.0,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                          height: 40.0,
                        ),
                          Image.asset(
                            'images/img.jpeg',
                            width: 300.0,
                          ),
                      const SizedBox(
                        height: 60.0,
                      ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 50.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: textInputDecoration
                                        .copyWith(hintText: 'Email')
                                        .copyWith(
                                            prefixIcon:
                                                const Icon(Icons.email_outlined)),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter an email';
                                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                    onChanged: (val) {
                                      setState(() {
                                        email = val;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 20.0),
                                  TextFormField(
                                    decoration: textInputDecoration
                                        .copyWith(hintText: 'Password')
                                        .copyWith(
                                            prefixIcon: const Icon(Icons.lock_outline))
                                        .copyWith(
                                          suffixIcon: IconButton(
                                            icon: Icon(passwordVisible
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                            onPressed: () {
                                              setState(
                                                () {
                                                  passwordVisible = !passwordVisible;
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                    validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    if (value.length < 6) {
                                      return 'Password must be at least 6 characters long';
                                    }
                                    if (!RegExp(
                                            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)')
                                        .hasMatch(value)) {
                                      return 'Password must contain at least one uppercase letter, one lowercase letter, and one digit';
                                    }
                                    return null;
                                  },
                                    obscureText: passwordVisible,
                                    onChanged: (val) {
                                      password = val;
                                    },
                                  ),
                                  const SizedBox(height: 20.0),
                                  TextFormField(
                                  decoration: textInputDecoration
                                      .copyWith(hintText: 'Confirm Password')
                                      .copyWith(
                                        suffixIcon: IconButton(
                                          icon: Icon(passwordVisible
                                              ? Icons.visibility_off
                                              : Icons.visibility),
                                          onPressed: () {
                                            setState(
                                              () {
                                                passwordVisible =
                                                    !passwordVisible;
                                              },
                                            );
                                          },
                                        ),
                                      )
                                      .copyWith(
                                          prefixIcon: const Icon(
                                              Icons.check_box_outlined)),
                                  validator: (value) {
                                    if (value != password || value!.isEmpty) {
                                      _passwordConfirmed = false;
                                      return 'Please re-enter your password';
                                    } else {
                                      _passwordConfirmed = true;
                                      return null;
                                    }
                                  },
                                  obscureText: passwordVisible,
                                ),
                                  const SizedBox(height: 40.0),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(255, 15, 65, 132),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate() &&
                                          _passwordConfirmed) {
                                        setState(() {
                                          loading = true;
                                        });
                                        dynamic result = await _authService
                                            .registerWithEmailAndPassword(
                                                email, password);
                                        if (result != null) {
                                          User? user =
                                              FirebaseAuth.instance.currentUser;
                                          final DatabaseService databaseService =
                                              DatabaseService(uid: user!.uid);
                                          await databaseService.createUser(
                                              email);
                                          widget.toggleView();
                                        } else {
                                          setState(() {
                                            error = 'Could not register!';
                                            loading = false;
                                          });
                                        }
                                      }
                                    },
                                    child: const Text(
                                      'Create an account',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Text('You already have an account ?'),
                                      TextButton(
                                        onPressed: () {
                                          widget.toggleView();
                                        },
                                        child: Text(
                                          'Sign in',
                                          style:
                                              TextStyle(color: Colors.lightBlue[900]),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    error,
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 174, 9, 31),
                                        fontSize: 14.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          );
  }
}
