import 'dart:async';

import 'package:animated_widgets/animated_widgets.dart';
import 'package:animated_widgets/widgets/translation_animated.dart';
import 'package:dy_app/register.dart';
import 'package:flutter/material.dart';

import '../resources/colors.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    Timer(
      Duration(seconds: 4),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => OpacityAnimatedWidget.tween(
              enabled: true,
              opacityDisabled: 0,
              opacityEnabled: 0.9,
              duration: Duration(milliseconds: 1600),
              child: const Reg(),
            ),
          ),
        );
      },

    );
    return Scaffold(
      backgroundColor: AppColors.kMainColor,
      body: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(w*0.2),
            bottomRight: Radius.circular(w*0.2),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Container(
              width: w*0.9,
              height: w*0.9,
              child: TranslationAnimatedWidget.tween(
                enabled: true,
                //update this boolean to forward/reverse the animation
                translationDisabled: Offset(0, 320),
                translationEnabled: Offset(0, 0),
                child: OpacityAnimatedWidget.tween(
                  enabled: true,
                  opacityDisabled: 0,
                  opacityEnabled: 0.9,
                  duration: Duration(milliseconds: 1600),
                  child: ScaleAnimatedWidget.tween(
                    enabled: true,
                    duration: Duration(milliseconds: 1500),
                    scaleDisabled: 0.5,
                    scaleEnabled: 1,
                    child: Image.asset(
                      'assets/images/full_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                duration: Duration(milliseconds: 1500),
              ),
            ),
            Positioned(
              bottom: h * 0.05,
              child: Text(
                "مرحبا بكم في تطبيق دينامكس للمندوبين",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'GE SS Two',
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
