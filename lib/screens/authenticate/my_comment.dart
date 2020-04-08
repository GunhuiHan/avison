import 'package:avisonhouse/screens/board/article.dart';
import 'package:avisonhouse/screens/widget/name_or_anonymous.dart';
import 'package:avisonhouse/services/database.dart';
import 'package:avisonhouse/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:avisonhouse/models/user.dart';

class MyCommentPage extends StatefulWidget {
  final UserData userData;
  MyCommentPage(this.userData);
  @override
  _MyCommentPageState createState() => _MyCommentPageState();
}

class _MyCommentPageState extends State<MyCommentPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'My comments',
            style: Theme.of(context)
                .textTheme
                .display2
                .copyWith(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                  stream: DatabaseService(user: widget.userData).getMyComment(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return loading();
                    } else {
                      return ListView(
                        reverse: true,
                        shrinkWrap: true,
                        children: getMyComment(snapshot),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  getMyComment(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) => Stack(children: <Widget>[
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Article(doc['board_num'],
                              doc['time_key_article'], widget.userData)),
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
                        '${doc['comment']}',
                        style: Theme.of(context).textTheme.body1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0),
                          child: nameOrAnonymous(doc['anonymous'], doc['name']),
                        ),
                        VerticalDivider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        Text(
                          timeDifference(doc['date_time']),
                          style: TextStyle(color: Colors.grey[600]),
                        ),
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
