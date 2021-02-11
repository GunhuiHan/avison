import 'package:avisonhouse/controller/main_controller.dart';
import 'package:avisonhouse/models/program.dart';
import 'package:avisonhouse/pages/home/program_add_page.dart';
import 'package:avisonhouse/pages/home/program_detail_page.dart';
import 'package:avisonhouse/services/database.dart';
import 'package:avisonhouse/utils/util.dart';
import 'package:avisonhouse/widget/cached_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {

  final MainController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    print(_controller.isRa.value);
    return SafeArea(
      child: Obx(
        () => Scaffold(
          floatingActionButton: _controller.isRa.value ?  FloatingActionButton(
            backgroundColor: Get.theme.primaryColorLight,
            child: Icon(Icons.add),
            onPressed: () => Get.to(ProgramAddPage()),
          ) : null,
          body:  Column(
              children: [
                Container(
                  color: Colors.white,
                    child: Row(children: [buildTabbar('하우스 프로그램', 0), buildTabbar('전체 프로그램', 1)],)),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: FutureBuilder<bool>(
                        future: DatabaseService().getPrograms,
                        builder: (context,  snapshot) {
                          if (!snapshot.hasData || !snapshot.data) {
                            return Center(child: CircularProgressIndicator(),);
                          } else {
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 4.0),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0),
                                child: RefreshIndicator(
                                  onRefresh: () => _onRefresh(),
                                  child: ListView(
                                      shrinkWrap: true,
                                      children: _controller.programList.where((element) => element.isCommon == (_controller.tabIndex.value == 1)).toList().map((element) => InkWell(
                                          onTap: () => Get.to(ProgramDetailPage(element)),
                                          child: Row(
                                            children: [
                                              Hero(
                                                  tag : element.id,
                                                  child: cachedImage(element.image)),
                                              SizedBox(width: 8.0,),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(element.title),
                                                    Row(
                                                      children: [
                                                        Text(element.ra + " | ", style: TextStyle(fontSize: 14.0),),
                                                        element.always ? Text('상시진행', style: TextStyle(fontSize: 14.0),) :
                                                        Expanded(
                                                          child: Wrap(
                                                            spacing: 8.0,
                                                            children: element.date.map((e) => Text(UiData.dateFormatter(e), style: TextStyle(fontSize: 14.0),)).toList(),),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ))).toList()
                                  ),
                                )
                            );
                          }
                        }),
                  ),
                ),
              ],
            ),
          ),
      ),

    );
  }

  Future _onRefresh() async {
    await DatabaseService().getPrograms;
  }


  Widget buildTabbar(String tabName, int index) {
    var tabbarWidth = Get.width / 2;
    return Container(
      width: tabbarWidth,
      child: InkWell(
        onTap: () => _controller.updateIndex(index),
        child: Container(
          width: tabbarWidth,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(child: Text(tabName, style: navigationBarTextStyle(_controller.tabIndex.value == index))),
          ),
        ),
      ),
    );
  }


  navigationBarTextStyle(active) {
    if (active)
      return TextStyle(color: Get.theme.indicatorColor, fontSize: 16);
    else
      return TextStyle(color: Colors.black26, fontSize: 16);
  }
}
