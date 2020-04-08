import 'package:avisonhouse/models/program.dart';
import 'package:avisonhouse/screens/board/authenticated_board_page.dart';
import 'package:avisonhouse/screens/diy/new_diy_page.dart';
import 'package:avisonhouse/screens/home/calendar_page.dart';
import 'package:avisonhouse/screens/home/home_page.dart';
import 'package:avisonhouse/screens/home/program_page.dart';
import 'package:avisonhouse/screens/widget/authenticated_custom_drawer.dart';
import 'package:avisonhouse/screens/widget/house_member.dart';
import 'package:avisonhouse/screens/widget/house_title.dart';
import 'package:avisonhouse/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:avisonhouse/services/database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:avisonhouse/models/user.dart';

class AuthenticatedHomePage extends StatefulWidget {
  @override
  _AuthenticatedHomePageState createState() => _AuthenticatedHomePageState();
}

class _AuthenticatedHomePageState extends State<AuthenticatedHomePage>
    with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AnimationController controller;
  Animation<double> animation;

  @override
  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    UserData userData;
    Program program;
    int programLength;
    Map<int, Program> programs = {};

    return StreamBuilder<Object>(
        stream: AuthService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return HomePage();
          } else {
            userData = snapshot.data;
            return SafeArea(
              child: Scaffold(
                resizeToAvoidBottomPadding: false,
                key: _scaffoldKey,
                drawer: Container(
                  width: MediaQuery.of(context).size.width * 2 / 3,
                  child: AuthenticatedCustomDrawer(userData),
                ),
                body: Container(
                  color: Colors.white,
                  child: Column(children: <Widget>[
                    HouseTitle(_scaffoldKey),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3,
                      color: Colors.white,
                      child: FadeTransition(
                        opacity: animation,
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 16.0, bottom: 36.0),
                                child: Container(
                                  child: CircleAvatar(
                                    backgroundImage: ExactAssetImage(
                                        'assets/house/houselogo.png'),
                                    minRadius: 20,
                                    maxRadius: 30,
                                  ),
                                ),
                              ),
                            ),
                            FadeTransition(
                              opacity: animation,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: StreamBuilder<DocumentSnapshot>(
                                      stream: DatabaseService().getMember,
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return houseMember();
                                        } else {
                                          return RichText(
                                              text: TextSpan(
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                  children: <TextSpan>[
                                                TextSpan(
                                                    text: 'A',
                                                    style: TextStyle(
                                                        fontSize: 44,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text: 'VISON HOUSE',
                                                    style: TextStyle(
                                                        fontSize: 28,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text: '는\n\n',
                                                    style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                                TextSpan(
                                                    text: '1',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text: '명의 ',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                                TextSpan(
                                                    text: 'RM ',
                                                    style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text: '교수님과 ',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                                TextSpan(
                                                    text: snapshot.data['ra'],
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text: '명의 ',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                                TextSpan(
                                                    text: 'RA,\n\n',
                                                    style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text: '그리고 ',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                                TextSpan(
                                                    text: snapshot.data['rc'],
                                                    style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text: '명의 ',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                                TextSpan(
                                                    text: '여러분',
                                                    style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text: '으로 구성되었습니다.',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                              ]));
                                        }
                                      }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                    SizedBox(
                      height: 0,
                      child: StreamBuilder<Object>(
                          stream: DatabaseService().programLength,
                          builder: (context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Text('programlength error');
                            } else {
                              programLength = snapshot.data.documents.length;
                              return GridView.count(
                                padding: EdgeInsets.all(0),
                                childAspectRatio: (2 / 3),
                                crossAxisCount: programLength,
                                scrollDirection: Axis.vertical,
                                children:
                                    List.generate(programLength, (_index) {
                                  return Container(
                                    padding: EdgeInsets.all(20.0),
                                    child: StreamBuilder<Object>(
                                        stream:
                                            DatabaseService(id: _index).program,
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Text('Please wait');
                                          } else {
                                            program = snapshot.data;
                                            programs[_index] = program;
                                            return Container();
                                          }
                                        }),
                                  );
                                }),
                              );
                            }
                          }),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProgramPage()),
                                );
                              },
                              child: Container(
                                  child: Center(
                                      child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Flexible(
                                    child: Icon(
                                      CupertinoIcons.collections,
                                      size: 60,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text('PROGRAM',
                                          style: TextStyle(fontSize: 18)),
                                    ),
                                  ),
                                ],
                              ))),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: VerticalDivider(
                              thickness: 1,
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CalendarPage(programs)),
                                );
                              },
                              child: Container(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Flexible(
                                    child: Icon(
                                      Icons.calendar_today,
                                      size: 60,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text('Calendar',
                                          style: TextStyle(fontSize: 18)),
                                    ),
                                  ),
                                ],
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                    Expanded(
                        child: Row(
                      children: <Widget>[
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewDiyPage(userData)),
                            );
                          },
                          child: Container(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: Icon(
                                  Icons.people,
                                  size: 60,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text('LIY / DIY',
                                      style: TextStyle(fontSize: 18)),
                                ),
                              ),
                            ],
                          )),
                        )),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: VerticalDivider(
                            thickness: 1,
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AuthenticatedBoardPage(userData)),
                              );
                            },
                            child: Container(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                  child: Icon(
                                    Icons.assignment,
                                    size: 60,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text('Board',
                                        style: TextStyle(fontSize: 18)),
                                  ),
                                ),
                              ],
                            )),
                          ),
                        ),
                      ],
                    )),
                    Container(
                      height: 60,
                    ),
                  ]),
                ),
              ),
            );
          }
        });
  }
}
