class GrupoQuestoes {
  int? eventoId;
  int? id;
  String? nome;
  bool? votando;
  String? questoes;

  GrupoQuestoes(
      {this.eventoId, this.id, this.nome, this.votando, this.questoes});

  GrupoQuestoes.fromJson(Map<String, dynamic> json) {
    eventoId = json['evento_id'];
    id = json['id'];
    nome = json['nome'];
    votando = json['votando'];
    questoes = json['questoes'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['evento_id'] = eventoId;
    data['id'] = id;
    data['nome'] = nome;
    data['votando'] = votando;
    data['questoes'] = questoes;
    return data;
  }
}
