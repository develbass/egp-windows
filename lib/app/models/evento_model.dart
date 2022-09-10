import 'package:app_windows/app/models/user_model.dart';

class Evento {
  int? id;
  String? nome;
  String? status;
  int? userId;
  String? createdAt;
  String? updatedAt;

  Evento(
      {this.id,
      this.nome,
      this.status,
      this.userId,
      this.createdAt,
      this.updatedAt});

  Evento.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    status = json['status'];
    userId = json['user_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['nome'] = nome;
    data['status'] = status;
    data['user_id'] = userId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  static List<Evento>? fromJsonList(List list) {
    return list.map((item) => Evento.fromJson(item)).toList();
  }
}
