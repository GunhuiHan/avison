import 'package:avisonhouse/models/user.dart';
import 'package:avisonhouse/screens/widget/alert.dart';
import 'package:avisonhouse/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NewDiyWritingPage extends StatefulWidget {
  final UserData user;
  NewDiyWritingPage(this.user);
  @override
  _NewDiyWritingPageState createState() => _NewDiyWritingPageState();
}

class _NewDiyWritingPageState extends State<NewDiyWritingPage> {
  final GlobalKey<FormState> _textFormKey = GlobalKey<FormState>();
  TextEditingController _titleController;
  TextEditingController _bodyController;
  bool anonymous = false;

  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _bodyController = TextEditingController();
  }

  String titleValidator(String value) {
    if (value.length < 1) {
      return 'title is empty';
    } else {
      return null;
    }
  }

  String bodyValidator(String value) {
    if (value.length < 1) {
      return 'text is empty';
    } else {
      return null;
    }
  }

  String dropdownValue = '분반';

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
                  'Write',
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
                        String time = generateDbTimeKey();
                        String date = generateDate();
                        DateTime dateTime = DateTime.now();
                        Firestore.instance
                            .collection('diy')
                            .document(time)
                            .setData({
                          "uid": widget.user.uid,
                          "name": widget.user.userName,
                          "title": _titleController.text,
                          "body": _bodyController.text,
                          "room": widget.user.userRoom,
                          "date": date,
                          "date_time": dateTime,
                          "time_key": time,
                          "ra": dropdownValue,
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 12.0),
                child: TextFormField(
                  validator: titleValidator,
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
                    child: TextFormField(
                      validator: bodyValidator,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: _bodyController,
                      decoration: InputDecoration(
                          hintText:
                              '\n프로그램에 대한 설명, 모집 인원 등을 작성해주세요.\n\nPlease contain a description of your program\nand recruitment number, etc.'),
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
}
