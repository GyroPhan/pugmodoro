import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:audioplayer/audioplayer.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:clay_containers/constants.dart';
import 'package:pugmodoro/constans.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController animation1Controller;
  late AnimationController animation2Controller;
  late AnimationController animation3Controller;

  late Animation<double> anim1;
  late Animation<double> anim2;
  late Animation<double> anim3;

  final player = AudioPlayer();
  double percent = 0;
  int minu = 25;

  late Timer timer;
  bool isPress = false;
  bool isFinish = false;
  _startTimer() {
    isFinish = false;
    int sec = minu * 60;
    double secPercent = (sec / 100);
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        isPress = true;
        if (sec > 0) {
          sec--;
          if (sec % 60 == 0) {
            minu--;
          }
          if (sec % secPercent == 0) {
            if (percent < 0.99) {
              percent += 0.01;
            } else {
              percent = 0.99;
            }
          }
        } else {
          isPress = false;
          isFinish = true;
          percent = 0;
          minu = 25;
          timer.cancel();
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //animation 1
    animation1Controller =
        AnimationController(duration: Duration(seconds: 5), vsync: this);
    final curvedAnim = CurvedAnimation(
        parent: animation1Controller,
        curve: Curves.bounceIn,
        reverseCurve: Curves.easeOut);
    anim1 = Tween<double>(begin: 0, end: 2 * math.pi).animate(curvedAnim)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animation1Controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animation1Controller.forward();
        }
      });
    animation1Controller.forward();
    //animation 2
    animation2Controller =
        AnimationController(duration: Duration(seconds: 5), vsync: this);
    anim2 =
        Tween<double>(begin: 0, end: 2 * math.pi).animate(animation2Controller)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              animation2Controller.repeat();
            }
          });
    animation2Controller.forward();
    //animation 3
    animation3Controller =
        AnimationController(duration: Duration(seconds: 5), vsync: this);
    anim3 = Tween<double>(begin: 0, end: 30).animate(animation2Controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animation2Controller.repeat();
        }
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animation1Controller.dispose();
    animation2Controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        gradient: kBackgroundColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: height - 230,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClayContainer(
                          color: baseColor,
                          height: 300,
                          width: 300,
                          borderRadius: 300,
                          curveType: CurveType.none,
                        ),
                        CircularPercentIndicator(
                          backgroundColor: Colors.transparent,
                          radius: 270,
                          lineWidth: 25,
                          animation: true,
                          animationDuration: 2500,
                          percent: percent, // percent use
                          animateFromLastPercent: true,

                          circularStrokeCap: CircularStrokeCap.round,
                          widgetIndicator: Transform.rotate(
                            angle: isPress ? anim2.value : 0,
                            child: Container(
                              child: Image.asset('assets/bone.png'),
                            ),
                          ),
                          maskFilter: MaskFilter.blur(BlurStyle.solid, 3),
                          linearGradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.orange, Colors.yellow],
                          ),
                        ),
                        ClayContainer(
                          color: baseColor,
                          height: 180,
                          width: 180,
                          borderRadius: 300,
                          emboss: false,
                          curveType:
                              isPress ? CurveType.concave : CurveType.convex,
                        ),
                        GestureDetector(
                          onTap: _startTimer,
                          child: Transform.rotate(
                            angle: isPress ? anim1.value : 0,
                            child: Container(
                              height: 100,
                              child: Image.asset('assets/pug_icon.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    child: GradientText(
                      fontSize: isFinish ? anim3.value : 0,
                      gradient: kTextColor,
                      text: 'FINISH',
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (minu > 5) {
                              minu = minu - 5;
                            }
                          });
                        },
                        child: ClayContainer(
                          color: baseColor,
                          height: 60,
                          width: 60,
                          borderRadius: 75,
                          curveType: CurveType.convex,
                          child: Icon(
                            Icons.arrow_left_outlined,
                            size: 50,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                      GradientText(
                          text: minu.toString(), gradient: kTextPressColor),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            minu = minu + 5;
                          });
                        },
                        child: ClayContainer(
                          color: baseColor,
                          height: 60,
                          width: 60,
                          borderRadius: 75,
                          curveType: CurveType.convex,
                          child: Icon(
                            Icons.arrow_right,
                            size: 50,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
