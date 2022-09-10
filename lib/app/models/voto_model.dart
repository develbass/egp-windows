class Voto {
  int? userId;
  int? eventoId;
  int? questaoId;
  int? candidatoId;
  int? nota;
  int? id;

  Voto(
      {this.userId,
      this.eventoId,
      this.questaoId,
      this.candidatoId,
      this.nota,
      this.id});

  Voto.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    eventoId = json['evento_id'];
    questaoId = json['questao_id'];
    candidatoId = json['candidato_id'];
    nota = json['nota'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['user_id'] = userId;
    data['evento_id'] = eventoId;
    data['questao_id'] = questaoId;
    data['candidato_id'] = candidatoId;
    data['nota'] = nota;
    data['id'] = id;
    return data;
  }

  static List<Voto>? fromJsonList(List list) {
    return list.map((item) => Voto.fromJson(item)).toList();
  }
}
