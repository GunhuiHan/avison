
import 'package:flutter/material.dart';

class QuestionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 120.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'hkh@yonsei.ac.kr',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '이용시 불편한 사항 문의주세요.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Text(
                      'Please contact for any inconvenience.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}