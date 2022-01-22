import 'dart:convert';
import 'package:client/models/doktor.dart';
import 'package:http/http.dart' as http;

class DoctorsApi {
  static Future<List<Doktor>> getDoctors(String query) async {
  final url = Uri.parse('http://localhost:4320/getSearchDoctors');
  final response = await http.get(url); 
  final List doctors = json.decode(response.body);
  
  

  print(doctors);
  return doctors.map((json) => Doktor.fromJson(json)).where((doktor){
    final doctorName = doktor.username.toLowerCase();
    final anaBilimDali = doktor.anaBilimId.toString(); 
     final searchLower = query.toLowerCase();


    print(searchLower);
    return doctorName.contains(searchLower);
  }).toList();
 
}

}