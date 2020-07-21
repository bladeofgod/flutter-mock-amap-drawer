/*
* Author : LiJiqqi
* Date : 2020/7/20
*/

import 'package:flutter/material.dart';

class DrawerDemo extends StatefulWidget{

  final Size size;

  DrawerDemo({this.size}) ;


  @override
  State<StatefulWidget> createState() {
    return DrawerDemoState(size);
  }

}

enum DrawerLvl{
  LVL1,
  LVL2,
  LVL3
}

class DrawerDemoState extends State<DrawerDemo> {
  final Size size;

  ///最大高度
  double drawerHeight;
  ///中等高度
  final double searchHeight = 250;
  ///最小高度
  final double minHeight = 150 ;

  DrawerDemoState(this.size){
    drawerHeight = size.height-70;
  }



  ///position top's flag
  double top1;
  double top2;
  double top3;

  ///页面初始
  double initPositionTop;

  ///抽屉层级
  DrawerLvl drawerLvl = DrawerLvl.LVL2;

  @override
  void initState() {
    top1 = size.height - drawerHeight;
    top2 = size.height - searchHeight;
    top3 = size.height - minHeight;
    initPositionTop = top2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        color: Colors.greenAccent,
        width: size.width,height: size.height,
        child: Stack(
          children: <Widget>[


            Positioned(
              top: initPositionTop,
              child: GestureDetector(
                onVerticalDragStart: verticalDragStart,
                onVerticalDragUpdate: verticalDragUpdate,
                onVerticalDragEnd: verticalDragEnd,

                child: Container(
                  width: size.width,height: drawerHeight,
                  color: Colors.blueAccent,
                  child: Text('drawer lv1'),
                ),
              ),
            )


          ],
        ),
      ),
    );
  }

  Offset lastPos;

  void verticalDragStart(DragStartDetails details){
    lastPos = details.globalPosition;
  }

  void verticalDragUpdate(DragUpdateDetails details){
    debugPrint('update position ${details.globalPosition.dy - lastPos.dy}');
    initPositionTop += details.globalPosition.dy - lastPos.dy;
    lastPos = details.globalPosition;
    setState(() {

    });
  }

  void verticalDragEnd(DragEndDetails details){
    lastPos = Offset.zero;
  }

}

















