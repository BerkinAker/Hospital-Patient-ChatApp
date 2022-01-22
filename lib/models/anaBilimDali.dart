import 'dart:convert';

List<AnaBilimDali> anaBilimDaliFromJson(String str) => List<AnaBilimDali>.from(json.decode(str).map((x) => AnaBilimDali.anaBilimDalifromJson(x)));

String anaBilimDaliToJson(List<AnaBilimDali> data) => json.encode(List<dynamic>.from(data.map((x) => x.anaBilimDalitoJson())));

class AnaBilimDali {
  AnaBilimDali({
    required this.id,
    required this.anaBilimDali,
  });

  late final int id;
  late final String anaBilimDali;


  AnaBilimDali.anaBilimDalifromJson(Map<String, dynamic> json){
    id = json['id'];
    anaBilimDali = json['anaBilimDali'];
  }

  Map<String, dynamic> anaBilimDalitoJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['anaBilimDali'] = anaBilimDali;
    return _data;
  }
}