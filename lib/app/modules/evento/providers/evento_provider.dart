import 'dart:io';

import 'package:app_windows/app/models/candidato_model.dart';
import 'package:app_windows/app/models/questao_model.dart';
import 'package:app_windows/app/models/voto_model.dart';
import 'package:get/get.dart';

import '../../../models/user_model.dart';
import '../../../shared/constants.dart';
import '../../../shared/http_custom.dart';


class EventoProvider extends RestClient {

  @override
  void onInit() {
    httpClient.baseUrl = URL_API;
  }

  Future<List<Candidato>?> getCandidatos(eventoId) async {
    var response =
        await post("${URL_API}/eventos/candidatos", {"evento_id": eventoId});
    return Candidato.fromJsonList(requestFiltro(response));
  }

  Future<List<Questao>?> getQuestoes(eventoId) async {
    var response =
        await post("${URL_API}/eventos/questoes", {"evento_id": eventoId});
    return Questao.fromJsonList(requestFiltro(response));
  }

  Future<List<User>?> getJurados(eventoId) async {
    var response =
        await post("${URL_API}/eventos/jurados", {"evento_id": eventoId});
    return User.fromJsonList(requestFiltro(response));
  }

  Future<dynamic> mostrarCandidato(candidatoId, status) async {
    var response = await post("${URL_API}/eventos/mostrar-candidato",
        {"candidato_id": candidatoId, "status": status});
    return requestFiltro(response);
  }

  Future<dynamic> mudarStatus(
      candidatoId, questaoId, status, statusQuestao) async {
    var response = await post("${URL_API}/eventos/mudar-status", {
      "candidato_id": candidatoId,
      "questao_id": questaoId,
      "status": status,
      "status_questao": statusQuestao
    });
    return requestFiltro(response);
  }

    

  Future<dynamic> mediaCandidatos(eventoId) async {
    var response = await post("${URL_API}/eventos/media", {"evento_id": eventoId},);
    return requestFiltro(response);
  }

  Future<bool> encerrar(eventoId) async {
    var response =
        await post("${URL_API}/eventos/encerrar", {"evento_id": eventoId});
    return requestFiltro(response);
  }
  
  Future<dynamic> resultadoPorCategoria(eventoId) async {
    var response =
        await post("${URL_API}/eventos/resultados-nota-por-categoria", {"evento_id": eventoId});
    return requestFiltro(response);
  }
}
