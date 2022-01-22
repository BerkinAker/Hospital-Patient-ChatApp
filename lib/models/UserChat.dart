import 'dart:convert';

UserChat fromJson(String str) => UserChat.fromJson(json.decode(str));

String toJson(UserChat data) => json.encode(data.toJson());

class UserChat {
  UserChat({
    required this.userId,
    required this.userTo,
    required this.message,
    required this.statu,
  });

  late final int userId;
  late final int userTo;
  late final String message;  
  late final String statu;

  UserChat.fromJson(Map<String, dynamic> json){
    userId = json['user_id'];
    userTo = json['user_to'];
    message = json['message'];
    statu = json['statu'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user_id'] = userId;
    _data['user_to'] = userTo;
    _data['message'] = message;
    _data['statu'] = statu;
    return _data;
  }
}