import 'package:client/notmain.dart';
import 'package:client/screens/loginPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}


class RegScreen extends StatelessWidget {

  TextEditingController myId = TextEditingController();
  TextEditingController userTo = TextEditingController();

  RegScreen({Key? key}) : super(key: key);


   @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color(0xFFEAEFF2),
          height: size.height,
          width: size.width,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    width: size.width * 0.80,
                    child: TextField(
                      controller: myId,
                      cursorColor: Colors.black,
                      autofocus: false,
                      style: const TextStyle(fontSize: 18),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.go,
                      maxLength: 20,
                      decoration: InputDecoration(
                        labelText: 'Kendi idniz',
                        hintText: 'Giriniz',
                        hintStyle: const TextStyle(fontSize: 15),
                        labelStyle: const TextStyle(
                            fontSize: 15, color: const Color(0xFF271160)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: const Color(0xFF271160))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: const Color(0xFF271160))),
                        disabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: const Color(0xFF271160))),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    width: size.width * 0.80,
                    child: TextField(
                      controller: userTo,
                      cursorColor: Colors.black,
                      autofocus: false,
                      style: const TextStyle(fontSize: 18),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.go,
                      maxLength: 20,
                      decoration: InputDecoration(
                        labelText: 'Karşı kullanıcı idsi',
                        hintText: 'Giriniz',
                        hintStyle: const TextStyle(fontSize: 15),
                        labelStyle: const TextStyle(
                            fontSize: 15, color: const Color(0xFF271160)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: const Color(0xFF271160))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: const Color(0xFF271160))),
                        disabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: const Color(0xFF271160))),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  width: size.width * 0.80,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF271160)),
                    onPressed: () {
                      /* print(myId.text);
                      print(userTo.text); */
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                           builder: (context) => NewApp(
                                userId: myId.text,
                                userTo: userTo.text,
                                )));
                    },
                    child: Text('Start Chat',
                            style: const TextStyle(
                                fontSize: 17, color: Colors.white)),
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