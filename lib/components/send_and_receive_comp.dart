import 'package:auto_size_text/auto_size_text.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';

class SendAndReceiveComp extends StatelessWidget {
  final Color? color;
  final String? imagePath;
  final String? text;
  final GestureTapCallback? onTap;
  bool status;


  SendAndReceiveComp({
    Key? key,
    this.color,
    this.imagePath,
    this.text,
    this.onTap,
    this.status = false,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: status ? null : onTap,
      child: Container(
        height:w * 0.36,
        width: w * 0.23,
        padding: EdgeInsets.symmetric(vertical: w*0.03),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(w * 0.03),
          color: status ? Colors.grey.withOpacity(0.2) : color!.withOpacity(0.2),
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
              child: Image.asset(
                imagePath ?? 'assets/images/upload_icon.png',
                width: w*0.1,
                height: w*0.1,
                color: status ? Colors.grey : color,
                fit: BoxFit.contain,
              ),
            ),

            AutoSizeText(
              text ?? '...',
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              maxLines: 2,
              style: TextStyle(
                fontSize: w * 0.037,
                color: status ? Colors.grey : color,
                fontFamily: 'GE SS Two',
              ),
              /*child: Text(
                text ?? '...',
                maxLines: 2,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: w * 0.037,
                    color: color,
                    fontFamily: 'GE SS Two',
                ),
              ),*/
            ),
          ],
        ),
      ),
    );
  }
}
