import 'package:avisonhouse/models/user.dart';
import 'package:avisonhouse/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CommentEditPage extends StatefulWidget {
  final UserData user;
  final int boardNum;
  final String articleKey;
  final DocumentSnapshot doc;
  CommentEditPage(this.user, this.boardNum, this.articleKey, this.doc);
  @override
  _CommentEditPageState createState() => _CommentEditPageState();
}

class _CommentEditPageState extends State<CommentEditPage> {
  final GlobalKey<FormState> _textFormKey = GlobalKey<FormState>();
  TextEditingController _commentController;
  bool anonymous;

  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _commentController.text = widget.doc['comment'];
    anonymous = widget.doc['anonymous'];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: Icon(
              CupertinoIcons.clear,
              size: 44,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  'Editing text',
                  style: Theme.of(context)
                      .textTheme
                      .display2
                      .copyWith(color: Colors.white),
                ),
              ),
              Spacer(),
              ButtonTheme(
                minWidth: 50,
                child: RaisedButton(
                  elevation: 5.0,
                  color: Colors.white,
                  textColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    if (_textFormKey.currentState.validate()) {
                      Firestore.instance
                          .collection(DatabaseService(boardNum: widget.boardNum)
                              .boardTitle())
                          .document(widget.articleKey)
                          .collection('comment')
                          .document(widget.doc['time_key'])
                          .updateData({
                        "comment": _commentController.text,
                        "anonymous": anonymous
                      });
                      Firestore.instance
                          .collection('users')
                          .document(widget.user.uid)
                          .collection('my_comment')
                          .document(widget.doc['time_key'])
                          .updateData({
                        "comment": _commentController.text,
                        "anonymous": anonymous
                      });

                      Navigator.pop(context);

                      _commentController.clear();
                    } else {}
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  child: Text('Done'),
                ),
              ),
            ],
          ),
        ),
        body: Form(
          key: _textFormKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 100),
              Expanded(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: _commentController,
                    ),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Spacer(),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Checkbox(
                        value: anonymous,
                        onChanged: (bool value) {
                          setState(() {
                            anonymous = value;
                          });
                        },
                      )),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, top: 24.0, right: 24.0, bottom: 24.0),
                    child: Text(
                      '익명',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
}
