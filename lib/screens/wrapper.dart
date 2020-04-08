import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:avisonhouse/screens/home/authenticated_home_page.dart';
import 'package:avisonhouse/models/user.dart';
import 'package:avisonhouse/screens/home/home_page.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // return either Home or Authenticate widget
    if (user == null) {
      return HomePage();
    } else {
      return AuthenticatedHomePage();
    }
  }
}
