import 'package:avisonhouse/screens/authenticate/my_article.dart';
import 'package:avisonhouse/screens/authenticate/my_comment.dart';
import 'package:avisonhouse/screens/board/board_detail_page.dart';
import 'package:avisonhouse/screens/widget/house_title_without.dart';
import 'package:flutter/material.dart';
import 'package:avisonhouse/models/user.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthenticatedBoardPage extends StatefulWidget {
  final UserData userData;
  AuthenticatedBoardPage(this.userData);
  @override
  _AuthenticatedBoardPageState createState() => _AuthenticatedBoardPageState();
}

class _AuthenticatedBoardPageState extends State<AuthenticatedBoardPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body:
              ListView(padding: EdgeInsets.all(0), shrinkWrap: true, children: <
                  Widget>[
        Column(
          children: <Widget>[
            HouseTitleWithout(),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Align(
                alignment: Alignment.center,
                child:
                    Text("Board", style: Theme.of(context).textTheme.display1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 12.0, top: 16.0, right: 12.0, bottom: 16.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue[800]),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    )),
                child: Column(children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
                    child: ListTile(
                      dense: true,
                      title: Text("My articles",
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                          )),
                      leading: Icon(
                        Icons.dashboard,
                        color: Colors.purple[300],
                        size: 24,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyArticlePage(widget.userData)),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Divider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      dense: true,
                      title: Text("My comments",
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                          )),
                      leading: Icon(
                        Icons.chat_bubble,
                        color: Colors.cyan,
                        size: 24,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyCommentPage(widget.userData)),
                        );
                      },
                    ),
                  ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                padding: EdgeInsets.only(top: 8.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    )),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
                        dense: true,
                        title: Text("자유 게시판",
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                            )),
                        leading: Icon(
                          Icons.assignment,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BoardDetailPage(widget.userData, 0)),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
                        dense: true,
                        title: Text("대신 전해드려요 게시판",
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                            )),
                        leading: Icon(
                          Icons.assignment,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BoardDetailPage(widget.userData, 1)),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
                        dense: true,
                        title: Text("나눔 게시판",
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                            )),
                        leading: Icon(
                          Icons.assignment,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BoardDetailPage(widget.userData, 2)),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
                        dense: true,
                        title: Text("송도 맛집 게시판",
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                            )),
                        leading: Icon(
                          Icons.assignment,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BoardDetailPage(widget.userData, 3)),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
                        dense: true,
                        title: Text("송도 꿀팁 게시판",
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                            )),
                        leading: Icon(
                          Icons.assignment,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BoardDetailPage(widget.userData, 4)),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
                        dense: true,
                        title: Text("분반모임 추천 게시판",
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                            )),
                        leading: Icon(
                          Icons.assignment,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BoardDetailPage(widget.userData, 5)),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
                        dense: true,
                        title: Text("RA 칭찬 게시판",
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                            )),
                        leading: Icon(
                          Icons.assignment,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BoardDetailPage(widget.userData, 6)),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
                        dense: true,
                        title: Text("건의 게시판",
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                            )),
                        leading: Icon(
                          Icons.assignment,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BoardDetailPage(widget.userData, 7)),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 4.0, top: 4.0, right: 4.0, bottom: 8.0),
                      child: ListTile(
                        dense: true,
                        title: Text("분실물 게시판",
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                            )),
                        leading: Icon(
                          Icons.assignment,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BoardDetailPage(widget.userData, 8)),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
            ),
          ],
        ),
      ])),
    );
  }
}
