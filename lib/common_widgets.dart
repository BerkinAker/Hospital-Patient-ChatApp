import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hinttext;
  final String labeltext;
  final bool readonly;
  final TextEditingController controller;


  const MyTextField({Key? key,required this.hinttext,required this.labeltext,required this.readonly, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top:4,bottom: 4),
      padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
      width: size.width*0.6,
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field cannot be left blank';
          }
          return null;
        },
        readOnly: readonly,
        decoration: InputDecoration(
          labelText: labeltext,
          hintText: hinttext,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
class MyContainer extends StatelessWidget {
  final String ImgName;
  final String ImgDesc;
  const MyContainer({Key? key,required this.ImgName,required this.ImgDesc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(left:10,top: 5),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: Container(
              padding: EdgeInsets.all(20),
              width: 120,
              color: Color(0xff5E616D),
              child: Image.asset("assets/images/$ImgName",alignment: Alignment.center,),
            ),
          ),
          Text("$ImgDesc",style: TextStyle(fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}
class MyAnimatedContainer extends StatelessWidget {
  final String ImgName;
  final String DocName;
  const MyAnimatedContainer({
    Key? key,required this.ImgName,required this.DocName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.only(bottom:2),
      alignment: Alignment.center,
      duration: Duration(seconds: 1),
      height: 70,
      child: Card(
        color: Colors.grey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding:EdgeInsets.only(left:10,top:5,bottom: 5,right: 10),
              child: Image.asset("assets/images/$ImgName",),
            ),
            SizedBox(width: 10,),
            Text("$DocName",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}
class MyFlatButton extends StatelessWidget {
  final Widget screen;
  final String text;

  const MyFlatButton({Key? key,required this.screen,required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      width: size.width*0.6,
      decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: Offset(0,10),
              blurRadius: 10,
              color: Colors.grey,
            ),
          ]
      ),
      child: FlatButton(
        onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context){return screen;}));},
        child: Text(text,style: TextStyle(),),
      ),
    );
  }
}





