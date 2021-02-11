import 'package:avisonhouse/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RaCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Flexible(
              child: ListView(
                padding: EdgeInsets.all(0),
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24, top: 24),
                      child: Text(
                        "RM",
                        style: Theme.of(context).textTheme.display1,
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: DatabaseService().getRm,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: Text('Loading...'),
                          );
                        } else {
                          return ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.all(0),
                            shrinkWrap: true,
                            children: getRaCard(snapshot),
                          );
                        }
                      }),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24, top: 8),
                      child: Text(
                        "RA",
                        style: Theme.of(context).textTheme.display1,
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: DatabaseService().getRa,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: Text('Loading...'),
                          );
                        } else {
                          return ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.all(0),
                            shrinkWrap: true,
                            children: getRaCard(snapshot),
                          );
                        }
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getRaCard(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map(
          (doc) => Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, top: 4.0, right: 4.0, bottom: 4.0),
                child: CircleAvatar(
                  minRadius: 20,
                  maxRadius: 28,
                  backgroundColor: Colors.grey[300],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Text(
                            doc['name'],
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Text(
                          doc['major'],
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, top: 4.0, bottom: 4.0),
                      child: Text(
                        '"${doc['intro']}"',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        doc['contact'],
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Divider(
              color: Colors.grey,
            ),
          )
        ],
      ),
    )
        .toList();
  }
}