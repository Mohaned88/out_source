import 'package:dy_app/resources/colors.dart';
import 'package:flutter/material.dart';

class Info extends StatefulWidget {
  Info({Key? key, required this.InfoList}) : super(key: key);
  List InfoList;

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  void initState() {
    print(widget.InfoList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.mainColor,
        appBar: AppBar(
          title: Text(
            "بيانات المندوب ",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'GE SS Two',
            ),
          ),
          backgroundColor: AppColors.mainColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
            iconSize: w*0.07,
          ),
        ),
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(w * 0.1),
                topLeft: Radius.circular(w * 0.1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: w*0.5,
                  decoration: BoxDecoration(
                    color: AppColors.mainColor.withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(w * 0.1),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "الاسم",
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'GE SS Two',
                        ),
                      ),
                      Text(
                        "كود حساب المندوب",
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'GE SS Two',
                        ),
                      ),
                      Text(
                        "كود المندوب",
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'GE SS Two',
                        ),
                      ),
                      Text(
                        "اسم المستخدم ",
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'GE SS Two',
                        ),
                      ),
                      Text(
                        "كلمة السر ",
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'GE SS Two',
                        ),
                      ),
                      Text(
                        "خزينة ",
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'GE SS Two',
                        ),
                      ),
                      Text(
                        "كود الخزينة",
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'GE SS Two',
                        ),
                      ),
                      Text(
                        "مخزن ",
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'GE SS Two',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: w*0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "${widget.InfoList[0]["PersonName"]}",
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'GE SS Two',
                        ),
                      ),
                      Text(
                        "${widget.InfoList[0]["Mandoubtag"]}",
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'GE SS Two',
                        ),
                      ),
                      Text(
                        "${widget.InfoList[0]["PersonId"]}",
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'GE SS Two',
                        ),
                      ),
                      Text(
                        "${widget.InfoList[0]["Username"]}",
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'GE SS Two',
                        ),
                      ),
                      Text(
                        "${widget.InfoList[0]["Password"]}",
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'GE SS Two',
                        ),
                      ),
                      Text(
                        "${widget.InfoList[0]["SafeId"]}",
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'GE SS Two',
                        ),
                      ),
                      Text(
                        "${widget.InfoList[0]["SafeAccId"]}",
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'GE SS Two',
                        ),
                      ),
                      Text(
                        "${widget.InfoList[0]["StoreId"]}",
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'GE SS Two',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
