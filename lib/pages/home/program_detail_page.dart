import 'package:avisonhouse/controller/main_controller.dart';
import 'package:avisonhouse/models/program.dart';
import 'package:avisonhouse/pages/home/home_page.dart';
import 'package:avisonhouse/pages/home/program_add_page.dart';
import 'package:avisonhouse/services/database.dart';
import 'package:avisonhouse/utils/util.dart';
import 'package:avisonhouse/widget/cached_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ProgramDetailPage extends StatefulWidget {
  final Program program;
  ProgramDetailPage(this.program);

  @override
  _ProgramDetailPageState createState() => _ProgramDetailPageState();
}

class _ProgramDetailPageState extends State<ProgramDetailPage> with TickerProviderStateMixin {
  int currentValue = 0;
  Widget currentTab;

  AnimationController _animationController;
  Animation<Offset> _movieInformationSlidingAnimation;

  MainController _controller =  Get.find();

  @override
  void initState() {
    _animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this)
    ..forward();
    _movieInformationSlidingAnimation =
    Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
    CurvedAnimation(
    curve: Interval(0.25, 1.0, curve: Curves.fastOutSlowIn),
    parent: _animationController));
    super.initState();

  }

  @override
  dispose() {
    _animationController.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: MediaQuery.of(context).size.height / 1.5,
            flexibleSpace: FlexibleSpaceBar(
                background: Container(
              padding: EdgeInsets.only(
                  left: 24.0, top: 12.0, right: 24.0, bottom: 24.0),
              child: Hero(
                tag: widget.program.id,
                child: cachedImage(widget.program.image, radius: 12.0)
              ),
            )),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _createTitle(),
              createAnimatedIntro(),
            ]),
          )
        ],
      ),
    ));
  }

//  FutureBuilder<Object>(
//  future:
//  DatabaseService(id: widget.program.id).programImageUrl,
//  builder: (context, snapshot) {
//  if (!snapshot.hasData) {
//  return Center(
//  child: Container(child: CircularProgressIndicator()));
//  } else {
//  String programUrl = snapshot.data;
//  return Image.network(
//  programUrl,
//  fit: BoxFit.fill,
//  );
//  }
//  }),

  Widget createAnimatedIntro() {
    return AnimatedBuilder(
      animation: _animationController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CupertinoSegmentedControl(
            selectedColor: Theme.of(context).primaryColor,
            groupValue: currentValue,
            children: const <int, Widget>{
              0: Text('Summary'),
              1: Text('Details'),
            },
            onValueChanged: (value) {
              if (value == 0) {
                currentTab = Padding(
                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(widget.program.intro,
                            style: TextStyle(fontSize: 14)),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                );
              } else {
                currentTab = Padding(
                  padding: EdgeInsets.only(left: 24, top: 16, right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: programTime(widget.program.time),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: programLocation(widget.program.location),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: programPersonnel(widget.program.num),
                      ),
                      programGoogleForm(widget.program.googleForm),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                );
              }
              setState(() {
                currentValue = value;
              });
            },
          ),
          currentTab ??
              Padding(
                padding: EdgeInsets.only(left: 24, top: 16, right: 24),
                child: Column(
                  children: <Widget>[
                    Text(widget.program.intro, style: TextStyle(fontSize: 14)),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              )
        ],
      ),
      builder: (BuildContext context, Widget child) {
        return Opacity(
          opacity: _animationController.value,
          child: FractionalTranslation(
            translation: _movieInformationSlidingAnimation.value,
            child: child,
          ),
        );
      },
    );
  }

  Widget programTime(String time) {
    if (time == null) {
      return Text(
        'Time : 전체공지방을 확인해주세요',
        style: TextStyle(fontSize: 16),
      );
    } else {
      return Text('Time : ' + time, style: TextStyle(fontSize: 16));
    }
  }

  Widget programLocation(String location) {
    if (location == null) {
      return Text('Location : 전체공지방을 확인해주세요', style: TextStyle(fontSize: 16));
    } else {
      return Text('Location : ' + location, style: TextStyle(fontSize: 16));
    }
  }

  Widget programPersonnel(String personnel) {
    if (personnel == null) {
      return Text('Personnel : 전체공지방을 확인해주세요', style: TextStyle(fontSize: 16));
    } else {
      return Text('Personnel : ' + personnel.toString(),
          style: TextStyle(fontSize: 16));
    }
  }

  Widget programGoogleForm(String googleForm) {
    if (googleForm == null) {
      return Text('신청 : 전체공지방을 확인해주세요', style: TextStyle(fontSize: 16));
    } else {
      return RichText(
        text: TextSpan(children: [
          TextSpan(
              text: '신청링크 : ' + googleForm,
              style: TextStyle(color: Colors.black),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launch(googleForm);
                })
        ]),
      );
    }
  }

  Widget _createTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 8.0, right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.program.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if(_controller.isRa.value)
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          _controller.initEditProgram(widget.program);
                          return Get.defaultDialog(title: "알림", middleText: "정말 삭제하시겠습니까?", onConfirm: () async {
                            bool success = await DatabaseService().deleteProgram(widget.program.id);
                            if (success)
                              Get.defaultDialog(
                                  title: "알림",
                                  middleText: "삭제되었습니다.",
                                  onConfirm: () {
                                    _controller.deleteProgram(widget.program);
                                    Get.offAll(HomePage());
                                  });
                          });
                        },
                        child: Icon(Icons.delete, color: Colors.red[300],)),
                    SizedBox(width: 8.0,),
                    GestureDetector(
                      onTap: () {
                        _controller.initEditProgram(widget.program);
                        return Get.to(ProgramAddPage(editMode: true,));
                      },
                        child: Icon(Icons.edit)),
                  ],
                )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.date_range),
              ),
              Expanded(
                child: Wrap(
                  spacing: 8.0,
                  children: widget.program.date.map((e) => Text(UiData.dateFormatter(e))).toList(),),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.person),
              ),
              Text(widget.program.ra + 'RA')
            ],
          ),
        ),
//        Padding(
//          padding: const EdgeInsets.only(left: 16.0, top: 12.0),
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.start,
//            children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.only(right: 8.0),
//                child: Icon(Icons.timer),
//              ),
//              Text('${widget.program.time}')
//            ],
//          ),
//        ),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 12.0, bottom: 12.0),
          child: Text(
            '* 담당RA에 의해 변동될 수 있습니다. 전체공지방을 확인해주세요.',
            style: TextStyle(fontSize: 12),
          ),
        )
      ],
    );
  }

  List<Widget> _createCinemaList(List cinemas) {
    List<Widget> cinemaWidgetList = [];

    cinemas.forEach((cinema) {
      cinemaWidgetList.add(Container(
        padding: EdgeInsets.only(left: 16, top: 16, right: 16),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.payment,
              size: 50,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(cinema.theaterName),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                  ),
                  child: Text(cinema.theaterPhone),
                ),
                CupertinoButton(
                  child: Text(
                    'Add to the favourites',
                    style: TextStyle(
                        color: CupertinoTheme.of(context).primaryColor),
                  ),
                  onPressed: () {},
                )
              ],
            )
          ],
        ),
      ));
    });
    return cinemaWidgetList;
  }
}
