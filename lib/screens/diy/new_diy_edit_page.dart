import 'package:avisonhouse/models/user.dart';
import 'package:avisonhouse/screens/widget/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DiyEditPage extends StatefulWidget {
  final UserData user;
  final DocumentSnapshot doc;
  DiyEditPage(this.user, this.doc);
  @override
  _DiyEditPageState createState() => _DiyEditPageState();
}

class _DiyEditPageState extends State<DiyEditPage> {
  final GlobalKey<FormState> _textFormKey = GlobalKey<FormState>();
  TextEditingController _titleController;
  TextEditingController _bodyController;
  String dropdownValue;

  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _bodyController = TextEditingController();
    _titleController.text = widget.doc['title'];
    _bodyController.text = widget.doc['body'];
    dropdownValue = widget.doc['ra'];
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
                      if (dropdownValue != '분반') {
                        Firestore.instance
                            .collection("diy")
                            .document(widget.doc['time_key'])
                            .updateData({
                          "title": _titleController.text,
                          "body": _bodyController.text,
                        });

                        Navigator.pop(context);

                        _titleController.clear();
                        _bodyController.clear();
                      } else {
                        selectAlert(context);
                      }
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
              Padding(
                padding: const EdgeInsets.only(
                  left: 24.0,
                  top: 8.0,
                ),
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Theme.of(context).primaryColor,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: <String>[
                    '분반',
                    '고재원',
                    '김동민',
                    '김민지',
                    '김재현',
                    '김현탁',
                    '나지선',
                    '남준근',
                    '배효영',
                    '안혜리',
                    '정인기',
                    '정준석',
                    '차준혁',
                    '한군희',
                    '황서원'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
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
                              '프로그램에 대한 설명, 모집 인원 등을 작성해주세요.\n\nPlease contain a description of your program and recruitment number, etc.'),
                    ),
                  ),
                ),
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
