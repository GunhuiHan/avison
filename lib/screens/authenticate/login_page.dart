import 'package:avisonhouse/screens/widget/alert.dart';
import 'package:avisonhouse/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avisonhouse/models/user.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthResult _result;
    FirebaseUser user;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Login"),
          ),
          body: Container(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                  child: Form(
                key: _loginFormKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Email*', hintText: "avison@gmail.com"),
                      controller: emailInputController,
                      keyboardType: TextInputType.visiblePassword,
                      validator: emailValidator,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Password*', hintText: "********"),
                      controller: pwdInputController,
                      obscureText: true,
                      validator: pwdValidator,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                        child: Text("Login"),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: () {
                          if (_loginFormKey.currentState.validate()) {
                            signingAlert(context);
                            FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: emailInputController.text,
                                    password: pwdInputController.text)
                                .then((currentUser) => Firestore.instance
                                        .collection("users")
                                        .document(currentUser.user.uid)
                                        .get()
                                        .then((DocumentSnapshot result) {
                                      _result = currentUser;
                                      user = _result.user;
                                      _userFromFirebaseUser(user);
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    }).catchError((err) => print(err)))
                                .catchError((err) {
                              if (err is PlatformException) {
                                if (err.code == 'ERROR_USER_NOT_FOUND') {
                                  print(err);
                                  logInAlert(context);
                                }
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )))),
    );
  }

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }
}
