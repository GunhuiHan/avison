import 'package:avisonhouse/models/program.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class ProgramDetailPage extends StatefulWidget {
  final Program program;
  ProgramDetailPage(this.program);

  @override
  _ProgramDetailPageState createState() => _ProgramDetailPageState();
}

class _ProgramDetailPageState extends State<ProgramDetailPage>
    with SingleTickerProviderStateMixin {
  int currentValue = 0;
  Widget currentTab;

  AnimationController _animationController;
  Animation<Offset> _movieInformationSlidingAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..forward();
    _movieInformationSlidingAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
            CurvedAnimation(
                curve: Interval(0.25, 1.0, curve: Curves.fastOutSlowIn),
                parent: _animationController));
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
                tag: widget.program.title,
                child: Image.asset(
                  'assets/program/${widget.program.image}.png',
                  fit: BoxFit.fill,
                ),
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
                        child: programPersonnel(widget.program.personnel),
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

  Widget programPersonnel(int personnel) {
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
          padding: const EdgeInsets.only(left: 20.0, top: 8.0),
          child: Text(
            widget.program.title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              Text(widget.program.formattedDate.toString())
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
