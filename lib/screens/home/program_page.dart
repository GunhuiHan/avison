import 'package:avisonhouse/screens/home/common_program_detail_page.dart';
import 'package:avisonhouse/screens/home/program_detail_page.dart';
import 'package:avisonhouse/screens/widget/house_title_without.dart';
import 'package:avisonhouse/screens/widget/program_item_card.dart';
import 'package:avisonhouse/services/database.dart';
import 'package:flutter/material.dart';
import 'package:avisonhouse/models/program.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgramPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Program program;
    int programLength;
    int commonProgramLength;
    final Map<int, Program> programs = {};
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('프로그램 게시판'),
            centerTitle: true,
            bottom: TabBar(
              tabs: <Tab>[
                Tab(
                  text: '하우스 프로그램',
                ),
                Tab(text: '전체 프로그램'),
              ],
            ),
          ),
          body: TabBarView(children: [
            Container(
              color: Colors.white,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
//              Padding(
////                padding: const EdgeInsets.only(top: 16.0),
////                child: Align(
////                  alignment: Alignment.center,
////                  child: Text("PROGRAM",
////                      style: Theme.of(context).textTheme.display1),
////                ),
////              ),
//                  Padding(
//                    padding: const EdgeInsets.only(
//                        left: 32.0, right: 32.0, bottom: 8.0),
//                    child: Divider(
//                      thickness: 1,
//                    ),
//                  ),
                  StreamBuilder<Object>(
                      stream: DatabaseService().programLength,
                      builder: (context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Text('programlength error');
                        } else {
                          programLength = snapshot.data.documents.length;
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 0),
                            child: GridView.count(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.all(0),
                              childAspectRatio: (2 / 3),
                              crossAxisCount: 2,
                              scrollDirection: Axis.vertical,
                              children: List.generate(programLength, (_index) {
                                return Container(
                                  padding: EdgeInsets.only(
                                      left: 20.0,
                                      top: 10.0,
                                      right: 20.0,
                                      bottom: 12.0),
                                  child: StreamBuilder<Object>(
                                      stream:
                                          DatabaseService(id: _index).program,
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(
                                              child: Text('Please wait'));
                                        } else {
                                          program = snapshot.data;
                                          programs[_index] = program;
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProgramDetailPage(
                                                            programs[_index])),
                                              );
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Expanded(
                                                  child: ProgramItemCard(
                                                      program: program,
                                                      id: program.id),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4.0),
                                                  child: Text(
                                                    program.title,
                                                    style: GoogleFonts.notoSans(
                                                      textStyle: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  '${program.formattedDate}',
                                                  style: GoogleFonts.notoSans(
                                                    textStyle: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      }),
                                );
                              }),
                            ),
                          );
                        }
                      }),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.only(top: 16.0),
//                child: Align(
//                  alignment: Alignment.center,
//                  child: Text("PROGRAM",
//                      style: Theme.of(context).textTheme.display1),
//                ),
//              ),
//                  Padding(
//                    padding: const EdgeInsets.only(
//                        left: 32.0, right: 32.0, bottom: 8.0),
//                    child: Divider(
//                      thickness: 1,
//                    ),
//                  ),
                  StreamBuilder<Object>(
                      stream: DatabaseService().commonProgram,
                      builder: (context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: Text('준비중입니다.'));
                        } else {
                          commonProgramLength = snapshot.data.documents.length;
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 0),
                            child: GridView.count(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.all(0),
                              childAspectRatio: (2 / 3),
                              crossAxisCount: 2,
                              scrollDirection: Axis.vertical,
                              children:
                                  List.generate(commonProgramLength, (_index) {
                                return Container(
                                    padding: EdgeInsets.only(
                                        left: 20.0,
                                        top: 10.0,
                                        right: 20.0,
                                        bottom: 12.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CommonProgramDetailPage(
                                                      snapshot.data
                                                          .documents[_index])),
                                        );
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                              child: PhysicalModel(
                                                  elevation: 10,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  clipBehavior: Clip.antiAlias,
                                                  color: Colors.white,
                                                  child: Hero(
                                                    tag: snapshot.data
                                                            .documents[_index]
                                                        ['title'],
                                                    child: Image.asset(
                                                      'assets/program/RC$_index.png',
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ))),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4.0),
                                            child: Text(
                                              snapshot.data.documents[_index]
                                                  ['title'],
                                              style: GoogleFonts.notoSans(
                                                textStyle: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                              }),
                            ),
                          );
                        }
                      }),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
