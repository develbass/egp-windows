import 'package:app_windows/app/models/voto_model.dart';

class User {
  int? id;
  String? email;
  String? nome;
  String? celular;
  String? roles;
  List<Voto>? votos;

  User({this.id, this.email, this.nome, this.roles});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    nome = json['nome'];
    celular = json['celular'];
    roles = json['roles'];
    votos = json['votos'] != null ? List<Voto>.from(json["votos"].map((x) => Voto.fromJson(x))) : [];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['nome'] = nome;
    data['celular'] = nome;
    data['roles'] = roles;
    data['votos'] = List<dynamic>.from(votos!.map((x) => x.toJson()));
    return data;
  }

  static List<User>? fromJsonList(List list) {
    return list.map((item) => User.fromJson(item)).toList();
  }
}
