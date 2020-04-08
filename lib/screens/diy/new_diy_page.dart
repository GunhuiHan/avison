import 'package:avisonhouse/models/user.dart';
import 'package:avisonhouse/screens/diy/new_diy_article.dart';
import 'package:avisonhouse/screens/diy/new_diy_writing_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewDiyPage extends StatefulWidget {
  final UserData userData;
  NewDiyPage(this.userData);

  @override
  _NewDiyPageState createState() => _NewDiyPageState();
}

class _NewDiyPageState extends State<NewDiyPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('LIY/DIY 게시판'),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('diy').snapshots(),
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
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(
            Icons.add,
          ),
          label: Text('Write'),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewDiyWritingPage(widget.userData)),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                          builder: (context) =>
                              DiyArticle(doc, widget.userData)),
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, top: 12.0),
                child: PhysicalModel(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  clipBehavior: Clip.antiAlias,
                  color: Colors.white,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24.0, top: 8.0, bottom: 8.0, right: 32.0),
                          child: Text(
                            '${doc['title']}',
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 26.0, bottom: 12.0),
                              child: Text(
                                timeDifference(doc['date_time']),
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 13),
                              ),
                            ),
                            Spacer(),
                            StreamBuilder(
                                stream: Firestore.instance
                                    .collection('diy')
                                    .document(doc['time_key'])
                                    .collection('comment')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 24),
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 4.0),
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
                                    int comments =
                                        snapshot.data.documents.length;
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 24),
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 4.0),
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
                      ],
                    ),
                  ),
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
