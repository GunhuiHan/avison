import 'package:avisonhouse/models/user.dart';
import 'package:avisonhouse/screens/authenticate/login_page.dart';
import 'package:avisonhouse/screens/authenticate/register_page.dart';
import 'package:avisonhouse/screens/wrapper.dart';
import 'package:avisonhouse/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screens/home/home_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primaryColor: Colors.blue[800],
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
        home: Wrapper(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomePage(),
          '/login': (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => RegisterPage(),
        },
//      theme: ThemeData(fontFamily: 'sandoll'),
      ),
    );
  }
}
