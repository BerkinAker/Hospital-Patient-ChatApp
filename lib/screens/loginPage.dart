import 'package:client/models/user.dart';
import 'package:client/screens/hospital_screen.dart';
import 'package:client/screens/registerPage.dart';
import 'package:client/screens/userMainPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({Key? key}) : super(key: key);

   @override
  State<LoginPage> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String dropdownvalue = 'HASTA';

   Future login(BuildContext cont) async {
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
          var url = Uri.parse('http://localhost:4320/login');
          var response = await http.post(url, body: {
          'username': nameController.text,
          'password': passwordController.text,
          'giris_statusu': dropdownvalue,
          }
        );
          var data = response.body;
          print(data);
          if(data == "Basarisiz") {
          print("GİRİŞ BİLGİLERİ HATALI!");
          //print(data);
          Fluttertoast.showToast(
            msg: 'Kullanıcı adı veya Şifre HATALI!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            textColor: Colors.white,
            fontSize: 16.0
            );
        } 
        else {
            print("GİRİŞ YAPILDI");
           
            var result = userFromJson(response.body);
            var statu = result[0].stat;

            if(statu == "HASTA") {
              print("HASTA GİRİŞ YAPTI");
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => HospitalScreen(id: result[0].id,username: result[0].username, statu: result[0].stat, cinsiyet: result[0].cinsiyet,)) //UserHomePage
              );
            } else {
              print("DOKTOR GİRİŞ YAPTI");
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => UserHomePage(id: result[0].id,username: result[0].username, statu: result[0].stat,)) 
              );
            }
          }    
    }
  }
  var items = ['HASTA', 'DOKTOR'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Giriş Sayfası'),
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
              Center(
                child: DropdownButton(
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
              ),

              TextButton(
                    onPressed: (){
                      
                  },
                  child: Text('Şifrenizi mi unuttunuz ?'),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: Text('Giriş Yap'),
                      onPressed: () async {
                        login(context);
                        if(nameController.text.trim().isNotEmpty && passwordController.text.trim().isNotEmpty) {
                        String message = nameController.text.trim() + passwordController.text.trim();
                        print(message);
                          }
                      },
                    )),

                Container(
                    child: Row(
                      children: <Widget>[
                        Text('Hesabınız yok mu ?'),
                        TextButton(
                          child: Text(
                            'Kayıt Olun',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => RegisterPage()) 
                              );
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ))
              ],
            )
          )
      );
  }
}