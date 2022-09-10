import 'package:app_windows/app/shared/constants.dart';

class Candidato {
  int? id;
  int? eventoId;
  String? nome;
  int? idade;
  String? altura;
  String? foto;
  String? createdAt;
  String? updatedAt;
  String? statusVotacao;
  double? nota;

  Candidato(
      {this.id,
      this.eventoId,
      this.nome,
      this.idade,
      this.altura,
      this.foto,
      this.createdAt,
      this.updatedAt,
      this.statusVotacao,
      this.nota
      });

  Candidato.fromJson(Map<String, dynamic> json) {
    // if(!json['foto'].contains('http')){
    //   json['foto'] = "/arquivos/${json['foto']}";
    // }

    //json['foto'] = DEBUUG ? "https://randomuser.me/api/portraits/women/57.jpg" : json['foto'];

    id = json['id'];
    eventoId = json['evento_id'];
    nome = json['nome'];
    idade = json['idade'];
    altura = json['altura'].toString();
    foto = json['foto'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    statusVotacao = json['status_votacao'];
    nota = json['nota'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['evento_id'] = eventoId;
    data['nome'] = nome;
    data['idade'] = idade;
    data['altura'] = altura;
    data['foto'] = foto;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['status_votacao'] = statusVotacao;
    data['nota'] = nota;
    return data;
  }

  static List<Candidato>? fromJsonList(List list) {
    return list.map((item) => Candidato.fromJson(item)).toList();
  }
}
