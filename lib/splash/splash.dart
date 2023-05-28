import 'dart:async';

import 'package:animated_widgets/animated_widgets.dart';
import 'package:animated_widgets/widgets/translation_animated.dart';
import 'package:dy_app/register.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

   /* Timer(
      Duration(seconds: 4),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const Reg(),
          ),
        );
      },
    );
*/
    return Scaffold(
      body: Container(
        width: w,
        height: h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: w,
              height: h,
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  'assets/images/splash.png',
                  fit: BoxFit.fill,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            TranslationAnimatedWidget.tween(
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
                  ),
                ),
              ),
              duration: Duration(milliseconds: 1500),
            ),
          ],
        ),
      ),
    );
  }
}
