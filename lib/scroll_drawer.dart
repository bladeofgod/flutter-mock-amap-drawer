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

  static const double marginTop = 70;

  final double fullHeight;
  final double midHeight = 250;
  final double minHeight = 150;

  ScrollDrawerState(this.size)
  : fullHeight = size.height - marginTop;

  ScrollController scrollController;
  @override
  void initState() {
    scrollController = ScrollController(initialScrollOffset: midHeight);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        color: Colors.greenAccent,
        width: size.width,height: size.height,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: fullHeight),
            color: Colors.blue,
            width: size.width,height: fullHeight,
          ),
        ),
      ),
    );
  }
}
















