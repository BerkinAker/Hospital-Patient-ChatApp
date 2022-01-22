import 'dart:convert';
/* 
Doktor fromJson(String str) => Doktor.fromJson(json.decode(str));

String toJson(Doktor data) => json.encode(data.toJson());
 */
class Doktor {
 
    final int id;
    final String username;
    final String password;  
    final String cinsiyet; 
    final String statu;
    final int anaBilimId; 

  const Doktor ({
    required this.id,
    required this.username,
    required this.password,
    required this.cinsiyet,
    required this.statu,
    required this.anaBilimId,
  });
  
  factory Doktor.fromJson(Map<String, dynamic> json) => Doktor(
    id: json['id'],
    username: json['username'],
    password: json['password'],
    cinsiyet: json['cinsiyet'],
    statu: json['statu'],
    anaBilimId: json['anaBilimId'],
  );
    
  

  Map<String, dynamic> toJson() => {
    'id' : id,
    'username': username,
    'password': password,
    'cinsiyet': cinsiyet,
    'statu': statu,
    'anaBilimId': anaBilimId,
  };
}