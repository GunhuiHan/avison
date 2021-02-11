import 'package:avisonhouse/controller/main_controller.dart';
import 'package:avisonhouse/pages/home/program_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:avisonhouse/models/program.dart';
import 'package:google_fonts/google_fonts.dart';

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2020, 1, 1): ['신정'],
  DateTime(2020, 1, 24): ['설날'],
  DateTime(2020, 1, 27): ['설날 \n대체공휴일'],
  DateTime(2020, 3, 1): ['삼일절'],
  DateTime(2020, 4, 15): ['제21대 \n국회의원선거'],
  DateTime(2020, 4, 30): ['어린이날'],
  DateTime(2020, 6, 6): ['현충일'],
  DateTime(2020, 8, 15): ['광복절'],
};

class CalendarPage extends StatefulWidget {

  CalendarPage();
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with TickerProviderStateMixin {
  Map<DateTime, List> _events = {};
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  MainController _controller = Get.find();
  List<Program> get programs => _controller.programList;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();

    for (int i = 0; i < programs.length; i++) {
      for (int j = 0; j < programs[i].date.length; j++) {
        _events.update(
          programs[i].date[j],
          (val) {
            List newList = val;
            newList.add(programs[i]);
            return newList;
          },
          ifAbsent: () => [programs[i]],
        );
      }
    }
    _selectedEvents = _events[_selectedDay] ?? [];

    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 32.0, top: 16.0),
            child: Text('House Calendar',
                style: Theme.of(context).textTheme.display1),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Divider(
            thickness: 1,
          ),
        ),
        // Switch out 2 lines below to play with TableCalendar's settings
        //-----------------------
        _buildTableCalendar(_events),
        // _buildTableCalendarWithBuilders(),
        const SizedBox(height: 8.0),
//              _buildButtons(_events),
        const SizedBox(height: 8.0),
        Expanded(child: _buildEventList()),
        Container(height: 50),
      ],
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar(Map<DateTime, List> _events) {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      calendarStyle: CalendarStyle(
        selectedColor: Theme.of(context).primaryColor,
        todayColor: Theme.of(context).primaryColorLight,
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Theme.of(context).buttonColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'pl_PL',
      calendarController: _calendarController,
//      events: _events,
      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle:
            TextStyle().copyWith(color: Theme.of(context).primaryColor),
        holidayStyle:
            TextStyle().copyWith(color: Theme.of(context).primaryColor),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle:
            TextStyle().copyWith(color: Theme.of(context).buttonColor),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

//  Widget _buildButtons(Map<DateTime, List> _events) {
//    final dateTime = _events.keys.elementAt(_events.length - 2);
//
//    return Column(
//      children: <Widget>[
//        Row(
//          mainAxisSize: MainAxisSize.max,
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: <Widget>[
//            RaisedButton(
//              child: Text('Month'),
//              onPressed: () {
//                setState(() {
//                  _calendarController.setCalendarFormat(CalendarFormat.month);
//                });
//              },
//            ),
//            RaisedButton(
//              child: Text('2 weeks'),
//              onPressed: () {
//                setState(() {
//                  _calendarController
//                      .setCalendarFormat(CalendarFormat.twoWeeks);
//                });
//              },
//            ),
//            RaisedButton(
//              child: Text('Week'),
//              onPressed: () {
//                setState(() {
//                  _calendarController.setCalendarFormat(CalendarFormat.week);
//                });
//              },
//            ),
//          ],
//        ),
//        const SizedBox(height: 8.0),
//        RaisedButton(
//          child: Text(
//              'Set day ${dateTime.day}-${dateTime.month}-${dateTime.year}'),
//          onPressed: () {
//            _calendarController.setSelectedDay(
//              DateTime(dateTime.year, dateTime.month, dateTime.day),
//              runCallback: true,
//            );
//            print(dateTime);
//          },
//        ),
//      ],
//    );
//  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child:
                    ExpansionTile(title: Text(event.title), children: <Widget>[
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Icon(Icons.arrow_forward_ios, size: 18),
                        Text(
                          'View Details',
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProgramDetailPage(event)),
                      );
                    },
                  ),
                ]),
              ))
          .toList(),
    );
  }
}
