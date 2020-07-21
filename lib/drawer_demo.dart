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

enum SlideDirection{
  Up,
  Down
}

class DrawerDemoState extends State<DrawerDemo> with SingleTickerProviderStateMixin {
  final Size size;

  ///最大高度
  double drawerHeight;
  ///中等高度
  final double searchHeight = 300;
  ///最小高度
  final double minHeight = 150 ;

  final double paddingTop = 70;

  double threshold1To2;
  double threshold2To3;

  DrawerDemoState(this.size){
    drawerHeight = size.height-paddingTop;
    threshold1To2 = size.height/3;
    threshold2To3 = size.height - 250;
  }



  AnimationController animationController;
  Animation animation;



  ///position top's flag
  double top1;
  double top2;
  double top3;

  ///页面初始
  double initPositionTop;

  ///抽屉层级
  DrawerLvl drawerLvl = DrawerLvl.LVL2;

  SlideDirection direction;

  @override
  void initState() {
    animationController = AnimationController(vsync: this,duration: Duration(milliseconds: 300));

    top1 = size.height - drawerHeight;
    top2 = size.height - searchHeight;
    top3 = size.height - minHeight;
    initPositionTop = top2;
    super.initState();

    animationController.addListener(() {
      if(animation == null) return;
      setState(() {
        log('animation', '${animation.value}');
        initPositionTop = animation.value;
      });

    });

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
  ///避免滑动过快，溢出阈值
  final double cacheDy = 5.0;

  void verticalDragStart(DragStartDetails details){
    animation = null;
    if(animationController.isAnimating){
      animationController.stop();
    }
    animationController.reset();
    lastPos = details.globalPosition;
    log('start', '$initPositionTop');
  }

  void verticalDragUpdate(DragUpdateDetails details){
    //debugPrint('update position ${details.globalPosition.dy - lastPos.dy}');
    double dis = details.globalPosition.dy - lastPos.dy;
    if(dis<0){
      direction = SlideDirection.Up;
    }else{
      direction = SlideDirection.Down;
    }

    if(direction == SlideDirection.Up){
      if(initPositionTop <= top1+cacheDy) return;
    }else if(direction == SlideDirection.Down){
      if(initPositionTop >= top3-cacheDy) return;
    }
    log('update', '$initPositionTop');

    initPositionTop += dis;
    lastPos = details.globalPosition;
    setState(() {

    });
  }

  void verticalDragEnd(DragEndDetails details){
    adjustPositionTop();
    direction = null;
    //lastPos = Offset.zero;
  }

  void adjustPositionTop(){
    switch(direction){
      case SlideDirection.Up:
        if(initPositionTop >= top1 && initPositionTop <= top2){
          ///在1、2级之间

          if(initPositionTop <= threshold1To2){
            ///小于二分之一屏幕高度 滚向top1

            slideTo(begin:initPositionTop, end:top1);
          }else{
            ///滑向top2

            slideTo(begin: initPositionTop,end: top2);
          }
        }else if(initPositionTop >= top2 && initPositionTop <= top3){
          ///2-3之间
          if(initPositionTop <= threshold2To3){
            ///滑向2
            slideTo(begin: initPositionTop,end: top2);
          }else{
            ///滑向3
            slideTo(begin: initPositionTop,end: top3);
          }

        }
        break;
      case SlideDirection.Down:
        if(initPositionTop >= top1 && initPositionTop <= top2){
          ///在1、2级之间

          if(initPositionTop <= threshold1To2){
            ///小于二分之一屏幕高度 滚向top1

            slideTo(begin: initPositionTop,end:top1);
          }else{
            ///滑向top2

            slideTo(begin: initPositionTop,end: top2);
          }
        }else if(initPositionTop >= top2 && initPositionTop <= top3){
          ///2-3之间
          if(initPositionTop <= threshold2To3){
            ///滑向2
            slideTo(begin: initPositionTop,end: top2);
          }else{
            ///滑向3
            slideTo(begin: initPositionTop,end: top3);
          }

        }
        break;
    }
  }

  slideTo({double begin,double end})async{
    animation = Tween<double>(begin: begin,end:end ).animate(animationController);
    await animationController.forward();
  }

  log(String title,String info){
    debugPrint('$title ---- $info');
  }


}

















