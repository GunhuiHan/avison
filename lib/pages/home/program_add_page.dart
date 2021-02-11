import 'dart:io';

import 'package:avisonhouse/controller/main_controller.dart';
import 'package:avisonhouse/models/program.dart';
import 'package:avisonhouse/pages/home/home_page.dart';
import 'package:avisonhouse/services/database.dart';
import 'package:avisonhouse/utils/image_picker_controller.dart';
import 'package:avisonhouse/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgramAddPage extends StatelessWidget {
  final bool editMode;

  ProgramAddPage({this.editMode = false});

  final MainController _controller = Get.find();

  Map get program => _controller.newProgram;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(
          () {
            print(program);
            return SingleChildScrollView(
              child: Column(
                children: [
                  Center(child: photoBox()),
                  Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _programItem("제목", "title", program["title"], () {}),
                              Spacer(),
                              Text(
                                '종료 여부',
                                style: TextStyle(fontSize: 14.0),
                              ),
                              Checkbox(
                                value: program["finish"],
                                onChanged: (value) {
                                  _controller.updateNewProgram("finish", value);
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              _programItem("담당RA", "ra", program["ra"], () {}),
                              Spacer(),
                              Text(
                                '전체프로그램',
                                style: TextStyle(fontSize: 14.0),
                              ),
                              Checkbox(
                                value: program["isCommon"],
                                onChanged: (value) {
                                  _controller.updateNewProgram("isCommon", value);
                                },
                              ),
                            ],
                          ),
                          _programItem("장소", "location", program["location"], () {}),
                          SizedBox(
                            height: 20,
                          ),
                          if (program["date"] != null && !program["always"])
                            Wrap(
                                spacing: 8.0,
                                children: program["date"]
                                    .map<Widget>((date) => GestureDetector(
                                        onTap: () => selectDate(context, index: program["date"].indexOf(date)),
                                        child: Text(UiData.dateFormatter(date))))
                                    .toList()),
                          Row(
                            children: [
                              if (!program["always"]) TextButton(onPressed: () => selectDate(context), child: Text("날짜 추가")),
                              if (!program["always"]) TextButton(onPressed: () => deleteDate(), child: Text("날짜 삭제")),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text(
                                '상시 진행',
                                style: TextStyle(fontSize: 14.0),
                              ),
                              Checkbox(
                                value: program["always"],
                                onChanged: (value) {
                                  _controller.updateNewProgram("always", value);
                                },
                              ),
                            ],
                          ),
                          _programItem("시작시간", "time", program["time"], () {}),
                          _programItem("인원수", "num", program["num"], () {}),
                          _programItem("구글폼링크", "googleForm", program["googleForm"], () {}),
                          _programItem("소개", "intro", program["intro"], () {}),
                        ],
                      )).paddingSymmetric(horizontal: Get.width * 0.05),
                  SizedBox(
                    height: 80,
                  )
                ],
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Get.theme.primaryColorLight,
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                if ((program["date"] == null || program["date"].length == 0) && !program["always"])
                  Get.defaultDialog(title: "알림", middleText: "날짜를 하나 이상 선택하거나\n상시 진행 체크박스를 클릭해주세요");
                else {
                  bool success = editMode
                      ? await DatabaseService().editProgram(Program.fromJson(program))
                      : await DatabaseService().addProgram(Program.fromJson(program));
                  if (success)
                    Get.defaultDialog(
                        title: "알림",
                        middleText: "업로드 성공!",
                        onConfirm: () {
                          _controller.resetProgram();
                          Get.offAll(HomePage());
                        });
                  else
                    Get.defaultDialog(title: "알림", middleText: "업로드 실패");
                }
              } else
                print('invalidate');
            },
            label: Text(editMode ? "수정하기" : "제출하기")),
      ),
    );
  }

  Widget _programItem(String title, String type, String initValue, VoidCallback onTap) {
    return Container(
        constraints: BoxConstraints(minHeight: 55),
        color: Colors.transparent,
        width: Get.width * (type == 'googleForm' || type == 'intro' ? 1.0 : 0.5),
        child: TextFormField(
          key: Key(type),
          initialValue: initValue,
          onChanged: (text) => _controller.updateNewProgram(type, text),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: title,
            hintText: '입력해주세요',
            hintStyle: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
            ),
          ),
          maxLines: null,
          maxLength: type == 'intro' ? 500 : null,
          validator: (value) {
            if (program[type] == null)
              return '입력해주세요';
            else
              return null;
          },
        ));
  }

  Widget photoBox() {
    double width = Get.width * 0.5;
    var pic = program["image"];
    return pic != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              radius: 8.0,
              onTap: () => _pickImageFromGallery(),
              child: ClipRRect(
                  borderRadius: new BorderRadius.circular(8.0),
                  child: Image(
                      image: pic.toString().startsWith('http') ? NetworkImage(pic.toString()) : FileImage(new File(pic)),
                      width: width,
                      height: width,
                      fit: BoxFit.cover)),
            ))
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => _pickImageFromGallery(),
              child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                  width: width,
                  height: width,
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.grey,
                    ),
                  )),
            ),
          );
  }

  Future selectDate(BuildContext context, {int index}) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
    if (picked != null) {
      List dateList = program["date"];
      if (dateList == null || dateList.length == 0)
        dateList = [picked];
      else if (index != null)
        dateList[index] = picked;
      else
        dateList.add(picked);
      _controller.updateNewProgram("date", dateList);
    }
  }

  deleteDate() {
    _controller.updateNewProgram("date", []);
  }

  _pickImageFromGallery() async {
    File image = await ImagePickerController.getImage();
    if (image != null) {
      _controller.updateNewProgram("image", image.path);
    }
  }
}
