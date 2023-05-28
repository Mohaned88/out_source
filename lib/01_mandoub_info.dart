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
    return Scaffold(
        appBar: AppBar(title: Text("بيانات المندوب "),),
        body: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("الاسم",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GE SS Two',
                      )),
                  Text("كود حساب المندوب",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GE SS Two',
                      )),
                  Text("كود المندوب",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GE SS Two',
                      )),
                  Text("اسم المستخدم ",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GE SS Two',
                      )),
                  Text("كلمة السر ",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GE SS Two',
                      )),
                  Text("خزينة ",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GE SS Two',
                      )),
                  Text("كود الخزينة",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GE SS Two',
                      )),
                  Text("مخزن ",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GE SS Two',
                      )),

                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("${widget.InfoList[0]["PersonName"]}",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GE SS Two',
                      )),
                  Text("${widget.InfoList[0]["Mandoubtag"]}",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GE SS Two',
                      )),
                  Text("${widget.InfoList[0]["PersonId"]}",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GE SS Two',
                      )),
                  Text("${widget.InfoList[0]["Username"]}",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GE SS Two',
                      )),
                  Text("${widget.InfoList[0]["Password"]}",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GE SS Two',
                      ))
                  ,Text("${widget.InfoList[0]["SafeId"]}",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GE SS Two',
                      )), Text("${widget.InfoList[0]["SafeAccId"]}",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GE SS Two',
                      )),Text("${widget.InfoList[0]["StoreId"]}",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GE SS Two',
                      ))
                ],
              )
            ],
          ),
        ));
  }
}
