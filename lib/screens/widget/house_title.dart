import 'package:flutter/material.dart';

class HouseTitle extends StatelessWidget {
  final _scaffoldKey;
  HouseTitle(this._scaffoldKey);
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(left: 132.0, top: 10, right: 132.0),
              child: Divider(
                color: Colors.white,
                thickness: 2,
              ),
            ),
            Column(
              children: <Widget>[
                Text(
                  'AVISON',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      letterSpacing: 1.0,
                      height: 1.0,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'sandoll'),
                ),
                Text(
                  'HOUSE',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      letterSpacing: 1.0,
                      height: 1.0,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'sandoll'),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 132.0, right: 132.0),
              child: Divider(
                color: Colors.white,
                thickness: 2,
              ),
            ),
            Container(height: 10),
          ],
        ),
      ),
      Positioned(
        right: 1,
        bottom: -1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
            width: MediaQuery.of(context).size.width / 5,
            height: MediaQuery.of(context).size.width / 5 / 1.7876,
            child: Image.asset(
              'assets/house/avisoneagle.png',
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
      Positioned(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 20.0),
          child: GestureDetector(
            onTap: () {
              _scaffoldKey.currentState.openDrawer();
            },
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColorLight),
              child: Icon(
                Icons.menu,
                color: Theme.of(context).primaryColorDark,
                size: 24,
              ),
            ),
          ),
        ),
      )
    ]);
  }
}
