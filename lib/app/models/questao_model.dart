import 'package:app_windows/app/models/user_model.dart';

class Questao {
  int? id;
  int? eventoId;
  String? descricao;
  String? tipo;
  int? notaMaxima;
  bool? votando;
  User? user;

  Questao({this.id, this.eventoId, this.descricao, this.tipo, this.notaMaxima, this.votando});

  Questao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventoId = json['evento_id'];
    descricao = json['descricao'];
    tipo = json['tipo'];
    notaMaxima = json['nota_maxima'];
    votando = json['votando'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['evento_id'] = eventoId;
    data['descricao'] = descricao;
    data['tipo'] = tipo;
    data['nota_maxima'] = notaMaxima;
    data['votando'] = votando;
    data['jurado'] = user?.toJson();
    return data;
  }

  static List<Questao>? fromJsonList(List list) {
    return list.map((item) => Questao.fromJson(item)).toList();
  }
}
