import 'dart:io';
import 'dart:math';

import 'package:caps_app/components/loading.dart';
import 'package:caps_app/data.dart';
import 'package:caps_app/services/auth.dart';
import 'package:flutter/material.dart';

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
  String firstname = '';
  String lastname = '';
  String error = '';

  bool loading;

  @override
  void initState() {
    loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    hintText: 'Email',
                    textInputType: TextInputType.emailAddress,
                    validator: (val) {
                      return val.isEmpty ? 'Entre ton mail' : null;
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
                    hintText: 'Prénom',
                    validator: (val) {
                      return val.isEmpty ? 'Entre ton prénom' : null;
                    },
                    onChanged: (val) {
                      firstname = val;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MyTextFormField(
                    hintText: 'Nom',
                    validator: (val) {
                      return val.isEmpty ? 'Entre ton nom' : null;
                    },
                    onChanged: (val) {
                      lastname = val;
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
                        dynamic result =
                            await _auth.registerWithEmailAndPassword(
                                email, password, firstname, lastname);
                        if (result == null) {
                          setState(() {
                            loading = false;
                            error = 'Email ou mot de passe incorrect';
                          });
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
