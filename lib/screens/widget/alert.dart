import 'package:avisonhouse/models/user.dart';
import 'package:avisonhouse/services/database.dart';
import 'package:avisonhouse/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void registerAlert(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('creating an account...'),
      );
    },
  );
}

void signingAlert(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Signing...'),
      );
    },
  );
}

void writingAlert(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Loigin is required'),
        content: Text("You can login through menu from the home screen"),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context, "Cancel");
            },
          ),
        ],
      );
    },
  );
}

void validateAlert(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Valition rejected'),
        content: Text("Please enter correct student number"),
        actions: <Widget>[
          FlatButton(
            child: Text('Back'),
            onPressed: () {
              Navigator.pop(context, "Back");
            },
          ),
        ],
      );
    },
  );
}

void emailAlert(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Email alreay in use'),
        content: Text("Please try another email"),
        actions: <Widget>[
          FlatButton(
            child: Text('Back'),
            onPressed: () {
              Navigator.pop(context, "Back");
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

void logInAlert(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('User not found'),
        content: Text("Please try correct email and password"),
        actions: <Widget>[
          FlatButton(
            child: Text('Back'),
            onPressed: () {
              Navigator.pop(context, "Back");
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

void deleteAlert(BuildContext context2, int boardNum, String articleKey,
    UserData userData) async {
  await showDialog(
    context: context2,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context3) {
      return AlertDialog(
        title: Text('Delete this article?'),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context3, "Cancel");
            },
          ),
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context3, 'complete');
              Navigator.pop(context2, 'complete');
              DatabaseService(
                      boardNum: boardNum,
                      articleKey: articleKey,
                      user: userData)
                  .deleteArticle();
            },
          ),
        ],
      );
    },
  );
}

void diyDeleteAlert(
    UserData userData, String articleKey, BuildContext context2) async {
  await showDialog(
    context: context2,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context3) {
      return AlertDialog(
        title: Text('Delete this article?'),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context3, "Cancel");
            },
          ),
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context3, 'complete');
              Navigator.pop(context2, 'complete');
              Firestore.instance
                  .collection('diy')
                  .document(articleKey)
                  .delete();
            },
          ),
        ],
      );
    },
  );
}

void deleteCommentAlert(BuildContext context2, int boardNum, String articleKey,
    String commentKey, UserData userData) async {
  await showDialog(
    context: context2,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context3) {
      return AlertDialog(
        title: Text('Delete this comment?'),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context3, "Cancel");
            },
          ),
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context3, 'complete');
              Firestore.instance
                  .collection('diy')
                  .document(articleKey)
                  .delete();
            },
          ),
        ],
      );
    },
  );
}

void deleteDiyCommentAlert(UserData userData, String articleKey,
    String commentKey, BuildContext context2) async {
  await showDialog(
    context: context2,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context3) {
      return AlertDialog(
        title: Text('Delete this comment?'),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context3, "Cancel");
            },
          ),
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context3, 'complete');
              Firestore.instance
                  .collection('diy')
                  .document(articleKey)
                  .collection('comment')
                  .document(commentKey)
                  .delete();
            },
          ),
        ],
      );
    },
  );
}

void selectAlert(
  BuildContext context2,
) async {
  await showDialog(
    context: context2,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context3) {
      return AlertDialog(
        title: Text('분반을 선택해주세요'),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.pop(context3, "Cancel");
            },
          ),
        ],
      );
    },
  );
}

class LikeAlert {
  static void likeAlert(BuildContext context, int boardNum, String articleKey,
      UserData user, GlobalKey<ScaffoldState> _scaffoldKey) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Like this article?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, "Cancel");
              },
            ),
            StreamBuilder(
                stream: DatabaseService(
                  boardNum: boardNum,
                  articleKey: articleKey,
                  user: user,
                ).likesNum,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return loading();
                  } else {
                    int likes = snapshot.data.documents.length;
                    if (likes == 0) {
                      return FlatButton(
                        child: Text('Yes'),
                        onPressed: () {
                          String _likesKey = generateDbTimeKey();
                          DatabaseService(
                                  boardNum: boardNum,
                                  articleKey: articleKey,
                                  user: user,
                                  likesKey: _likesKey)
                              .setLikes();
                          Navigator.pop(context);
                        },
                      );
                    } else {
                      return FutureBuilder(
                          future: DatabaseService(
                            boardNum: boardNum,
                            articleKey: articleKey,
                            user: user,
                          ).checkLikes(),
                          builder: (context, AsyncSnapshot snapshot2) {
                            if (!snapshot2.hasData || snapshot2.hasError) {
                              return FlatButton(
                                child: Text('Yes'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              );
                            } else {
                              if (snapshot2.data.documents.length == 0) {
                                return FlatButton(
                                    child: Text('Yes'),
                                    onPressed: () {
                                      String _likesKey = generateDbTimeKey();
                                      DatabaseService(
                                              boardNum: boardNum,
                                              articleKey: articleKey,
                                              user: user,
                                              likesKey: _likesKey)
                                          .setLikes();
                                      _scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                        'Liked successful',
                                        style: TextStyle(fontSize: 16),
                                      )));
                                    });
                              } else {
                                return FlatButton(
                                  child: Text('Yes'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                            content: Text(
                                      'You already liked it',
                                      style: TextStyle(fontSize: 16),
                                    )));
                                  },
                                );
                              }
                            }
                          });
                    }
                  }
                }),
          ],
        );
      },
    );
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
