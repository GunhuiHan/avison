
import 'package:avisonhouse/controller/main_controller.dart';
import 'package:avisonhouse/detail/info_page.dart';
import 'package:avisonhouse/detail/question_page.dart';
import 'package:avisonhouse/detail/ra_card.dart';
import 'package:avisonhouse/pages/auth/joinPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatelessWidget {
  MainController _controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, // place the logout at the end of the drawer
        children: <Widget>[
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.only(left: 24.0, top: 18.0),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.white)),
                      child: Text(
                        _controller.isRa.value ? "Logout" : "Login",
                        style: TextStyle(fontSize: 14),
                      ),
                      onPressed: _controller.isRa.value ? () {
                        FirebaseAuth.instance.signOut();
                        _controller.joinRa(false);
                      } : () {
                        Get.back();
                        Get.to(JoinPage());
                      },
                    ),
                  ),
                ),
                ListTile(
                  contentPadding:
                  EdgeInsets.only(left: 16, top: 12, right: 16, bottom: 4),
                  dense: true,
                  title: Text(
                    "기숙사 정보\nDormitory info",
                    style: TextStyle(fontSize: 14),
                  ),
                  leading: Icon(Icons.contacts),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InfoPage()),
                    );
                  },
                ),
                ListTile(
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  dense: true,
                  title: Text(
                    "RA\n(Residential Assistants)",
                    style: TextStyle(fontSize: 14),
                  ),
                  leading: Icon(Icons.people),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RaCard()),
                    );
                  },
                ),
                ListTile(
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuestionPage()),
                      );
                    },
                    dense: true,
                    title: Text(
                      "문의\nQuestion",
                      style: TextStyle(fontSize: 14),
                    ),
                    leading: Icon(Icons.question_answer)),
                Divider(),
              ],
            ),
          ),
          ListTile(
              onTap: () {
                Navigator.pop(context);
              },
              dense: false,
              title: Text(
                "Home",
                style: TextStyle(fontSize: 16),
              ),
              trailing: Text(
                "AVISON 2.0",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              leading: Icon(
                Icons.home,
                size: 24,
              )),
        ],
      ),
    );
  }
}