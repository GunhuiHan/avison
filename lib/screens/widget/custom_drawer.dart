import 'package:avisonhouse/screens/authenticate/login_page.dart';
import 'package:avisonhouse/screens/authenticate/register_page.dart';
import 'package:avisonhouse/screens/detail/info_page.dart';
import 'package:avisonhouse/screens/detail/question_page.dart';
import 'package:flutter/material.dart';
import 'package:avisonhouse/screens/detail/ra_card.dart';

class CustomDrawer extends StatelessWidget {
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
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, top: 18.0),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white)),
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, top: 18.0),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white)),
                          child: Text(
                            "Register",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()),
                            );
                          },
                        ),
                      ),
                    ],
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
