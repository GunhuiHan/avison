import 'package:avisonhouse/controller/main_controller.dart';
import 'package:avisonhouse/pages/lobby.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoinPage extends StatefulWidget {
  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            color: Colors.white,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _logoImage(),
              Stack(
                children: <Widget>[
                  _inputForm(size),
                  _authButton(size),
                ],
              ),
              Container(
                height: size.height * 0.04,
              ),
            ],
          )
        ],
      ),
    );
  }

  void _login(BuildContext context) async {
    Get.dialog(Center(child: CircularProgressIndicator()));
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text)
        .then((value) {
          Get.offAll(LobbyPage());
          Get.defaultDialog(title: "알림", middleText: "RA로 로그인 되었습니다.");
        })
        .catchError((e) {
      Get.back();
      Get.dialog(Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: RichText(
          text: TextSpan(text: e.toString()),
        ),
      )));
    });
  }

  Widget _logoImage() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 40,
          left: 15,
          right: 15,
        ),
        child: FittedBox(
          fit: BoxFit.contain,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Image.asset('assets/house/houselogo.png'),
          ),
        ),
      ),
    );
  }

  Widget _inputForm(Size size) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 13, right: 13, top: 14, bottom: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(icon: Icon(Icons.account_circle), labelText: '이메일'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return '알맞은 이메일을 입력해주세요.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(icon: Icon(Icons.vpn_key), labelText: '비밀번호'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return '알맞은 비밀번호를 입력해주세요.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _authButton(Size size) {
    return Positioned(
      left: size.width * 0.2,
      right: size.width * 0.2,
      bottom: 0,
      child: SizedBox(
        height: 40,
        child: RaisedButton(
          child: Text(
            '로그인',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          color: Get.theme.primaryColorLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _login(context);
            }
          },
        ),
      ),
    );
  }
}
