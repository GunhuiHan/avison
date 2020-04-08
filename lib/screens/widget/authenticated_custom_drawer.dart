import 'package:avisonhouse/screens/detail/info_page.dart';
import 'package:avisonhouse/screens/detail/question_page.dart';
import 'package:flutter/material.dart';
import 'package:avisonhouse/models/user.dart';
import 'package:avisonhouse/services/auth.dart';
import 'package:avisonhouse/screens/detail/ra_card.dart';

class AuthenticatedCustomDrawer extends StatefulWidget {
  final UserData userData;
  AuthenticatedCustomDrawer(this.userData);
  @override
  _AuthenticatedCustomDrawerState createState() =>
      _AuthenticatedCustomDrawerState();
}

class _AuthenticatedCustomDrawerState extends State<AuthenticatedCustomDrawer> {
  final AuthService _auth = AuthService();
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
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  accountName: Padding(
                    child: Text(
                      '${widget.userData.userName}',
                      style: TextStyle(fontSize: 24),
                    ),
                    padding: EdgeInsets.only(left: 4, top: 12),
                  ),
                  accountEmail: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 4),
                    child: Text("${widget.userData.userRoom}"),
                  ),
                  currentAccountPicture: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      minRadius: 20,
                      maxRadius: 28,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 4, horizontal: 16),
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
                ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      await _auth.signOut();
                    },
                    dense: true,
                    title: Text("SignOut"),
                    leading: Icon(Icons.exit_to_app)),
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
                "AVISON 1.0",
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
