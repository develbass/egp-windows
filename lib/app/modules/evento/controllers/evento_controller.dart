import 'package:app_windows/app/models/candidato_model.dart';
import 'package:app_windows/app/models/grupo_questoes_model.dart';
import 'package:app_windows/app/models/questao_model.dart';
import 'package:app_windows/app/models/user_model.dart';
import 'package:app_windows/app/models/voto_model.dart';
import 'package:app_windows/app/modules/evento/providers/evento_provider.dart';
import 'package:app_windows/app/shared/constants.dart';
import 'package:get/get.dart';
import 'package:hasura_connect/hasura_connect.dart';

import '../../../shared/hasura_connect_custon.dart';

class EventoController extends GetxController {
  EventoProvider provider = EventoProvider();
  final Rx<List<Candidato>> candidatos = Rx<List<Candidato>>([]);
  final Rx<List<Candidato>> candidatosObserver = Rx<List<Candidato>>([]);
  final Rx<List<Questao>> questoes = Rx<List<Questao>>([]);
  final Rx<List<User>> jurados = Rx<List<User>>([]);
  final Rx<Candidato> candidatoEmVotacao = Rx<Candidato>(Candidato());
  final Rx<List<Voto>> votos = Rx<List<Voto>>([]);
  final Rx<bool> spinner = Rx<bool>(false);
  late bool souJurado = false;
  final Rx<Questao> questaoVotar = Rx<Questao>(Questao());
  final Rx<bool> eventoEncerrado = Rx<bool>(false);
  final Rx<dynamic> resultadoDasCategorias = Rx<dynamic>(null);
  final Rx<GrupoQuestoes> grupo = Rx<GrupoQuestoes>(GrupoQuestoes());
  Snapshot? snapshot;
  Snapshot? snapshotQuestoes;
  Snapshot? snapshotVotos;
  Snapshot? snapshotVotosJurados;
  Snapshot? snapshotVotosObserver;
  Snapshot? snapshotGruposObserver;
  Snapshot? snapshotQuestoesObserver;

  int count = 0;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    snapshot?.close();
    snapshotQuestoes?.close();
    snapshotVotos?.close();
    snapshotVotosJurados?.close();
    snapshotVotosObserver?.close();
    snapshotGruposObserver?.close();
    snapshotQuestoesObserver?.close();
  }

  bool isInteger(num value) => value is int || value == value.roundToDouble();

  bool isString(value) => value is String;

  void mediaDosCandidatos(eventoId) async {
    try {
      var m = await provider.mediaCandidatos(eventoId);

      if (m != null) {
        List<Candidato> lista = [];

        candidatosObserver.value.forEach((j) {
          m.forEach((item) {
            var inteiro = isInteger(item['nota']);
            var ehString = isString(item['nota']);

            double valor = inteiro ? item['nota'].toDouble() : item['nota'];

            if (item['id'] == j.id) {
              j.nota = valor;
              lista.add(j);
            }
          });
        });

        lista.sort((a, b) => b.nota!.compareTo(a.nota!));

        candidatosObserver.value = lista;
        count++;
      }
    } catch (e) {
      alerta(title: "Atenção", description: e.toString());
    }
  }

  void zerarVotosJurados(){
    List<User> juradosArr = [];
    var lista = jurados.value;

      jurados.value.forEach((j) {
        lista.forEach((v) {
          if (v.id == j.id) {
            j.votos?.clear();
          }
        });

        juradosArr.add(j);
      });

      jurados.value = juradosArr;
  }

  void statusCandidatos(id) async {
    var query = """
      subscription MySubscription(\$eventoId: Int) {
        candidatos(where: {evento_id: {_eq: \$eventoId}}, order_by: {nome: asc}) {
          id
          foto
          idade
          nome
          altura
          status_votacao
        }
      }

    """;
    snapshot =
        await hasuraConnect.subscription(query, variables: {"eventoId": id});
    snapshot?.listen((data) {
      candidatosObserver.value.clear();
      var dados = data['data'];
      List<Candidato>? lista = Candidato.fromJsonList(dados['candidatos']);
      candidatosObserver.value = lista ?? [];
      candidatoEmVotacao.value = Candidato();
      bool temDiferenteDeEncerrado = false;

      zerarVotosJurados();

      lista?.forEach((item) {
        if (item.statusVotacao != StatusVotacao.ENCERRADO) {
          temDiferenteDeEncerrado = true;
        }
      });

      eventoEncerrado.value = !temDiferenteDeEncerrado;

      if(eventoEncerrado.value){
        resultadoPorCategoria(id);
      }

      lista?.forEach((item) {
        if (item.statusVotacao != null &&
            item.statusVotacao != StatusVotacao.ENCERRADO) {
          candidatoEmVotacao.value = item;
        }
      });

      // if (estaEncerrado) {
      //   mediaDosCandidatos(id);
      // }
    }).onError((err) {
      printar(err);
    });
  }

  void statusQuestoes(id) async {
    var query = """
       subscription MySubscription(\$eventoId: Int) {
        questoes(where: {evento_id: {_eq: \$eventoId}}, order_by: {descricao: asc}) {
          descricao
          id
          nota_maxima
          tipo
          votando
        }
      }
    """;
    snapshotQuestoes =
        await hasuraConnect.subscription(query, variables: {"eventoId": id});
    snapshotQuestoes?.listen((data) {
      var dados = data['data'];
      List<Questao>? lista = Questao.fromJsonList(dados['questoes']);
      questoes.value = lista ?? [];
      questaoVotar.value = Questao();

      questoes.value.forEach((item) {
        if (item.votando != null) {
          questaoVotar.value = item;
        }
      });
    }).onError((err) {
      printar(err);
    });
  }

  void votosSubscrition(eventoId) async {
    var query = """
       subscription MySubscription(\$eventoId: Int) {
        votos(where: {evento_id: {_eq: \$eventoId}}) {
          user_id
          questao_id
          nota
          id
          candidato_id
        }
      }

    """;
    snapshotVotos = await hasuraConnect.subscription(query,
        variables: {"eventoId": eventoId});

    snapshotVotos?.listen((data) {
      var dados = data['data'];
      List<Voto>? lista = Voto.fromJsonList(dados['votos']);
      votos.value = lista ?? [];
      printar(votos.value);
    }).onError((err) {
      printar(err);
    });
  }

  void votosJuradosSubscrition(eventoId) async {
    var query = """
       subscription MySubscription(\$jurados: [Int!], \$eventoId: Int) {
        votos(where: {evento_id: {_eq: \$eventoId}, user_id: {_in: \$jurados}}) {
          candidato_id
          id
          jurado
          nota
          questao_id
          user_id
        }
      }

    """;

    List<int> juradosIds = [];

    jurados.value.forEach((element) {
      juradosIds.add(element.id!);
    });

    snapshotVotosJurados = await hasuraConnect.subscription(query,
        variables: {"jurados": juradosIds, "eventoId": eventoId});

    snapshotVotosJurados?.listen((data) {
      var dados = data['data'];
      List<Voto>? lista = Voto.fromJsonList(dados['votos']);
      List<User> juradosArr = [];

      jurados.value.forEach((j) {
        lista?.forEach((v) {
          if (v.userId == j.id) {
            j.votos?.add(v);
          }
        });

        juradosArr.add(j);
      });

      jurados.value = juradosArr;
    }).onError((err) {
      printar(err);
    });
  }

  void votosObserver(eventoId) async {
    var query = """
      subscription MySubscription(\$eventoId: Int) {
        votos_aggregate(where: {evento_id: {_eq: \$eventoId}}) {
          aggregate {
            count(columns: nota)
          }
        }
      }

    """;
    snapshotVotosObserver = await hasuraConnect
        .subscription(query, variables: {"eventoId": eventoId});

    snapshotVotosObserver?.listen((data) {
      var dados = data['data'];
      printar(dados['votos_aggregate']['aggregate']['count']);

      if (count > 0) {
        mediaDosCandidatos(eventoId);
      }
    }).onError((err) {
      printar(err);
    });
  }

  void gruposObserver(eventoId) async {
    var query = """
      subscription MySubscription(\$eventoId: Int) {
        grupo_questoes(where: {evento_id: {_eq: \$eventoId}, votando: {_eq: true}}) {
          id
          nome
          votando
          questoes
        }
      }
    """;
    snapshotGruposObserver = await hasuraConnect
        .subscription(query, variables: {"eventoId": eventoId});

    snapshotGruposObserver?.listen((data) {
      var dados = data['data'];
      
      if(dados['grupo_questoes'].length > 0)
        grupo.value = GrupoQuestoes.fromJson(dados['grupo_questoes'][0]);
      
    }).onError((err) {
      printar(err);
    });
  }

  void questoesObserver(eventoId) async {
    var query = """
      subscription MySubscription (\$evento_id: Int){
        questoes(where: {votando: {_eq: true}, evento_id: {_eq: \$evento_id}}, order_by: {id: asc}) {
          evento_id
          id
          descricao
          votando
          user {
            id
            nome
          }
        }
      }

    """;
    snapshotQuestoesObserver = await hasuraConnect.subscription(query, variables: {"evento_id": eventoId});

    snapshotQuestoesObserver?.listen((data) {
      var dados = data['data'];

      List<Questao>? lista = Questao.fromJsonList(dados['questoes']);
      questoes.value = lista ?? [];
    }).onError((err) {
      printar(err);
    });
  }

  Future getCandidatos(eventoId) async {
    try {
      spinner.value = true;
      List<Candidato>? r = await provider.getCandidatos(eventoId);
      spinner.value = false;

      if (r != null) {
        candidatos.value = r;
      }
    } catch (e) {
      alerta(title: "Atenção", description: e.toString());
    }
  }

  Future getQuestoes(eventoId) async {
    try {
      List<Questao>? r = await provider.getQuestoes(eventoId);
      if (r != null) {
        questoes.value = r;
      }
    } catch (e) {
      alerta(title: "Atenção", description: e.toString());
    }
  }

  Future getJurados(eventoId) async {
    try {
      List<User>? r = await provider.getJurados(eventoId);
      if (r != null) {
        r.forEach((item) {
          // if (item.id == logado.id) {
          //   souJurado = true;
          // }
        });
        jurados.value = r;
        votosJuradosSubscrition(eventoId);
      }
    } catch (e) {
      alerta(title: "Atenção", description: e.toString());
    }
  }

  Future mostrarCandidato(candidatoId, status) async {
    try {
      spinner.value = true;
      await provider.mostrarCandidato(candidatoId, status);
      spinner.value = false;
    } catch (e) {
      spinner.value = false;
      alerta(title: "Atenção", description: e.toString());
    }
  }

  Future mudarStatus(candidatoId, questaoId, status, statusQuestao) async {
    try {
      spinner.value = true;
      await provider.mudarStatus(candidatoId, questaoId, status, statusQuestao);
      spinner.value = false;
    } catch (e) {
      spinner.value = false;
      alerta(title: "Atenção", description: e.toString());
    }
  }

  Future votar(eventoId, candidatoId, questaoId, nota) async {
    try {
      if (spinner.value) return;

      spinner.value = true;
      //await provider.votar(eventoId, candidatoId, questaoId, nota, souJurado);
      spinner.value = false;
    } catch (e) {
      spinner.value = false;
      alerta(title: "Atenção", description: e.toString());
    }
  }

  Future encerrar(eventoId) async {
    try {
      spinner.value = true;
      await provider.encerrar(eventoId);
      spinner.value = false;
    } catch (e) {
      spinner.value = false;
      alerta(title: "Atenção", description: e.toString());
    }
  }

  Future resultadoPorCategoria(eventoId)async{
    try {
      var r = await provider.resultadoPorCategoria(eventoId);

      resultadoDasCategorias.value = r;
      printar(r);
    } catch (e) {
      spinner.value = false;
      printar(e.toString());
      alerta(title: "Atenção", description: e.toString());
    }
  }
}
