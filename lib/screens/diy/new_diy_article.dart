import 'package:avisonhouse/models/user.dart';
import 'package:avisonhouse/screens/widget/alert.dart';
import 'package:avisonhouse/screens/widget/article_widget.dart';
import 'package:avisonhouse/services/database.dart';
import 'package:avisonhouse/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DiyArticle extends StatefulWidget {
  final DocumentSnapshot doc;
  final UserData user;
  DiyArticle(this.doc, this.user);
  @override
  _DiyArticleState createState() => _DiyArticleState();
}

class _DiyArticleState extends State<DiyArticle> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _commentController;
  FocusNode _focusNode = new FocusNode();
  bool anonymous = false;

  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            'LIY / DIY',
            style: Theme.of(context)
                .textTheme
                .display2
                .copyWith(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Stack(children: <Widget>[
          GestureDetector(
            onTap: () {
              _focusNode.unfocus(); //3 - call this method here
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 24.0, top: 32, right: 24),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(
                                  widget.doc['name'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .body2
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(
                                  widget.doc['room'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .body2
                                      .copyWith(
                                          fontSize: 14,
                                          color: Colors.grey[600]),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              diyUpdateOrDelete(
                                  widget.user, widget.doc, context),
                              Text(
                                timeDifference(widget.doc['date_time']),
                                style: Theme.of(context)
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
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24.0, top: 16.0, right: 24.0),
                        child: Text(widget.doc['title'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, top: 8.0),
                        child: Text(
                          widget.doc['body'],
                          style: Theme.of(context).textTheme.body2,
                        ),
                      ),
                      Flexible(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: Firestore.instance
                                .collection('diy')
                                .document(widget.doc['time_key'])
                                .collection('comment')
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: Text('Loading...'),
                                );
                              } else {
                                return ListView(
                                  shrinkWrap: true,
                                  children: getComment(
                                      snapshot, widget.doc['time_key']),
                                );
                              }
                            }),
                      ),
                    ],
                  ),
                ),
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
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: TextField(
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
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                        onTap: () {
                          String time = generateDbTimeKey();
                          String date = generateDate();
                          DateTime dateTime = generateDateTime();

                          Firestore.instance
                              .collection('diy')
                              .document(widget.doc['time_key'])
                              .collection('comment')
                              .document(time)
                              .setData({
                            "uid": widget.user.uid,
                            "name": widget.user.userName,
                            "comment": _commentController.text,
                            "room": widget.user.userRoom,
                            "date": date,
                            "date_time": dateTime,
                            "time_key": time,
                          });
                          _commentController.clear();
                        },
                        child: Text(
                          'Post',
                          style: Theme.of(context).textTheme.body1.copyWith(
                              fontSize: 20,
                              color: Theme.of(context).primaryColor),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ]),
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

    return dbTimeKey.toString();
  }

  String generateDate() {
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('MMM d, yyyy');
    var formatTime = DateFormat('EEEE, hh:mm aaaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    return date + time;
  }

  DateTime generateDateTime() {
    var time = DateTime.now();

    return time;
  }

  getComment(AsyncSnapshot<QuerySnapshot> snapshot, String articleKey) {
    return snapshot.data.documents
        .map((doc) => Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Divider(
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 12),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.blueGrey[200],
                          child: Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              '${doc['name']}',
                              style: Theme.of(context).textTheme.body2.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          flex: 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                timeDifference(doc['date_time']),
                                style: Theme.of(context)
                                    .textTheme
                                    .body2
                                    .copyWith(fontSize: 12),
                              ),
                              diyUpdateOrDeleteComment(
                                  widget.user, doc, articleKey, context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, bottom: 2.0),
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
