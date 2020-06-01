import 'package:avisonhouse/models/user.dart';
import 'package:avisonhouse/screens/widget/alert.dart';
import 'package:avisonhouse/screens/widget/article_widget.dart';
import 'package:avisonhouse/screens/widget/name_or_anonymous.dart';
import 'package:avisonhouse/services/database.dart';
import 'package:avisonhouse/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Article extends StatefulWidget {
  final int boardNum;
  final String articleKey;
  final UserData user;
  Article(this.boardNum, this.articleKey, this.user);
  @override
  _ArticleState createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _commentController;
  FocusNode _focusNode = new FocusNode();
  bool anonymous = false;

  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  String commentValidator(String value) {
    if (value.length < 2) {
      return 'comment is empty';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context1) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            DatabaseService(boardNum: widget.boardNum).boardName(),
            style: Theme.of(context1)
                .textTheme
                .display2
                .copyWith(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: DatabaseService(
                    articleKey: widget.articleKey, boardNum: widget.boardNum)
                .getArticle,
            builder: (context2, snapshot) {
              if (!snapshot.hasData || snapshot.data.data == null) {
                return Center(
                  child: Text('삭제된 게시물입니다.'),
                );
              } else {
                var doc = snapshot.data;
                return Stack(children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _focusNode.unfocus(); //3 - call this method here
                    },
                    child: ListView(
                      padding: EdgeInsets.all(0),
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 24.0, top: 32, right: 24),
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  minRadius: 20,
                                  maxRadius: 20,
                                  backgroundColor: Colors.blueGrey[200],
                                  child: Icon(
                                    Icons.person,
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      nameOrAnonymousArticle(doc['anonymous'],
                                          doc['name'], doc['room']),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      updateOrDelete(
                                          widget.boardNum,
                                          widget.articleKey,
                                          doc['uid'],
                                          widget.user,
                                          doc,
                                          context1),
                                      Text(
                                        timeDifference(doc['date_time']),
                                        style: Theme.of(context1)
                                            .textTheme
                                            .body2
                                            .copyWith(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 24.0, top: 8.0, right: 24.0),
                              child: Text(doc['title'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 24.0, top: 8.0),
                              child: Text(
                                doc['body'],
                                style: Theme.of(context1).textTheme.body2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 24.0, right: 24.0, bottom: 12, top: 8),
                              child: Row(
                                children: <Widget>[
                                  StreamBuilder(
                                      stream: DatabaseService(
                                        boardNum: widget.boardNum,
                                        articleKey: widget.articleKey,
                                      ).likesNum,
                                      builder: (context, snapshot2) {
                                        if (!snapshot2.hasData) {
                                          return loading();
                                        } else {
                                          int likes =
                                              snapshot2.data.documents.length;
                                          return Text(
                                            '$likes Likes',
                                            style: Theme.of(context)
                                                .textTheme
                                                .body2
                                                .copyWith(),
                                          );
                                        }
                                      }),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      return LikeAlert.likeAlert(
                                          context,
                                          widget.boardNum,
                                          widget.articleKey,
                                          widget.user,
                                          _scaffoldKey);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 2),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.favorite_border,
                                              size: 14,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Text(
                                                'Like',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .body1
                                                    .copyWith(fontSize: 12),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: DatabaseService(
                                    boardNum: widget.boardNum,
                                    articleKey: widget.articleKey)
                                .getComment,
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: Text('Loading...'),
                                );
                              } else {
                                return ListView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.all(0),
                                  shrinkWrap: true,
                                  children: getComment(snapshot),
                                );
                              }
                            }),
                        SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      padding: EdgeInsets.only(right: 12, bottom: 12),
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Column(
                              children: <Widget>[
                                Checkbox(
                                  value: anonymous,
                                  onChanged: (bool value) {
                                    setState(() {
                                      anonymous = value;
                                    });
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 4.0,
                                  ),
                                  child: Text(
                                    '익명',
                                    style: Theme.of(context).textTheme.body2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: TextFormField(
                              focusNode: _focusNode,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              controller: _commentController,
                              decoration: InputDecoration.collapsed(
                                hintText: "Write a comment",
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(color: Colors.grey),
                              ),
                              style: Theme.of(context).textTheme.body2,
                              validator: commentValidator,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: GestureDetector(
                                onTap: () {
                                  String time = generateDbTimeKey();
                                  String date = generateDate();
                                  DateTime dateTime = generateDateTime();

                                  Firestore.instance
                                      .collection(DatabaseService(
                                              boardNum: widget.boardNum)
                                          .boardTitle())
                                      .document("${widget.articleKey}")
                                      .collection('comment')
                                      .document(time + widget.user.uid)
                                      .setData({
                                    "uid": widget.user.uid,
                                    "name": widget.user.userName,
                                    "comment": _commentController.text,
                                    "room": widget.user.userRoom,
                                    "date": date,
                                    "date_time": dateTime,
                                    "time_key": time + widget.user.uid,
                                    "anonymous": anonymous
                                  });
                                  Firestore.instance
                                      .collection('users')
                                      .document(widget.user.uid)
                                      .collection('my_comment')
                                      .document(time + widget.user.uid)
                                      .setData({
                                    "uid": widget.user.uid,
                                    "name": widget.user.userName,
                                    "comment": _commentController.text,
                                    "room": widget.user.userRoom,
                                    "date": date,
                                    "date_time": dateTime,
                                    "time_key": time + widget.user.uid,
                                    "board_num": widget.boardNum,
                                    "time_key_article": widget.articleKey,
                                    "anonymous": anonymous
                                  });

                                  _commentController.clear();
                                },
                                child: Text(
                                  'Post',
                                  style: Theme.of(context)
                                      .textTheme
                                      .body1
                                      .copyWith(
                                          fontSize: 20,
                                          color:
                                              Theme.of(context).primaryColor),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]);
              }
            }),
      ),
    );
  }

  String timeDifference(Timestamp time) {
    DateTime _time = time.toDate();
    var formatDate1 = DateFormat('MMM d');
    var formatDate2 = DateFormat('yyyy MM dd');
    DateTime now = DateTime.now();
    int difference = now.difference(_time).inMinutes;

    if (formatDate2.format(now) == formatDate2.format(_time)) {
      if (difference >= 60) {
        return '${now.difference(_time).inHours} hrs. ago';
      } else {
        return '$difference min. ago';
      }
    } else {
      return formatDate1.format(_time);
    }
  }

  String generateDbTimeKey() {
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('MMM d, ');
    var formatTime = DateFormat('hh:mm aaa ss, EEEE, yyyy');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    return date + time;
  }

  String generateDate() {
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('MMM d');

    String date = formatDate.format(dbTimeKey);

    return date;
  }

  DateTime generateDateTime() {
    var time = DateTime.now();

    return time;
  }

  getComment(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) => Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 2.0, right: 12.0),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          minRadius: 12,
                          maxRadius: 14,
                          backgroundColor: Colors.blueGrey[200],
                          child: Icon(
                            Icons.person,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: nameOrAnonymousComment(
                                  doc['anonymous'], doc['name'])),
                        ),
                        Spacer(),
                        Expanded(
                          flex: 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                timeDifference(
                                  doc['date_time'],
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .body2
                                    .copyWith(fontSize: 12),
                              ),
                              updateOrDeleteComment(
                                  widget.boardNum,
                                  widget.articleKey,
                                  doc['time_key'],
                                  doc['uid'],
                                  widget.user,
                                  doc,
                                  context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      top: 8.0,
                      bottom: 4.0,
                    ),
                    child: Text(
                      '${doc['comment']}',
                      style: Theme.of(context).textTheme.body2,
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }
}
