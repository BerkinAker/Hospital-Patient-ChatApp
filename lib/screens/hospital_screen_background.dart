import 'package:flutter/material.dart';

class HospitalBackground extends StatelessWidget {
  final Widget child;

  const HospitalBackground({Key? key,required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
        ],
      ),
    );
  }
}