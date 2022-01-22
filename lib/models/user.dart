import 'dart:convert';
import 'package:http/http.dart' as http;
Future<User> fetchUser(int userId) async {
  final response = await http.get(Uri.parse('http://localhost:3000/profile/${userId}'));

  if (response.statusCode == 200) {
    //print(response.body);
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final jsonresponse = json.decode(response.body);
    return User.fromJson(jsonresponse[0]);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load User');
  }
}

List<User> userFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));
String userToJson(List<User> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  User({
    required this.id,
    required this.username,
    required this.password,
    required this.cinsiyet,
    required this.stat,
  });
  late final int id;
  late final String username;
  late final String password;
  late final String cinsiyet;
  late final String stat;
  
  User.fromJson(Map<String, dynamic> json){
    id = json['id'];
    username = json['username'];
    password = json['password'];
    cinsiyet = json['cinsiyet'];
    stat = json['statu'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['username'] = username;
    _data['password'] = password;
    _data['cinsiyet'] = cinsiyet;
    _data['statu'] = stat;
    return _data;
  }
}