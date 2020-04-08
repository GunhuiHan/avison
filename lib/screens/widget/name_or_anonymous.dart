import 'package:flutter/material.dart';

Widget nameOrAnonymous(bool value, String name) {
  switch (value) {
    case true:
      {
        return Text(
          '익명',
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        );
      }
      break;
    default:
      {
        return Text(
          name,
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        );
      }
      break;
  }
}

Widget nameOrAnonymousArticle(bool value, String name, String room) {
  switch (value) {
    case true:
      {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text('익명',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text('익명',
                  style: TextStyle(
                    fontSize: 14,
                  )),
            ),
          ],
        );
      }
      break;
    default:
      {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(room,
                  style: TextStyle(
                    fontSize: 14,
                  )),
            ),
          ],
        );
      }
      break;
  }
}

Widget nameOrAnonymousComment(bool value, String name) {
  switch (value) {
    case true:
      {
        return Text(
          '익명',
          style: TextStyle(fontSize: 16),
        );
      }
      break;
    default:
      {
        return Text(
          name,
          style: TextStyle(fontSize: 16),
        );
      }
      break;
  }
}
