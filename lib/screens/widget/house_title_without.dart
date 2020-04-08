import 'package:flutter/material.dart';

class HouseTitleWithout extends StatelessWidget {
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
                  const EdgeInsets.only(left: 132.0, top: 10.0, right: 132.0),
              child: Divider(
                color: Colors.white,
                thickness: 2,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
    ]);
  }
}
