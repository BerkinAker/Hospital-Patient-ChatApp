import 'dart:convert';

OnlineList onlineFromJson(String str) => OnlineList.onlineFromJson(json.decode(str));

String onlineToJson(OnlineList data) => json.encode(data.onlineToJson());

class OnlineList {
  OnlineList({
    required this.id,


  });

  late final int id;



  OnlineList.onlineFromJson(Map<String, dynamic> json){
    id = json['id'];
 
  }

  Map<String, dynamic> onlineToJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;

    return _data;
  }
}

