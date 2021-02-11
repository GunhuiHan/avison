import 'package:json_annotation/json_annotation.dart';

part 'program.g.dart';

@JsonSerializable(nullable: true)
class Program {
  String id;
  String title;
  String image;
  String ra;
  List<dynamic> date;
  String time;
  String location;
  String num;
  String googleForm;
  String intro;
  bool finish;
  bool always;
  bool isCommon;

  Program({this.title, this.image, this.ra, this.date, this.time, this.location, this.num, this.googleForm, this.intro, this.finish, this.always, this.isCommon});

  Program get initProgram => Program(title: null, image: null, ra: null, date: null, time: null, location: '줌', num: null, googleForm: "", intro: null, finish : false, always : false, isCommon : false);

  factory Program.fromJson(Map<String, dynamic> json) => _$ProgramFromJson(json);

  Map<String, dynamic> toJson() => _$ProgramToJson(this);

  @override
  bool operator ==(Object other) => other is Program && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return toJson().toString();
  }
}

//convert list of timestamp form firebase to list of formatted date type
//List<dynamic> programDate = snapshot.data;
//int length = programDate.length;
//for (int i = 0; i < length; i++) {
//programDate[i] = DateFormat('M-dd').format(programDate[i].toDate());
//}
