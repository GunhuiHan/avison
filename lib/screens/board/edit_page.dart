import 'package:avisonhouse/models/user.dart';
import 'package:avisonhouse/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EditPage extends StatefulWidget {
  final UserData user;
  final int boardNum;
  final DocumentSnapshot doc;
  EditPage(this.user, this.boardNum, this.doc);
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final GlobalKey<FormState> _textFormKey = GlobalKey<FormState>();
  TextEditingController _titleController;
  TextEditingController _bodyController;
  bool anonymous;

  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _bodyController = TextEditingController();
    _titleController.text = widget.doc['title'];
    _bodyController.text = widget.doc['body'];
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
                          .document(widget.doc['time_key'])
                          .updateData({
                        "title": _titleController.text,
                        "body": _bodyController.text,
                        "anonymous": anonymous
                      });
                      Firestore.instance
                          .collection('users')
                          .document(widget.user.uid)
                          .collection('my_article')
                          .document(widget.doc['time_key'])
                          .updateData({
                        "title": _titleController.text,
                        "body": _bodyController.text,
                        "anonymous": anonymous
                      });

                      Navigator.pop(context);

                      _titleController.clear();
                      _bodyController.clear();
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
              Container(
                padding: EdgeInsets.all(24.0),
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                      labelText: 'Title', labelStyle: TextStyle(fontSize: 24)),
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(),
              ),
              Expanded(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: _bodyController,
                      decoration: new InputDecoration.collapsed(
                          hintText:
                              '여기를 눌러 글을 작성할 수 있습니다.\n\nTap here to write'),
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
