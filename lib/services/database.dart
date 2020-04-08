import 'package:avisonhouse/models/info.dart';
import 'package:avisonhouse/models/program.dart';
import 'package:avisonhouse/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final int id;
  final String articleKey;
  final String commentKey;
  final int boardNum;
  final UserData user;
  final String likesKey;
  final int infoNum;
  final String raName;

  DatabaseService(
      {this.id,
      this.articleKey,
      this.commentKey,
      this.boardNum,
      this.user,
      this.likesKey,
      this.infoNum,
      this.raName});

  //get member number
  Stream<DocumentSnapshot> get getMember {
    return Firestore.instance
        .collection('house')
        .document('member')
        .snapshots();
  }

  //collection reference
  final CollectionReference programCollection =
      Firestore.instance.collection('program');
  final CollectionReference commonProgramCollection =
      Firestore.instance.collection('commonprogram');

  Stream<QuerySnapshot> get programLength {
    return programCollection.snapshots();
  }

  Stream<QuerySnapshot> get commonProgram {
    return commonProgramCollection.snapshots();
  }

  Stream<Program> get program {
    return programCollection
        .document('program$id')
        .snapshots()
        .map(_programFromSnapshot);
  }

  Program _programFromSnapshot(DocumentSnapshot snapshot) {
    List<dynamic> timeStampDate = snapshot.data['date'];
    int length = timeStampDate.length;
    List<dynamic> dateList = [];
    List<dynamic> formattedDateList = [];
    for (int i = 0; i < length; i++) {
      dynamic date = timeStampDate[i].toDate();
      dateList.add(date);
    }
    for (int i = 0; i < length; i++) {
      dynamic _date = DateFormat('M/d').format(dateList[i]);
      formattedDateList.add(_date);
    }

    return Program(
        id: id,
        title: snapshot.data['title'],
        ra: snapshot.data['ra'],
        date: dateList,
        formattedDate: formattedDateList,
        time: snapshot.data['time'],
        location: snapshot.data['location'],
        points: snapshot.data['points'],
        personnel: snapshot.data['personnel'],
        googleForm: snapshot.data['googleform'],
        intro: snapshot.data['intro'],
        image: snapshot.data['image']);
  }

  Future<String> get programImageUrl async {
    var ref = FirebaseStorage.instance.ref().child('program/program$id.png');
    String programUrl = await ref.getDownloadURL();
    return programUrl;
  }

  //get rm data
  Stream<QuerySnapshot> get getRm {
    return Firestore.instance.collection('rm').snapshots();
  }

  //get ra data
  Stream<QuerySnapshot> get getRa {
    return Firestore.instance.collection('ra').snapshots();
  }

  //get article
  Stream<DocumentSnapshot> get getArticle {
    return Firestore.instance
        .collection(boardTitle())
        .document(articleKey)
        .snapshots();
  }

  //get DIY article
  Stream<DocumentSnapshot> get getDiyArticle {
    return Firestore.instance
        .collection('diy')
        .document(raName)
        .collection('diy')
        .document(articleKey)
        .snapshots();
  }

  //get my article
  Stream<QuerySnapshot> getMyArticle() {
    return Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('my_article')
        .snapshots();
  }

  //get my comment
  Stream<QuerySnapshot> getMyComment() {
    return Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('my_comment')
        .snapshots();
  }

  //delete article
  void deleteArticle() {
    Firestore.instance.collection(boardTitle()).document(articleKey).delete();
    Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('my_article')
        .document(articleKey)
        .delete();
  }

  //likes
  setLikes() {
    Firestore.instance
        .collection(boardTitle())
        .document(articleKey)
        .collection('likes')
        .document(likesKey)
        .setData({
      "uid": user.uid,
      "name": user.userName,
      "room": user.userRoom,
      "time_key": likesKey,
    });
  }

  Stream<QuerySnapshot> get likesNum {
    return Firestore.instance
        .collection(boardTitle())
        .document(articleKey)
        .collection('likes')
        .snapshots();
  }

  Future<QuerySnapshot> checkLikes() {
    return Firestore.instance
        .collection(boardTitle())
        .document(articleKey)
        .collection('likes')
        .where("uid", isEqualTo: user.uid)
        .getDocuments();
  }

  Stream<QuerySnapshot> get commentsNum {
    return Firestore.instance
        .collection(boardTitle())
        .document(articleKey)
        .collection('comment')
        .snapshots();
  }

  Stream<QuerySnapshot> get diyCommentsNum {
    return Firestore.instance
        .collection('diy')
        .document(raName)
        .collection('diy')
        .document(articleKey)
        .collection('comment')
        .snapshots();
  }

  //get diy
  Stream<QuerySnapshot> get getDiy {
    return Firestore.instance
        .collection('diy')
        .document(raName)
        .collection('diy')
        .snapshots();
  }

  Stream<QuerySnapshot> get getDiyComment {
    return Firestore.instance
        .collection('diy')
        .document(raName)
        .collection('diy')
        .document(articleKey)
        .collection('comment')
        .snapshots();
  }

  //get board
  Stream<QuerySnapshot> get getBoard {
    return Firestore.instance.collection(boardTitle()).snapshots();
  }

  //get board
  Stream<QuerySnapshot> get getDiyBoard {
    return Firestore.instance
        .collection('diy')
        .document(raName)
        .collection('diy')
        .snapshots();
  }

  Stream<QuerySnapshot> get getComment {
    return Firestore.instance
        .collection(boardTitle())
        .document(articleKey)
        .collection('comment')
        .snapshots();
  }

  //get info
  Future<QuerySnapshot> get infoLength {
    return Firestore.instance.collection('info').getDocuments();
  }

  Stream<Info> get infoList {
    return Firestore.instance
        .collection('info')
        .document('info$infoNum')
        .snapshots()
        .map(_infoFromSnapshot);
  }

  Info _infoFromSnapshot(DocumentSnapshot snapshot) {
    return Info(
        name: snapshot.data['name'],
        contact: snapshot.data['contact'],
        title: snapshot.data['title']);
  }

  boardTitle() {
    switch (boardNum) {
      case 0:
        {
          return 'free_board';
        }
      case 1:
        {
          return 'convey_board';
        }
      case 2:
        {
          return 'food_board';
        }
      case 3:
        {
          return 'store_board';
        }
      case 4:
        {
          return 'tip_board';
        }
      case 5:
        {
          return 'recommend_board';
        }
      case 6:
        {
          return 'ra_board';
        }
      case 7:
        {
          return 'suggestion_board';
        }
      case 8:
        {
          return 'lost_board';
        }
    }
  }

  boardName() {
    switch (boardNum) {
      case 0:
        {
          return '자유 게시판';
        }
      case 1:
        {
          return '대신전해드려요';
        }
      case 2:
        {
          return '나눔게시판';
        }
      case 3:
        {
          return '송도 맛집 공유';
        }
      case 4:
        {
          return '송도 꿀팁 공유';
        }
      case 5:
        {
          return '이런 분반모임 추천해요';
        }
      case 6:
        {
          return 'RA를 칭찬해';
        }
      case 7:
        {
          return '#건의사항';
        }
      case 8:
        {
          return '분실물 찾습니다';
        }
    }
  }
}
