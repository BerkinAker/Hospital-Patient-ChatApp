import 'package:client/screens/hospital_screen_body.dart';
import 'package:flutter/material.dart';


class HospitalScreen extends StatelessWidget {
  final int id;
  final String username;
  final String statu;
  final String cinsiyet;
  const HospitalScreen({Key? key, required this.id, required this.username, required this.statu, required this.cinsiyet}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffE2C2BE),
                Color(0xFFA3BDBD),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
            child: Body(id: id, username: username, statu: statu, cinsiyet: cinsiyet,)),
      ),
    );
  }
}
