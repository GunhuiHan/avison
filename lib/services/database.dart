import 'dart:io';

import 'package:avisonhouse/controller/main_controller.dart';
import 'package:avisonhouse/models/info.dart';
import 'package:avisonhouse/models/program.dart';
import 'package:avisonhouse/models/user.dart';
import 'package:avisonhouse/utils/Utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DatabaseService {
  final int id;
  final String articleKey;
  final String commentKey;
  final int boardNum;
  final UserData user;
  final String likesKey;
  final int infoNum;
  final String raName;

  DatabaseService({this.id, this.articleKey, this.commentKey, this.boardNum, this.user, this.likesKey, this.infoNum, this.raName});

  //get member number
  Stream<DocumentSnapshot> get getMember {
    return Firestore.instance.collection('house').document('member').snapshots();
  }

  //collection reference
  final CollectionReference programCollection = Firestore.instance.collection('program');

  MainController _controller = Get.find();

  Future<bool> get getPrograms async {
    QuerySnapshot snapshot = await programCollection.getDocuments();
    List<Program> programs = snapshot.documents.map<Program>((doc) {
      Map data = doc.data;
      data["id"] = doc.documentID;
      data["isCommon"] = data["isCommon"]??false;
      data["always"] = data["always"] ?? false;
      if (data["date"] != null && data["date"].length > 0)
        data["date"] = data["date"].map((e) => DateTime.parse(e.toDate().toString())).toList();
      data["finish"] = data["finish"] ?? false;
      return Program.fromJson(data);
    }).toList();
    programs.sort((a, b) {
      if (b.always) {
        return 1;
      }
      return -1;
    });
    programs.sort((a, b) {
      if(a.date != null && a.date.length > 0 && b.date != null && b.date.length > 0)
        return a.date[0].compareTo(b.date[0]);
      else return -1;
    });
    _controller.getProgramList(programs);
    return true;
  }

  Program _programFromSnapshot(DocumentSnapshot snapshot) {
    return Program.fromJson(snapshot.data);
  }

  Future<bool> addProgram(Program program) async {
    if (program.image != null) program.image = await uploadImageFile(program.image, program.title);
    bool success = false;
    await programCollection
        .document()
        .setData(program.toJson())
        .whenComplete(() => success = true)
        .catchError((error) => success = false); // doc 생성 && field 값 삭제
    print('success : $success');
    return success;
  }

  Future<bool> editProgram(Program program) async {
    if (program.image != null && !program.image.startsWith("https")) program.image = await uploadImageFile(program.image, program.title);
    bool success = false;
    await programCollection
        .document(program.id)
        .setData(program.toJson())
        .whenComplete(() => success = true)
        .catchError((error) => success = false); // doc 생성 && field 값 삭제
    print('edit success : $success');
    return success;
  }

  Future<bool> deleteProgram(String programId) async {
    await programCollection.document(programId).delete();
    return true;
  }

  Future<String> uploadImageFile(String filePath, String title) async {
    StorageReference storageReference = FirebaseStorage.instance.ref().child('programs/$title${Utility.getRandomString(4)}');
    StorageUploadTask uploadTask = storageReference.putFile(File(filePath));
    await uploadTask.onComplete;
    print('File Uploaded');
    String returnURL;
    await storageReference.getDownloadURL().then((fileURL) {
      returnURL = fileURL;
    });
    print(returnURL);
    return returnURL;
  }

//  Stream<Program> get program {
//    return programCollection
//        .document('program$id')
//        .snapshots()
//        .map(_programFromSnapshot);
//  }

  //get rm data
  Stream<QuerySnapshot> get getRm {
    return Firestore.instance.collection('rm').snapshots();
  }

  //get ra data
  Stream<QuerySnapshot> get getRa {
    return Firestore.instance.collection('ra').snapshots();
  }

  //get info
  Future<QuerySnapshot> get infoLength {
    return Firestore.instance.collection('info').getDocuments();
  }

  Stream<Info> get infoList {
    return Firestore.instance.collection('info').document('info$infoNum').snapshots().map(_infoFromSnapshot);
  }

  Info _infoFromSnapshot(DocumentSnapshot snapshot) {
    return Info(name: snapshot.data['name'], contact: snapshot.data['contact'], title: snapshot.data['title']);
  }
}
