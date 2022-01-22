import 'package:client/models/anaBilimDali.dart';
import 'package:client/models/doktor.dart';
import 'package:client/models/user.dart';
import 'package:client/models/onlineList.dart';
import 'package:client/screens/chatPage.dart';
import 'package:client/widgets/searchbar.dart';
import 'package:flutter/material.dart';
import '../common_widgets.dart';
import 'hospital_screen_background.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../constants.dart';
import 'package:client/api/doctors_api.dart';


class Body extends StatefulWidget {
  final int id;
  final String username;
  final String statu;
  final String cinsiyet;

  Body({Key? key, required this.id, required this.username, required this.statu, required this.cinsiyet}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}


class _BodyState extends State<Body> {
  int? counter;
  int? counter2;
  var userResult;
  var anabilimDaliResult;
   String query = '';
  List<Doktor> doctors = [];
  int? isOnline;
  var doktorOnlineId;

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

  Future fetchAnaBilimDallari() async {
    try{
      
      final response2 = await http.get(Uri.parse('http://localhost:4320/fetchAnaBilimDallari'));
        print("2132131");
        print(response2);
        print(response2.body);
      var result2 = anaBilimDaliFromJson(response2.body);
      print(result2[0].anaBilimDali);
      setState(() {
          counter2 = result2.length;
          anabilimDaliResult = result2; 
      });
    } catch (e) {
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
        socket.emit('onlineHasta', widget.id);
      });

      socket.on('doktorOnline', (data){
        print(data);
        doktorOnlineId = data;
        print("doktorOnlineId ytazdiriliyor");
  
      });
    } 
    catch (e) {
      print(e);
    }

    super.initState();
    callPerson(widget.id, widget.username, widget.statu);
    fetchAnaBilimDallari();
    super.initState();
    init();
  }

  Future init() async {
    final doctors = await DoctorsApi.getDoctors(query);
    setState(()=> this.doctors = doctors);
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var array2 = [];
    return userResult == null ? Center(child: CircularProgressIndicator()) : HospitalBackground(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
           
            Padding(
              padding: EdgeInsets.only(left:15,right: 25),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Icon(Icons.menu,color: Colors.black,size: 25,),
                actions: [
                  GestureDetector(
                    //onDoubleTap: (){Navigator.push(context,MaterialPageRoute(builder: (context){return ProfileScreen(userId: widget.userId);}));},
                    child: Container(
                      child: CircleAvatar(
                          child: widget.cinsiyet == "K" ? Image.asset("assets/images/hastawoman.png",alignment: Alignment.center,) : Image.asset("assets/images/hastamale.png",alignment: Alignment.center,
                        ),
                      ),
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Colors.white10,Colors.white],
                          stops: [0,1],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 25,top:15),
                child: Text("Kategoriler",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
            ),
            Container(
              margin: EdgeInsets.only(top:10),
              width: size.width,
              height: 150,
              child: ListView.builder(
                itemCount: counter2,
                itemBuilder: (context, index) {
          
                  return anabilimDaliResult == null ? Center(child: CircularProgressIndicator()) : Row(
                      children: [
                        MyContainer(ImgName: "${anabilimDaliResult[index].anaBilimDali.replaceAll(' ', '')}.png",ImgDesc: anabilimDaliResult[index].anaBilimDali,),
                      ],
                  );
                },  
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
        
          
              ),
            ),
             buildSearch(),
            const Padding(
              padding: EdgeInsets.only(left: 25,top:10),
              child: Text("Doktor Listesi",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
            ),
              Container(
                height: 300,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                  return Container(
                     child: ListTile(
                     title: Text(doctors[index].username,
                     style: titleStyle,),
                     subtitle: Text('Mesaj ikonuna tıklayın'),
                     leading: Stack(
                       children: [
                         CircleAvatar(
                       child: doctors[index].cinsiyet == "K" ? Image.asset('assets/images/femaledoctor.png') : Image.asset('assets/images/maledoctor.png'),
                          ),
                         Positioned(
                            bottom: -3,
                            left: 0,
                          child: doctors[index].id == doktorOnlineId ? Icon(Icons.circle,
                          color: Colors.green,
                          size: 18,
                            ) : Icon(Icons.circle, color: Colors.red, size: 18,)
                          ),
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
                        ),
                      );
                    },
                  itemCount: doctors.length,
                  physics: BouncingScrollPhysics(),
                ),
              ),
           
          ],
        ),
      ),
    );
  }
    Widget buildSearch() => SearchWidget(
      text: query,
      hintText: 'Doktor ismi arayın',
      onChanged: searchDoctor,
  );
  Future searchDoctor(String query) async {
    final doctors = await DoctorsApi.getDoctors(query);
    print("denemelesa1212312312321332");
     if(!mounted) return;

        setState(() {
          this.query = query;
          this.doctors = doctors;
      });
  }
}

