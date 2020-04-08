import 'package:avisonhouse/screens/board/article.dart';
import 'package:avisonhouse/screens/board/writing_page.dart';
import 'package:avisonhouse/screens/widget/alert.dart';
import 'package:avisonhouse/screens/widget/name_or_anonymous.dart';
import 'package:avisonhouse/services/database.dart';
import 'package:avisonhouse/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:avisonhouse/models/user.dart';

class BoardDetailPage extends StatefulWidget {
  final UserData userData;
  final int boardNum;
  BoardDetailPage(this.userData, this.boardNum);
  @override
  _BoardDetailPageState createState() => _BoardDetailPageState();
}

class _BoardDetailPageState extends State<BoardDetailPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            DatabaseService(boardNum: widget.boardNum).boardName(),
            style: Theme.of(context)
                .textTheme
                .display2
                .copyWith(color: Colors.white),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(
            Icons.add,
          ),
          label: Text('Write'),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            if ((widget.userData == null)) {
              return writingAlert(context);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        WritingPage(widget.userData, widget.boardNum)),
              );
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                  stream: DatabaseService(boardNum: widget.boardNum).getBoard,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text('Loading...'),
                      );
                    } else {
                      return ListView(
                        shrinkWrap: true,
                        children: getArticle(snapshot),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  getArticle(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents.reversed
        .map((doc) => Stack(children: <Widget>[
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Article(widget.boardNum,
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
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: nameOrAnonymous(doc['anonymous'], doc['name'])),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 26.0),
                          child: Text(
                            timeDifference(doc['date_time']),
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 13),
                          ),
                        ),
                        Spacer(),
                        StreamBuilder(
                            stream: DatabaseService(
                              boardNum: widget.boardNum,
                              articleKey: doc['time_key'],
                            ).likesNum,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
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
                                      '0',
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
                              boardNum: widget.boardNum,
                              articleKey: doc['time_key'],
                            ).commentsNum,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
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
                                        '0',
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
                                ;
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
