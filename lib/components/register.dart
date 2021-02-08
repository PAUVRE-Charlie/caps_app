import 'dart:io';
import 'dart:math';

import 'package:caps_app/components/loading.dart';
import 'package:caps_app/data.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MyTextFormField.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // textfield state
  String email = '';
  String password = '';
  String username = '';
  String error = '';

  bool loading;

  @override
  void initState() {
    loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final capseurs = Provider.of<List<Capseur>>(context);

    return loading
        ? LoadingWidget()
        : SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  MyTextFormField(
                    hintText: 'Email IMT',
                    textInputType: TextInputType.emailAddress,
                    validator: (val) {
                      return val.isEmpty
                          ? 'Entre ton mail'
                          : !(val.toString().contains('@imt-atlantique.net'))
                              ? 'Vous devez utiliser une adresse imt-atlantique'
                              : null;
                    },
                    onChanged: (val) {
                      email = val;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MyTextFormField(
                    hintText: 'Password',
                    validator: (val) {
                      return val.length < 6
                          ? 'Entre un mot de passe de 6 lettres ou plus'
                          : null;
                    },
                    obscureText: true,
                    onChanged: (val) {
                      password = val;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MyTextFormField(
                    hintText: 'Pseudo',
                    validator: (val) {
                      return val.isEmpty
                          ? 'Entre ton pseudo'
                          : val.toString().length > 10
                              ? '10 caractères max'
                              : null;
                    },
                    onChanged: (val) {
                      username = val;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          loading = true;
                        });

                        for (Capseur capseur in capseurs) {
                          if (capseur.username == username)
                            setState(() {
                              loading = false;
                              error = 'Ce pseudo est déja utilisé';
                            });
                        }
                        if (loading) {
                          dynamic result =
                              await _auth.registerWithEmailAndPassword(
                                  email, password, username);
                          if (result == null) {
                            setState(() {
                              loading = false;
                              error = 'Email ou mot de passe incorrect';
                            });
                          }
                        }
                      }
                    },
                    color: kPrimaryColor,
                    child:
                        Text('Register', style: TextStyle(color: kWhiteColor)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    error,
                    style: TextStyle(color: kPrimaryColor),
                  )
                ],
              ),
            ),
          );
  }
}
