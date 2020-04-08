import 'package:avisonhouse/screens/board/article.dart';
import 'package:avisonhouse/screens/widget/name_or_anonymous.dart';
import 'package:avisonhouse/services/database.dart';
import 'package:avisonhouse/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:avisonhouse/models/user.dart';

class MyArticlePage extends StatefulWidget {
  final UserData userData;
  MyArticlePage(this.userData);
  @override
  _MyArticlePageState createState() => _MyArticlePageState();
}

class _MyArticlePageState extends State<MyArticlePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('My articles',
              style: Theme.of(context)
                  .textTheme
                  .display2
                  .copyWith(color: Colors.white)),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                  stream: DatabaseService(user: widget.userData).getMyArticle(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return loading();
                    } else {
                      return ListView(
                        reverse: true,
                        shrinkWrap: true,
                        children: getMyArticle(snapshot),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  getMyArticle(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) => Stack(children: <Widget>[
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Article(doc['board_num'],
                              doc['time_key'], widget.userData)),
                    );
                  },
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24.0, top: 4.0, bottom: 4.0, right: 32.0),
                      child: Text(
                        '${doc['title']}',
                        style: Theme.of(context).textTheme.body1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: nameOrAnonymous(doc['anonymous'], doc['name']),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0),
                          child: Text(
                            timeDifference(doc['date_time']),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                        Spacer(),
                        StreamBuilder(
                            stream: DatabaseService(
                              boardNum: doc['board_num'],
                              articleKey: doc['time_key'],
                            ).likesNum,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return loading();
                              } else {
                                int likes = snapshot.data.documents.length;
                                return Row(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 4.0),
                                      child: Icon(
                                        Icons.favorite_border,
                                        size: 12,
                                        color: Colors.red[300],
                                      ),
                                    ),
                                    Text(
                                      '$likes',
                                      style: Theme.of(context)
                                          .textTheme
                                          .body2
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red[300],
                                          ),
                                    ),
                                  ],
                                );
                              }
                            }),
                        StreamBuilder(
                            stream: DatabaseService(
                              boardNum: doc['board_num'],
                              articleKey: doc['time_key'],
                            ).commentsNum,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return loading();
                              } else {
                                int comments = snapshot.data.documents.length;
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 24),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 4.0),
                                        child: Icon(
                                          Icons.chat_bubble_outline,
                                          size: 12,
                                          color: Colors.yellow[700],
                                        ),
                                      ),
                                      Text(
                                        '$comments',
                                        style: Theme.of(context)
                                            .textTheme
                                            .body2
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.yellow[700],
                                            ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ]))
        .toList();
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
}