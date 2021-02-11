// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Program _$ProgramFromJson(Map<String, dynamic> json) {
  return Program(
    title: json['title'] as String,
    image: json['image'] as String,
    ra: json['ra'] as String,
    date: json['date'] as List,
    time: json['time'] as String,
    location: json['location'] as String,
    num: json['num'] as String,
    googleForm: json['googleForm'] as String,
    intro: json['intro'] as String,
    finish: json['finish'] as bool,
    always: json['always'] as bool,
    isCommon: json['isCommon'] as bool,
  )..id = json['id'] as String;
}

Map<String, dynamic> _$ProgramToJson(Program instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'image': instance.image,
      'ra': instance.ra,
      'date': instance.date,
      'time': instance.time,
      'location': instance.location,
      'num': instance.num,
      'googleForm': instance.googleForm,
      'intro': instance.intro,
      'finish': instance.finish,
      'always': instance.always,
      'isCommon': instance.isCommon,
    };
