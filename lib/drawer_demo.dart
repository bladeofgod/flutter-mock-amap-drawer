/*
* Author : LiJiqqi
* Date : 2020/7/20
*/

import 'package:flutter/material.dart';
import 'dart:math' as math;

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

  ///层级之间的阈值
  double threshold1To2;
  double threshold2To3;

  DrawerDemoState(this.size){
    drawerHeight = size.height-paddingTop;
    threshold1To2 = size.height/3;
    threshold2To3 = size.height - 250;
  }



  AnimationController animationController;
  Animation animation;

  ///内部 扩展区widget的 position top
  double expandPosTop;
  ///drawer 内部 多功能区域的滑动范围 0  -  rowH*2
  double topArea ;

  ///stack 中 根container 的position 的top 值的三种情况
  double top1;// DrawerLvl   lvl 1
  double top2;// DrawerLvl   lvl 2
  double top3;// DrawerLvl   lvl 3

  ///页面初始
  double initPositionTop;

  ///抽屉层级
  DrawerLvl drawerLvl = DrawerLvl.LVL2;
  ///滑动方向
  SlideDirection direction;

  @override
  void initState() {

    expandPosTop = searchHeight - minHeight + rowH;
    topArea = 0;
    log('init top', '$expandPosTop');

    animationController = AnimationController(vsync: this,duration: Duration(milliseconds: 300));

    top1 = size.height - drawerHeight;
    top2 = size.height - searchHeight;
    top3 = size.height - minHeight;
    initPositionTop = top2;
    super.initState();

    animationController.addListener(() {
      if(animation == null) return;
      refreshExpandWidgetTop();
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
                  color: Colors.white,
                  child: Stack(
                    children: <Widget>[
                      ///search
                      Container(
                        alignment: Alignment.center,
                        color: Colors.pink,
                        width: size.width,height: searchHeight - minHeight,
                        child: Text('我是搜索'),
                      ),
                      ///transform
                      Positioned(
                        top: searchHeight - minHeight,
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.white,
                          width: size.width,height: rowH * 3+20,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              normalRow(),
                              normalRow(),
                              Container(
                                color: Colors.grey[300],
                                width: size.width,height: rowH,
                                alignment: Alignment.topCenter,
                                child: Text('常去的地方',style: TextStyle(fontSize: 18,color: Colors.black),),
                              )
                            ],
                          ),
                        ),
                      ),
                      ///expand area
                      Positioned(
                        top: expandPosTop + topArea,
                        child: Container(
                          color: Colors.lightGreen,
                          alignment: Alignment.topCenter,
                          width: size.width,height: drawerHeight - searchHeight -rowH,///这里需要在滚动时向下滑动
                          child: Text('我是扩展区域'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )


          ],
        ),
      ),
    );
  }

  ///刷新 扩展区域的 position top值
  ///这里的差值是 rowH * 2
  refreshExpandWidgetTop(){
    double progress = (initPositionTop-top2).abs() /(top2 - top1).abs();
    if(drawerLvl == DrawerLvl.LVL2){
      ///lvl2 滑向 lvl3时 不做处理
      if(initPositionTop > top2) return;
      log('progress', '$progress');
      ///当初为了加别的，这里的代码写的有点多余
      if(direction != null && direction == SlideDirection.Up){
        topArea =  progress * (rowH*2).clamp(0, rowH*2);

      }else if(direction != null && direction == SlideDirection.Down){
        topArea =   (progress * (rowH*2).clamp(0, rowH*2));

      }
    }else if(drawerLvl == DrawerLvl.LVL1){
      ///lvl2 滑向 lvl3时 不做处理
      if(initPositionTop > top2) return;
      ///当初为了加别的，这里的代码写的有点多余
      if(direction != null && direction == SlideDirection.Up){
        topArea = (progress) * (rowH*2).clamp(0, rowH*2);

      }else if(direction != null && direction == SlideDirection.Down){
        topArea =   ((progress) * (rowH*2).clamp(0, rowH*2));

      }
    }
  }

  ///变形金刚区的单行高
  final double rowH = 75;

  Widget normalRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        normalCircle(),
        normalCircle(),
        normalCircle(),
        normalCircle(),
      ],
    );
  }

  final double circleSize = 65;
  Widget normalCircle(){
    return Container(
      width:circleSize ,height: circleSize,
      decoration: BoxDecoration(
        color: Colors.deepOrange,
        shape: BoxShape.circle
      ),
    );
  }

  Offset lastPos;
  ///避免滑动过快，溢出阈值
  final double cacheDy = 5.0;

  markDrawerLvl(){
    double l1 = (top1-initPositionTop).abs();
    double l2 = (top2-initPositionTop).abs();
    double l3 = (top3-initPositionTop).abs();

    if(l1 == (math.min(l1, math.min(l2, l3)))){
      drawerLvl = DrawerLvl.LVL1;
    }else if(l2 == (math.min(l1, math.min(l2, l3)))){
      drawerLvl = DrawerLvl.LVL2;
    }else {
      drawerLvl = DrawerLvl.LVL3;
    }
    log('lvl', '$drawerLvl');
  }

  void verticalDragStart(DragStartDetails details){
    markDrawerLvl();
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
    refreshExpandWidgetTop();
    setState(() {

    });
  }

  void verticalDragEnd(DragEndDetails details){
    adjustPositionTop(details);
    //direction = null;
    //lastPos = Offset.zero;
  }

  double thresholdV = 1500;

  void adjustPositionTop(DragEndDetails details){
    log('velocity', '${details.velocity}');
    switch(direction){
      case SlideDirection.Up:
        if(details.velocity.pixelsPerSecond.dy.abs() > thresholdV){
          ///用户fling速度超过阈值后，直接判定为滑向顶部
          switch(drawerLvl){
            case DrawerLvl.LVL1:
              // TODO: Handle this case.
              break;
            case DrawerLvl.LVL2:
              slideTo(begin: initPositionTop,end: top1);
              break;
            case DrawerLvl.LVL3:
              slideTo(begin: initPositionTop,end: top2);
              break;
          }
        }else{
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
        }
        break;
      case SlideDirection.Down:
        if(details.velocity.pixelsPerSecond.dy.abs() > thresholdV){

          switch(drawerLvl){
            case DrawerLvl.LVL1:
              slideTo(begin: initPositionTop,end: top2);
              break;
            case DrawerLvl.LVL2:
              slideTo(begin: initPositionTop,end: top3);
              break;
            case DrawerLvl.LVL3:
              //todo nothing
              break;
          }
        }else{
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

















