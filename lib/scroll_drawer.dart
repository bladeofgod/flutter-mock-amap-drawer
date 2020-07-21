/*
* Author : LiJiqqi
* Date : 2020/7/21
*/

import 'package:flutter/material.dart';

class ScrollDrawer extends StatefulWidget{

  final Size size;


  ScrollDrawer(this.size);

  @override
  State<StatefulWidget> createState() {
    return ScrollDrawerState(size);
  }

}

class ScrollDrawerState extends State<ScrollDrawer> {

  final Size size;

  ScrollDrawerState(this.size);


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
    );
  }
}
















