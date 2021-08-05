import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:clay_containers/constants.dart';
import 'package:pugmodoro/constans.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> anim;

  double percent = 0;
  static int timeMinute = 25;
  int timeInSec = timeMinute * 60;
  late Timer timer;
  bool isPress = false;
  _startTimer() {
    double secPercent = (timeInSec / 100);
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeInSec > 0) {
          timeInSec--;
          if (timeInSec % 60 == 0) {
            timeMinute--;
          }
          if (timeInSec % secPercent == 0) {
            if (percent < 1) {
              percent += 0.01;
            } else {
              percent = 1;
            }
          }
        } else {
          percent = 0;
          timeMinute = 25;
          timer.cancel();
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(duration: Duration(seconds: 5), vsync: this);
    final curvedAnim = CurvedAnimation(
        parent: animationController,
        curve: Curves.bounceIn,
        reverseCurve: Curves.easeOut);
    anim = Tween<double>(begin: 0, end: 2 * math.pi).animate(curvedAnim)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animationController.forward();
        }
      });
    animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: kBackgroundColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            child: SafeArea(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Stack(
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
                          center: Text(
                            "HUNG",
                          ),

                          circularStrokeCap: CircularStrokeCap.round,

                          widgetIndicator: RotatedBox(
                            quarterTurns: 1,
                            child: Icon(
                              Icons.airplanemode_active_outlined,
                              size: 20,
                              color: Colors.white,
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
                          curveType: CurveType.concave,
                        ),
                        Transform.rotate(
                          angle: anim.value,
                          child: Container(
                            height: 100,
                            child: Image.asset('assets/pug_icon.png'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ClayContainer(
                          color: baseColor,
                          height: 50,
                          width: 50,
                          borderRadius: 75,
                          curveType: CurveType.concave,
                        ),
                        SizedBox(width: 50),
                        ClayContainer(
                          color: baseColor,
                          height: 50,
                          width: 50,
                          borderRadius: 75,
                          curveType: CurveType.none,
                        ),
                        SizedBox(width: 50),
                        ClayContainer(
                          color: baseColor,
                          height: 50,
                          width: 50,
                          borderRadius: 75,
                          curveType: CurveType.convex,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: _startTimer,
                      child: ClayContainer(
                        color: baseColor,
                        height: 50,
                        width: 300,
                        borderRadius: 75,
                        curveType: CurveType.convex,
                        child: Center(
                          child: Text(
                            'START',
                            style: TextStyle(
                                fontSize: 40,
                                fontFamily: 'Gum',
                                color: Colors.blueAccent),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
