import 'package:flutter/material.dart';

Widget houseMember() {
  return RichText(
      text:
          TextSpan(style: TextStyle(color: Colors.black), children: <TextSpan>[
    TextSpan(
        text: 'A', style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold)),
    TextSpan(
        text: 'VISON HOUSE',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
    TextSpan(
        text: '는\n\n',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    TextSpan(
        text: '1', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    TextSpan(
        text: '명의 ',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    TextSpan(
        text: 'RM ',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    TextSpan(
        text: '교수님과 ',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    TextSpan(
        text: '14',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    TextSpan(
        text: '명의 ',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    TextSpan(
        text: 'RA,\n\n',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    TextSpan(
        text: '그리고 ',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    TextSpan(
        text: '365',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    TextSpan(
        text: '명의 ',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    TextSpan(
        text: '여러분',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    TextSpan(
        text: '으로 구성되었습니다.',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  ]));
}
