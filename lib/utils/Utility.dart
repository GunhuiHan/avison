import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

class Utility {
  static getArrayElement(array, index) {
    if (array == null || array.length <= index) {
      return null;
    }
    return array[index];
  }

  static replaceElement(array, index, object) {
    if (array == null || array.length <= index) {
      return null;
    }
    array.removeAt(index);
    array.insert(index, object);
  }

  static getSafetyValue(object, {key, defaultValue = ''}) {
    Optional<dynamic> nullSafeValue = Optional.ofNullable(object);
    var keys = key is int ? [key] : key;
    for (var key in keys)
      nullSafeValue = nullSafeValue
          .map((o) => key is int ? getArrayElement(o, key) : o[key]);
    return nullSafeValue.orElse(defaultValue);
  }

  static getRandomString(len) {
    var charSet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var randomString = '';
    for (var i = 0; i < len; i++) {
      var randomPoz = (Random.secure().nextDouble() * charSet.length).floor();
      randomString += charSet.substring(randomPoz, randomPoz + 1);
    }
    return randomString;
  }

//
//  static getRandomInteger(max) {
//    var rng = new Random();
//    return rng.nextInt(max);
//  }
//

//
//  static String dateToDayFomat(String time) {
////    print('time : ' + time);
//    DateTime dateTime = DateTime.parse(time).toLocal();
//    return (dateTime.year).toString() +
//        '.' +
//        (dateTime.month).toString() +
//        '.' +
//        (dateTime.day).toString();
//  }
//
//  static String getRandomParam() {
////    time = Math.floor(parseInt(time) / 60 ) * 60*60;
//    var time = ((int.parse(Jiffy().format('yyyyMMddHHmm')) / 60).floor() * 60);
////    print('time : ' + time.toString());
//    return 'time=' + time.toString();
//  }
//
  static Future<bool> onWillPop(context) {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('알림'),
            content: Text('앱을 종료하시겠습니까?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('아니오'),
              ),
              FlatButton(
                onPressed: () => exit(0),
                /*Navigator.of(context).pop(true)*/
                child: Text('예'),
              ),
            ],
          ),
        ) ??
        false;
  } //start page에서 뒤로가기 눌렀을 때 뜨는 알림
}
