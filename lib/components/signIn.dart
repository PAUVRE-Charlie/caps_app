import 'package:caps_app/components/loading.dart';
import 'package:caps_app/data.dart';
import 'package:caps_app/pages/resetPage.dart';
import 'package:caps_app/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'MyTextFormField.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // textfield state
  String email = '';
  String password = '';
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
                    hintText: 'Mot de passe',
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
                  RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          loading = true;
                        });
                        dynamic result = await _auth.signInWithEmailAndPassword(
                            email, password);
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
                        Text('Se connecter', style: TextStyle(color: kWhiteColor)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: Text('Mot de passe oublié ?', style: TextStyle(color: kSecondaryColor),),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPage()));
                        },)
                    ],
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
