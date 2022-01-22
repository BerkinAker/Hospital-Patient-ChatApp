import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:client/models/user.dart';



class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String dropdownvalue = 'HASTA';
  String dropdownvalue2 = 'K';

    Future register(BuildContext cont) async {

    if(nameController.text == '' || passwordController.text == '') {
      Fluttertoast.showToast(
        msg: 'Kullanıcı adı ve Şifre alanı boş bırakılamaz!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        textColor: Colors.white,
        fontSize: 16.0
        );
    }
    else {
          var url = Uri.parse('http://localhost:4320/register');
          var response = await http.post(url, body: {
          'username': nameController.text,
          'password': passwordController.text,
          'giris_statusu': dropdownvalue,
          'cinsiyet': dropdownvalue2,
          }
        );

          var data = response.body;
          print(data);
          
          print("KAYIT BAŞARILI");
           
          var result = userFromJson(response.body);
          var statu = result[0].stat;

          if(statu == "HASTA") {
            print("HASTA KAYIT OLDU");
            /*   Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => HospitalScreen(id: result[0].id,username: result[0].username, statu: result[0].stat, cinsiyet: result[0].cinsiyet,)) //UserHomePage
              ); */
          } else {
            print("DOKTOR KAYIT OLDU");
             /*  Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => UserHomePage(id: result[0].id,username: result[0].username, statu: result[0].stat,)) 
              ); */
            }     
    }
  }

  var items = ['HASTA', 'DOKTOR'];
  var items2 = ['K', 'E'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Kayıt Sayfası'),
          centerTitle: true,
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    height: 280,
                    child: Image.asset('assets/images/login-logo.jpg')),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Kullanıcı Adı',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Şifre',
                    ),
                  ),
                ),  
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                       DropdownButton(
                value: dropdownvalue,
                icon: const Icon(Icons.keyboard_arrow_down),    
                // Array list of items
                items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) { 
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                ),
                SizedBox(width: 30,),
                DropdownButton(
                value: dropdownvalue2,
                icon: const Icon(Icons.keyboard_arrow_down),    
                // Array list of items
                items: items2.map((String items2) {
                    return DropdownMenuItem(
                      value: items2,
                      child: Text(items2),
                    );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) { 
                    setState(() {
                      dropdownvalue2 = newValue!;
                    });
                  },
                ),
              ]
            ,),                           
              TextButton(
                  onPressed: (){
                    //forgot password screen
                  },
                  child: Text('Şifrenizi mi unuttunuz ?'),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: Text('Kayıt Ol'),
                      onPressed: () async {
                        register(context);
                        if(nameController.text.trim().isNotEmpty && passwordController.text.trim().isNotEmpty) {
                        String message = nameController.text.trim() + passwordController.text.trim();
                        print(message);
                          }
                      },
                    )
                  ),
              ],
            )
          )
      );
  }
}