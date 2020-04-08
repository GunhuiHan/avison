import 'package:avisonhouse/models/user.dart';
import 'package:avisonhouse/screens/widget/alert.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController idInputController;
//  TextEditingController nameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;
  String realName;
  String room;

  @override
  initState() {
    idInputController = TextEditingController();
//    nameInputController =  TextEditingController();
    emailInputController = TextEditingController();
    pwdInputController = TextEditingController();
    confirmPwdInputController = TextEditingController();
    super.initState();
  }

//  String emailValidator(String value) {
//    Pattern pattern =
//        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//    RegExp regex = new RegExp(pattern);
//    if (!regex.hasMatch(value)) {
//      return 'Email format is invalid';
//    } else {
//      return null;
//    }
//  }

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
            title: Text("Register"),
          ),
          body: Container(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                  child: Form(
                key: _registerFormKey,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Student ID*',
                                hintText: "2020123001"),
                            controller: idInputController,
                            keyboardType: TextInputType.visiblePassword,
                          ),
                        ),
                        ButtonTheme(
                          buttonColor: Theme.of(context).primaryColor,
                          child: RaisedButton(
                            elevation: 1,
                            child: Text(
                              'validate',
                              style: Theme.of(context)
                                  .textTheme
                                  .body2
                                  .copyWith(color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)),
                            onPressed: () {
                              var studentRef = FirebaseDatabase()
                                  .reference()
                                  .child('user_validation');
                              studentRef
                                  .orderByKey()
                                  .equalTo(idInputController.text)
                                  .once()
                                  .then((DataSnapshot snapshot) {
                                if (snapshot.value == null) {
                                  return validateAlert(context);
                                } else {
                                  Map<dynamic, dynamic> values = snapshot.value;
                                  setState(() {
                                    realName =
                                        values[idInputController.text]['name'];
                                  });
                                  setState(() {
                                    room =
                                        values[idInputController.text]['room'];
                                  });
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Row(
                        children: <Widget>[
                          _studentName(),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 10,
                      color: Colors.grey[300],
                    ),
//                    TextFormField(
//                      decoration: InputDecoration(
//                          labelText: 'Nickname(Displayed)*',
//                          hintText: "avison"),
//                      controller: nameInputController,
//                      validator: (value) {
//                        if (value.length < 3) {
//                          return "Name must be longer than 3 characters";
//                        } else if (value.length > 20) {
//                          return "Please enter less than 20 characters";
//                        } else
//                          return null;
//                      },
//                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Email*', hintText: "avison@gmail.com"),
                      controller: emailInputController,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Password*', hintText: "********"),
                      controller: pwdInputController,
                      obscureText: true,
                      validator: pwdValidator,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Confirm Password*', hintText: "********"),
                      controller: confirmPwdInputController,
                      obscureText: true,
                      validator: pwdValidator,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text('**입력한 내용은 수정이 불가능합니다**',
                          style: TextStyle(fontSize: 14)),
                    ),
                    Text(
                      '**You cannot edit what you have entered**',
                      style: TextStyle(fontSize: 14),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                        child: Text("Register"),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: () {
                          if (_registerFormKey.currentState.validate() &&
                              !(realName == null)) {
                            if (pwdInputController.text ==
                                confirmPwdInputController.text) {
                              registerAlert(context);
                              FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: emailInputController.text,
                                      password: pwdInputController.text)
                                  .then((currentUser) {
                                Firestore.instance
                                    .collection("users")
                                    .document(currentUser.user.uid)
                                    .setData({
                                  "uid": currentUser.user.uid,
                                  "name": realName,
                                  "real_rame": realName,
                                  "room": room,
                                  "email": emailInputController.text,
                                }).then((result) {
                                  _result = currentUser;
                                  user = _result.user;
                                  _userFromFirebaseUser(user);
//                                        nameInputController.clear();
                                  emailInputController.clear();
                                  pwdInputController.clear();
                                  confirmPwdInputController.clear();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                }).catchError((err) => print(err));
                              }).catchError((err) {
                                if (err is PlatformException) {
                                  if (err.code ==
                                      'ERROR_EMAIL_ALREADY_IN_USE') {
                                    print(err);
                                    emailAlert(context);
                                  }
                                }
                              });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Error"),
                                      content:
                                          Text("The passwords do not match"),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("Close"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    );
                                  });
                            }
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

  Widget _studentName() {
    if (realName == null) {
      return Flexible(
        child: Text(
          'Please enter your student number above',
          style: Theme.of(context).textTheme.body2.copyWith(color: Colors.red),
        ),
      );
    } else {
      return Expanded(
          child: Text('Name: ' + realName + ', ' + 'Room: ' + room,
              style: Theme.of(context).textTheme.body2));
    }
  }
}
