import 'package:flutter/material.dart';

class SendAndReceiveComp extends StatelessWidget {
  final Color? color;
  final String? imagePath;
  final String? text;
  final GestureTapCallback? onTap;

  const SendAndReceiveComp({
    Key? key,
    this.color,
    this.imagePath,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height:w * 0.35,
        width: w * 0.23,
        padding: EdgeInsets.symmetric(vertical: w*0.03),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(w * 0.03),
          color: color!.withOpacity(0.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: w * 0.14,
              height: w * 0.14,
              padding: EdgeInsets.all(w * 0.03),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.5),
              ),
              child: SizedBox(
                width: 0.1,
                height: 0.1,
                child: Image.asset(
                  imagePath ?? 'assets/images/upload_icon.png',
                  color: color,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Text(
              text ?? '...',
              maxLines: 2,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: w * 0.037,
                  color: color,
                  fontFamily: 'GE SS Two',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
