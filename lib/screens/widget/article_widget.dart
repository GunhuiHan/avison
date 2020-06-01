import 'package:avisonhouse/models/user.dart';
import 'package:avisonhouse/screens/board/comment_edit_page.dart';
import 'package:avisonhouse/screens/board/edit_page.dart';
import 'package:avisonhouse/screens/diy/new_diy_comment_edit_page.dart';
import 'package:avisonhouse/screens/diy/new_diy_edit_page.dart';
import 'package:avisonhouse/screens/widget/alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget updateOrDelete(int boardNum, String articleKey, String uid,
    UserData userData, DocumentSnapshot doc, BuildContext context) {
  if (uid == userData.uid) {
    return PopupMenuButton<int>(
      onSelected: (value) {
        if (value == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context3) => EditPage(userData, boardNum, doc)),
          );
        }
        if (value == 2) {
          deleteAlert(context, boardNum, articleKey, userData);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text("Edit"),
        ),
        PopupMenuItem(
          value: 2,
          child: Text("Delete"),
        ),
      ],
    );
  } else {
    return Text('');
  }
}

Widget diyUpdateOrDelete(
    UserData userData, DocumentSnapshot doc, BuildContext context) {
  if (doc['uid'] == userData.uid) {
    return PopupMenuButton<int>(
      onSelected: (value) {
        if (value == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context3) => DiyEditPage(userData, doc)),
          );
        }
        if (value == 2) {
          diyDeleteAlert(userData, doc['time_key'], context);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text("Edit"),
        ),
        PopupMenuItem(
          value: 2,
          child: Text("Delete"),
        ),
      ],
    );
  } else {
    return Text('');
  }
}

Widget updateOrDeleteComment(int boardNum, String articleKey, String commentKey,
    String uid, UserData userData, DocumentSnapshot doc, BuildContext context) {
  if (uid == userData.uid) {
    return PopupMenuButton<int>(
      onSelected: (value) {
        if (value == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context3) =>
                    CommentEditPage(userData, boardNum, articleKey, doc)),
          );
        }
        if (value == 2) {
          deleteCommentAlert(
              context, boardNum, articleKey, commentKey, userData);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text("Edit"),
        ),
        PopupMenuItem(
          value: 2,
          child: Text("Delete"),
        ),
      ],
    );
  } else {
    return Text('');
  }
}

Widget diyUpdateOrDeleteComment(UserData userData, DocumentSnapshot doc,
    String articleKey, BuildContext context) {
  if (doc['uid'] == userData.uid) {
    return PopupMenuButton<int>(
      onSelected: (value) {
        if (value == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context3) =>
                    DiyCommentEditPage(userData, doc, articleKey)),
          );
        }
        if (value == 2) {
          deleteDiyCommentAlert(userData, articleKey, doc['time_key'], context);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text("Edit"),
        ),
        PopupMenuItem(
          value: 2,
          child: Text("Delete"),
        ),
      ],
    );
  } else {
    return Text('');
  }
}
