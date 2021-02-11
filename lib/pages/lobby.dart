import 'package:avisonhouse/pages/home/home_page.dart';
import 'package:avisonhouse/pages/calender/calendar_page.dart';
import 'package:avisonhouse/utils/Utility.dart';
import 'package:avisonhouse/widget/custom_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LobbyPage extends StatefulWidget {
  @override
  _LobbyPageState createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> with SingleTickerProviderStateMixin, WidgetsBindingObserver {

  Color get activeColor => Theme.of(context).indicatorColor;


  List get activeIcons => [
    Icon(CupertinoIcons.collections, color: activeColor),
    Icon(Icons.calendar_today, color: activeColor),
  ];
  List inactiveIcons = [
    Icon(CupertinoIcons.collections, color: Colors.black26),
    Icon(Icons.calendar_today, color: Colors.black26),
  ];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    print('lobby dispose ');
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Utility.onWillPop(context), //뒤로가기 눌렀을 때 앱 종료 여부 확인
      child: DefaultTabController(
          length: 5,
          child: Container(
            color: Colors.white,
            child: SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                drawer: Container(
                  width: Get.width * 2 / 3,
                  child: CustomDrawer(),
                ),
                appBar: buildAppBar(context),
                body: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: <Widget>[HomePage(), CalendarPage()]),
                // new
                bottomNavigationBar: SizedBox(
                    height: Get.height * 0.1,
                    child: Row(
                      children: <Widget>[
                        buildTabbar('프로그램', 0),
                        buildTabbar('캘린더', 1),
                      ],
                    )),
              ),
            ),
          )),
    );
  }

  buildAppBar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text(
          '에비슨 하우스',
          style: TextStyle(color: Colors.black),
        ),
        );
  }

  Widget buildTabbar(String tabName, int index) {
    var tabbarWidth = Get.width / 2;
    return Container(
      width: tabbarWidth,
      child: InkWell(
        onTap: () => setState(() {
          _tabController.animateTo(index);
        }),
        child: Container(
          width: tabbarWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _tabController.index == index ? activeIcons[index] : inactiveIcons[index],
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3),
                child: Text(tabName, style: navigationBarTextStyle(_tabController.index == index)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  navigationBarTextStyle(active) {
    if (active)
      return TextStyle(color: activeColor, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1);
    else
      return TextStyle(color: Colors.black26, fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 1);
  }
}
