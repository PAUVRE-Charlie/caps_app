import 'package:caps_app/components/MyTextFormField.dart';
import 'package:caps_app/components/arrowBackAppBar.dart';
import 'package:caps_app/components/background.dart';
import 'package:caps_app/components/loading.dart';
import 'package:caps_app/data.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';


class ResetPage extends StatefulWidget {
  @override
  _ResetPageState createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  // textfield state
  String email = '';
  String error = '';

  bool loading;

  @override
  void initState() {
    loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundBaseColor,
        shadowColor: Colors.transparent,
        leading: ArrowBackAppBar(),
        centerTitle: true,
        title: Text("Caps",
            style: TextStyle(
                color: kPrimaryColor, fontFamily: 'PirataOne', fontSize: 40)),
      ),
      body: Stack(
        children: [
          Background(),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(30),
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
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      try{
                        await _auth.sendPasswordResetEmail(email: email);
                        Fluttertoast.showToast(msg: 'Un lien pour réinitialiser votre mot de passe vient de vous être envoyé par mail');
                        Navigator.of(context).pop();
                      }catch(signUpError){
                        print(signUpError.code);
                          if(signUpError.code == 'user-not-found') {
                            Fluttertoast.showToast(msg: 'Cet email n\'existe pas, réessayez');
                          }
                      }
                    },
                    color: kPrimaryColor,
                    child:
                    Text('Réinitialiser le mot de passe', style: TextStyle(color: kWhiteColor)),
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
          )
        ],
      ),
    );


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
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: ()  {

              },
              color: kPrimaryColor,
              child:
              Text('Réinitialiser le mot de passe', style: TextStyle(color: kWhiteColor)),
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
