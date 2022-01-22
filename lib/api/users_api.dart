import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:client/models/user.dart';

class UsersApi {
  static Future<List<User>> getUsers(String query) async {
  final url = Uri.parse('http://localhost:4320/getSearchUsers');
  final response = await http.get(url); 
  final List users = json.decode(response.body);
  

  print(users);
  return users.map((json) => User.fromJson(json)).where((user){
    final userName = user.username.toLowerCase();

  final searchLower = query.toLowerCase();
   
    print(searchLower);
    return userName.contains(searchLower);
  }).toList();
 
}
}