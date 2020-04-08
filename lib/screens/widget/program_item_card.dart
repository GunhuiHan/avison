import 'package:avisonhouse/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:avisonhouse/models/program.dart';
import 'package:flutter/material.dart';

class ProgramItemCard extends StatelessWidget {
  const ProgramItemCard(
      {Key key,
//      @required this.cardSize,
      @required this.program,
      @required this.id})
      : super(key: key);

//  final double cardSize;
  final int id;
  final Program program;

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
        elevation: 10,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        child: Hero(
          tag: program.title,
          child: Image.asset(
            'assets/program/${program.image}.png',
            fit: BoxFit.fill,
          ),
        ));
  }
}
