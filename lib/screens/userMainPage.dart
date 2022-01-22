import 'package:client/models/user.dart';
import 'package:client/screens/chatPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../constants.dart';
import 'package:client/api/users_api.dart';
import 'package:client/widgets/searchbar.dart';

class UserHomePage extends StatefulWidget {
  final int id;
  final String username;
  final String statu;
  UserHomePage({Key? key, required this.id, required this.username, required this.statu}) : super(key: key);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
 int? counter;
 var userResult;
  String query = '';
  List<User> users = [];
  var hastaOnlineId;
  Future callPerson(int id, String userName, String statu) async {
    
    try{
      final response = await http.get(Uri.parse('http://localhost:4320/fetchAllUsers/${statu}'));
        var result = userFromJson(response.body);
        //print(result[0].username);
        if(mounted)
        setState(() {
          counter = result.length;
          userResult = result;
          
      });
      return result;
    } catch(e) {
      print(e.toString());
    }
  }

  late IO.Socket socket;

  @override
  void initState() {
   try{
      socket = IO.io('http://10.0.2.2:4320', <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': false,
        });
    
      socket.connect();

      socket.on("connect", (data) {
        print(socket.id);
        socket.emit('onlineDoktor', widget.id);
      });

       socket.on('hastaOnline', (data){
        print(data);
        hastaOnlineId = data;
      });


    } 
    catch (e) {
      print(e);
    }

    super.initState();
    callPerson(widget.id, widget.username, widget.statu);
    init();
  }

  Future init() async {
    final users = await UsersApi.getUsers(query);
    setState(()=> this.users = users);
  }

  @override
  Widget build(BuildContext context) {
      //print(widget.id);
      //print(widget.username);
    return userResult == null ? Center(child: CircularProgressIndicator()) : Scaffold(
       appBar: AppBar(
         title: widget.statu == 'HASTA' ? Text('Doktor Listesi') : Text('Hasta Listesi'),
         backgroundColor: Colors.teal,
         ),
         body: Column(
            children: [
              buildSearch(),
               Expanded(
                  child: ListView.builder(
                 physics: const BouncingScrollPhysics(),
                 itemCount: users.length,
                 itemBuilder: (context, index) {
                   return ListTile(
                     title: Text(users[index].username,
                     style: titleStyle,),
                     subtitle: Text('Mesaj ikonuna tıklayın'),
                     leading: Stack(
                       children: [
                        CircleAvatar(
                         child: users[index].cinsiyet == "K" ? Image.asset('assets/images/hastawoman.png') : Image.asset('assets/images/hastamale.png'),
                         backgroundColor: Colors.black54,
                        ),
                        Positioned( bottom: -3,
                            left: 0,
                          child: users[index].id == hastaOnlineId ? Icon(Icons.circle,
                          color: Colors.green,
                          size: 18,
                            ) : Icon(Icons.circle, color: Colors.red, size: 18,)),
                     ],
                                           
                     ),
                      trailing: IconButton(
                         icon: const Icon(Icons.message),
                         onPressed: () {
                           //print(userResult[index].id);
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => ChatPage(userId: widget.id, userTo: userResult[index].id, usernameMe: widget.username, usernameTo: userResult[index].username, statu: widget.statu,)) 
                          );
                         },
                     ),
                   );
                 }),
               ),
            ],
              
         
         ),
         floatingActionButton: FloatingActionButton(
           child: Icon(Icons.refresh),
           backgroundColor: Colors.teal,
           onPressed: () {
             callPerson(widget.id, widget.username, widget.statu);
           },
         ),
         bottomNavigationBar: 
         Container(
           decoration: BoxDecoration(color: Colors.blueAccent,borderRadius: BorderRadius.circular(10.0),border: Border.all(color: Colors.black, width: 2.0),
           gradient: LinearGradient(
             colors: [
              Colors.white60,
              Colors.teal,
              ]
              ),
              boxShadow: [
            BoxShadow(
              color: Colors.grey ,
              blurRadius: 2.0,
              offset: Offset(2.0,2.0)
            )
          ]
            ),
              child: Padding(
             padding: EdgeInsets.all(10.0),
              child: BottomAppBar(
              color: Colors.transparent,
              child: Text('Giriş yapan doktor: ' + widget.username, 
              style: userNameStyle,),
             elevation: 0,
              
      ),
           ),
         ),
    );
  }

   Widget buildSearch() => SearchWidget(
      text: query,
      hintText: 'Hasta ismi giriniz',
      onChanged: searchUser,
  );
  Future searchUser(String query) async {
    final users = await UsersApi.getUsers(query);

     if(!mounted) return;

        setState(() {
          this.query = query;
          this.users = users;
      });
  }
}