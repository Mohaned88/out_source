import 'dart:convert';

import 'package:dy_app/DailySafeDate.dart';
import 'package:dy_app/resources/colors.dart';
import 'package:flutter/material.dart';

import '00_home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Reg extends StatefulWidget {
  const Reg({Key? key}) : super(key: key);

  @override
  State<Reg> createState() => _RegState();
}

class _RegState extends State<Reg> {
  final _txtKey = GlobalKey<FormFieldState>();
  final _txtpw = GlobalKey<FormFieldState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List? data;

  Future getManData(String UserName, String Password) async {
    final String url = "http://sales2563.dynamicsdb2.com/api/Login";
    var response = await http.post(
      body: jsonEncode({"userName": "$UserName", "password": "$Password"}),
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json;charset=UTF-8",
        "accept": "text/plain"
      },
    );
    if (response.statusCode == 200) {
      //   print("Saving Data ");
      //   print(response.body);
    } else {
      print(response.statusCode);
    }

    // List jsonResponse = jsonDecode(response.body);

    print("get Mandooooob");
    //  print(jsonResponse);

    setState(() {
      //   data = jsonResponse;
      print("dddddd");
      print(json.decode(json.encode(response.body)));
    });
    data = json.decode(response.body);
    return json.decode(json.encode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/login_cover.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(width * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'تسجيل الدخول',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'GE SS Two',
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: width*0.02,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(width * 0.02),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 0.7,
                            blurRadius: 1,
                            offset: Offset(2, 1),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/login_icon.jpg',
                              color: AppColors.mainColor,
                              width: width*0.5,
                              height: width*0.5,
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: TextFormField(
                                key: _txtKey,
                                controller: nameController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  labelText: 'اسم المندوب',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter Your Name ';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: TextFormField(
                                key: _txtpw,
                                obscureText: true,
                                controller: passwordController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  labelText: 'كلمة السر',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter password text';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            Container(
                              width: width,
                              height: 80,
                              padding: EdgeInsets.all(width * 0.02),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.mainColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(width * 0.2),
                                  ),
                                ),
                                onPressed: () async {
                                  if (nameController.text.isEmpty) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                        title: const Text('تنبيه '),
                                        content:
                                            const Text('من فضلك ادخل كود المندوب'),
                                      ),
                                    );
                                  } else if (passwordController.text.isEmpty) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                        title: const Text('تنبيه '),
                                        content:
                                            const Text('من فضلك ادخل كلمة المرور'),
                                      ),
                                    );
                                  } else {
                                    getManData("${nameController.text}",
                                            "${passwordController.text}")
                                        .then(
                                      (value) async {
                                        print(value.length);
                                        if (value.length > 100) {
                                          final prefs =
                                              await SharedPreferences.getInstance();
                                          await prefs.setDouble(
                                              'tag', data![0]["Mandoubtag"]);
                                          await prefs.setDouble(
                                              'safe_tag', data![0]["SafeAccId"]);
                                          await prefs.setInt(
                                              'safe', data![0]["SafeId"]);
                                          await prefs.setInt(
                                              'store', data![0]["StoreId"]);
                                          await prefs.setString(
                                              'ID', '${data![0]["PersonId"]}');
                                          await prefs.setString('PersonName',
                                              '${data![0]["PersonName"]}');
                                          await prefs.setString(
                                              'Password', '${data![0]["Password"]}');

                                          print(
                                              "${data![0]["Mandoubtag"].toString()}");
                                          print("${data![0]["safe_tag"].toString()}");

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => Login(
                                                value: value,
                                                personid: data![0]["PersonId"],
                                              ),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "خطأ اسم المستخدم و كلمة المرور"),
                                            ),
                                          );
                                        }
                                        ;
                                      },
                                    );
                                    // Navigator.push(
                                    //     context, MaterialPageRoute(builder: (_) => Login()));
                                  }
                                },
                                child: Text(
                                  'دخول',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'GE SS Two',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
