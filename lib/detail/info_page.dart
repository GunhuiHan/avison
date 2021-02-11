import 'package:avisonhouse/models/info.dart';
import 'package:avisonhouse/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Align(
                alignment: Alignment.center,
                child:
                Text("INFO", style: Theme.of(context).textTheme.display1),
              ),
            ),
            FutureBuilder(
                future: DatabaseService().infoLength,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: Text('Loading'),
                    );
                  else {
                    List<DocumentSnapshot> menuDocuments =
                        snapshot.data.documents;
                    int menuLength = menuDocuments.length;
                    return Flexible(
                      child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          itemCount: menuLength,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            return menuList(i);
                          }),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }

  Widget menuList(int infoNum) {
    Info info;
    return StreamBuilder(
        stream: DatabaseService(infoNum: infoNum).infoList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('loading'));
          } else {
            info = snapshot.data;
            return Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    left: 36,
                    top: 24,
                    right: 36,
                  ),
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              info.title,
                              style: Theme.of(context).textTheme.display2,
                            )),
                      ],
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 2.0, color: Colors.grey),
                          bottom: BorderSide(width: 2.0, color: Colors.grey),
                        )),
                  ),
                ),
                ListView.builder(
                    padding: EdgeInsets.all(0),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: info.name.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 36),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              children: <Widget>[
                                Text('${info.name[i]}',
                                    style: TextStyle(fontSize: 18)),
                                Spacer(),
                                Text(
                                  '${info.contact[i]}',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            );
          }
        });
  }
}