import 'package:avisonhouse/controller/main_controller.dart';
import 'package:avisonhouse/pages/lobby.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      initialBinding: BindingsBuilder(() => {Get.put(MainController())}),
      theme: ThemeData(
          primaryColor: Colors.blue[200],
          primaryColorLight: Colors.blue[200],
          primaryColorDark: Colors.blue[900],
          buttonColor: Colors.blue[400],
          textTheme: TextTheme(
            display1: GoogleFonts.roboto(
              color: Colors.blue[800],
              fontSize: 36,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
            display2: GoogleFonts.montserrat(
              fontSize: 24,
            ),
            body1: GoogleFonts.montserrat(
              fontSize: 20,
            ),
            body2: GoogleFonts.montserrat(
              fontSize: 16,
            ),
          )),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            else if (snapshot.data == null)
              {
                MainController _controller = Get.find();
                _controller.joinRa(false);
                return LobbyPage();
            }
            else {
              MainController _controller = Get.find();
              _controller.joinRa(true);
              return LobbyPage();
            }
          }),
//      theme: ThemeData(fontFamily: 'sandoll'),
    );
  }
}
