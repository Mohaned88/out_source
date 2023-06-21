import 'package:dy_app/resources/colors.dart';
import 'package:flutter/material.dart';

class LinkPreviewComp extends StatelessWidget {
  final String? title;
  final GestureTapCallback? onTap;

  const LinkPreviewComp({
    super.key,
    this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(w*0.03),
      ),
      margin: EdgeInsets.only(top: w*0.03,right: w*0.03,left: w*0.03),
      elevation: w*0.02,
      child: ListTile(
        onTap: onTap,
        title: Text(
          title ?? '',
          style: TextStyle(
            fontFamily: 'GE SS Two',
            fontWeight: FontWeight.bold,
            fontSize: w*0.045,
            //color: Colors.amber,
          ),
        ),
        leading: Container(
          width: w*0.11,
          height: w*0.11,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.mainColor.withOpacity(0.3),
          ),
          child: Icon(
            Icons.note_add_outlined,
            color: AppColors.mainColor,
          ),
        ),
        trailing: Directionality(
          textDirection: TextDirection.ltr,
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
