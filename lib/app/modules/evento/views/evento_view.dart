import 'package:app_windows/app/models/candidato_model.dart';
import 'package:app_windows/app/models/evento_model.dart';
import 'package:app_windows/app/shared/constants.dart';
import 'package:app_windows/app/shared/modal_ganhe_premios.dart';
import 'package:app_windows/app/shared/widgets/botao_padrao.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:infinite_carousel/infinite_carousel.dart';

import '../../../models/questao_model.dart';
import '../../../models/voto_model.dart';
import '../controllers/evento_controller.dart';

class EventoView extends GetView<EventoController> {
  Evento evento = Get.arguments;
  late InfiniteScrollController _controller;
  int _selectedIndex = 0;
  bool modalVotacaoAberto = false;
  bool modalResultadoAberto = false;

  void iniciar() async {
    _controller = InfiniteScrollController(initialItem: _selectedIndex);
    controller.count = 0;
    controller.candidatosObserver.value.clear();
    controller.candidatos.value.clear();
    //controller.getCandidatos(evento.id);
    controller.statusCandidatos(evento.id);
    //controller.statusQuestoes(evento.id);
    controller.questoesObserver(evento.id);
    controller.getJurados(evento.id);
    controller.votosSubscrition(evento.id);
    controller.gruposObserver(evento.id);
    //controller.votosObserver(evento.id);
  }

  EventoView() {
    iniciar();
  }

  @override
  Widget build(BuildContext context) {
    Widget spinnerWidget() {
      return Obx(() {
        if (controller.spinner.value == false) return Container();

        return Positioned(
          top: tamanhaDaTela.height / 2 - 30,
          left: tamanhaDaTela.width / 2 - 30,
          child: Container(
            width: 60,
            height: 60,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(50)),
            child: CircularProgressIndicator(),
          ),
        );
      });
    }

    Widget btnPainelVotacao({text, onTap, color}) {
      return InkWell(
        onTap: onTap,
        child: Container(
          width: 70,
          height: 30,
          color: color,
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ),
      );
    }

    painelDeControle(Candidato escolhido) {
      return ModalGanhePremios().emBranco(
        context,
        child: Obx(() {
          List<Widget> questoesWidget = [];
          Candidato candidato = controller.candidatosObserver.value
              .firstWhere((item) => item.id == escolhido.id);

          controller.questoes.value.forEach((item) {
            questoesWidget.add(Container(
              padding: EdgeInsets.all(10),
              width: tamanhaDaTela.width,
              margin: EdgeInsets.only(bottom: 1),
              color: Colors.grey.shade200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.descricao ?? "",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: tamanhaDaTela.width,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        btnPainelVotacao(
                          color: item.votando != null
                              ? Colors.grey.shade600
                              : Colors.pink,
                          text: item.votando != null ? "Ocultar" : "Mostrar",
                          onTap: () {
                            confirmDialog(
                              context,
                              title: "Atenção",
                              message:
                                  "Escolha SIM para ${item.votando != null ? 'ocultar' : 'mostrar'} ${candidato.nome} em ${item.descricao} para o público.",
                              onConfirm: () {
                                controller.mudarStatus(
                                    candidato.id,
                                    item.id,
                                    StatusVotacao.VISUALIZAR,
                                    item.votando != null ? null : false);
                                Get.back();
                              },
                            );
                          },
                        ),
                        btnPainelVotacao(
                          color: item.votando == true &&
                                  candidato.statusVotacao ==
                                      StatusVotacao.JURADOS
                              ? Colors.grey.shade600
                              : Colors.orange,
                          text: "Jurados",
                          onTap: () {
                            if (item.votando == true &&
                                candidato.statusVotacao ==
                                    StatusVotacao.JURADOS) return;

                            confirmDialog(
                              context,
                              title: "Atenção",
                              message:
                                  "Escolha SIM para abrir votação para os jurados.",
                              onConfirm: () {
                                controller.mudarStatus(
                                  candidato.id,
                                  item.id,
                                  StatusVotacao.JURADOS,
                                  true,
                                );
                                Get.back();
                              },
                            );
                          },
                        ),
                        btnPainelVotacao(
                          color: item.votando == true &&
                                  candidato.statusVotacao ==
                                      StatusVotacao.PUBLICO
                              ? Colors.grey.shade600
                              : Colors.green,
                          text: "Público",
                          onTap: () {
                            if (item.votando == true &&
                                candidato.statusVotacao ==
                                    StatusVotacao.PUBLICO) return;

                            confirmDialog(
                              context,
                              title: "Atenção",
                              message:
                                  "Escolha SIM para abrir votação para o público.",
                              onConfirm: () {
                                controller.mudarStatus(
                                  candidato.id,
                                  item.id,
                                  StatusVotacao.PUBLICO,
                                  true,
                                );
                                Get.back();
                              },
                            );
                          },
                        ),
                        btnPainelVotacao(
                          color: item.votando == false &&
                                  candidato.statusVotacao ==
                                      StatusVotacao.PAUSADO
                              ? Colors.grey.shade600
                              : Colors.purple,
                          text: "Pausar",
                          onTap: () {
                            if (item.votando == false &&
                                candidato.statusVotacao ==
                                    StatusVotacao.PAUSADO) return;

                            confirmDialog(
                              context,
                              title: "Atenção",
                              message: "Escolha SIM para pausar a votação.",
                              onConfirm: () {
                                controller.mudarStatus(
                                  candidato.id,
                                  item.id,
                                  StatusVotacao.PAUSADO,
                                  false,
                                );
                                Get.back();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
          });

          return SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.arrow_back)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(candidato.foto ?? ""),
                                  fit: BoxFit.cover)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(candidato.nome ?? ""),
                        btnPainelVotacao(
                          color: candidato.statusVotacao ==
                                  StatusVotacao.VISUALIZAR
                              ? Colors.grey.shade500
                              : Colors.pink,
                          text: candidato.statusVotacao ==
                                  StatusVotacao.VISUALIZAR
                              ? "Ocultar"
                              : "Mostrar",
                          onTap: () {
                            confirmDialog(
                              context,
                              title: "Atenção",
                              message: candidato.statusVotacao ==
                                      StatusVotacao.VISUALIZAR
                                  ? "Escolha SIM para ocultar ${candidato.nome} para o público."
                                  : "Escolha SIM para mostrar ${candidato.nome} para o público.",
                              onConfirm: () {
                                controller.mostrarCandidato(
                                    candidato.id,
                                    candidato.statusVotacao ==
                                            StatusVotacao.VISUALIZAR
                                        ? null
                                        : StatusVotacao.VISUALIZAR);
                                Get.back();
                              },
                            );
                          },
                        ),
                        const Divider(),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Questões",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: questoesWidget,
                    )
                  ],
                ),
                spinnerWidget()
              ],
            ),
          );
        }),
      );
    }

    painelNota() {
      //if (!controller.souJurado) return Container();

      Widget itens = Container();

      if (controller.questaoVotar.value.id != null &&
          controller.questaoVotar.value.tipo == 'NOTAS') {
        List<Widget> listaItem = [];

        Voto? votado;

        controller.votos.value.forEach((v) {
          if (v.questaoId == controller.questaoVotar.value.id &&
              v.candidatoId == controller.candidatoEmVotacao.value.id) {
            votado = v;
          }
        });

        for (var i = 0; i < controller.questaoVotar.value.notaMaxima!; i++) {
          String nota = "${i + 1 < 10 ? '0${i + 1}' : i + 1}";

          listaItem.add(InkWell(
            onTap: () {
              if (votado != null) {
                return;
              }
              if (controller.souJurado &&
                  controller.candidatoEmVotacao.value.statusVotacao ==
                      StatusVotacao.PUBLICO) {
                alerta(
                    title: "Atenção",
                    description: "Você não pode votar no momento.");
                return;
              }

              if (!controller.souJurado &&
                  controller.candidatoEmVotacao.value.statusVotacao ==
                      StatusVotacao.JURADOS) {
                alerta(
                    title: "Atenção",
                    description: "Você não pode votar no momento.");
                return;
              }

              if (controller.questaoVotar.value.votando == true) {
                if (controller.spinner.value) return;

                confirmDialog(context,
                    title: "Atenção",
                    message:
                        "Deseja confirmar a nota ${nota.toString()} para ${controller.questaoVotar.value.descricao}?",
                    onConfirm: () {
                  controller.votar(
                      evento.id,
                      controller.candidatoEmVotacao.value.id,
                      controller.questaoVotar.value.id,
                      nota);
                  Get.back();
                });
              }
            },
            child: Container(
              width: tamanhaDaTela.width / 6,
              height: 40,
              decoration: BoxDecoration(
                  color: votado?.nota == int.parse(nota)
                      ? Colors.green.shade300
                      : Colors.white,
                  borderRadius: BorderRadius.circular(5)),
              child: Center(child: Text(nota)),
            ),
          ));
        }

        itens = Wrap(
          spacing: 2,
          runSpacing: 2,
          children: listaItem,
        );
      }

      if (controller.questaoVotar.value.id == null) {
        return Container();
      }

      return Container(
        margin: EdgeInsets.only(top: 20, bottom: 30),
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(
              "Dê sua nota",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Divider(),
            itens
          ],
        ),
      );
    }

    painelJurados() {
      //if (controller.questaoVotar.value.id == null) return Container();

      List<Widget> lista = [];

      controller.jurados.value.forEach((item) {
        int? nota;
        Widget mostrarNota = Container();

        item.votos?.forEach((v) {
          if (v.questaoId == controller.questaoVotar.value.id &&
              v.candidatoId == controller.candidatoEmVotacao.value.id) {
            nota = v.nota;
          }
        });

        lista.add(Container(
          margin: EdgeInsets.only(bottom: 5, left: 5, right: 5),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.nome ?? ""),
              Text(
                nota != null ? nota.toString().padLeft(2, '0') : '-',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ));

        // lista.add(ListTile(
        //   title: Text(item.nome ?? ""),
        //   trailing: Text(nota != null ? nota.toString().padLeft(2, '0') : '-'),
        // ));
      });

      // return Container(
      //   width: tamanhaDaTela.width * 0.4,
      //   height: 200,

      //   decoration: BoxDecoration(
      //     color: Colors.grey.shade200,
      //     borderRadius: BorderRadius.circular(10),
      //   ),
      //   child: Column(
      //     children: [
      //       SizedBox(height: 20,),
      //       Text(
      //         "Jurados",
      //         style: TextStyle(fontWeight: FontWeight.bold),
      //       ),
      //       Divider(),
      //       Column(
      //         children: lista,
      //       ),
      //     ],
      //   ),
      // );

      return Container(
        width: tamanhaDaTela.width * 0.4,
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            const Text(
              "Jurados",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Column(children: lista)
          ],
        ),
      );
    }

    modalResultados() {
      modalResultadoAberto = true;

      mediaWidget(dados) {
        return Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Text(
                dados['categoria'],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                dados['media'] != null ? dados['media'].toString() : "",
                style: TextStyle(
                  fontSize: 23,
                ),
              ),
              Text(
                dados['nome'].toString().split(" ")[0],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        );
      }

      linha(colocao, obj) {
        Candidato candidato = controller.candidatosObserver.value
            .firstWhere((o) => o.id == obj['candidato_id']);
        dynamic jurados = obj['jurados'];
        List<Widget> mediaList = [];

        jurados.forEach((j) {
          mediaList.add(mediaWidget(j));
        });

        Map<String, dynamic> trajetoria = {
          "categoria": "Trajetoria",
          "media": obj['trajetoria'],
          "nome": ""
        };

        mediaList.add(mediaWidget(trajetoria));

        Map<String, dynamic> nota = {
          "categoria": "Nota",
          "media": obj['media'],
          "nome": ""
        };

        mediaList.add(mediaWidget(nota));

        return Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Text(
                      "${colocao} - ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      candidato.nome ?? "",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: mediaList,
              ),
            ],
          ),
        );
      }

      ModalGanhePremios().emBranco(
        context,
        child: SingleChildScrollView(
          child: Obx(
            () {
              List<Widget> coluna1 = [];
              List<Widget> coluna2 = [];
              var i = 1;

              controller.resultadoDasCategorias.value?.forEach((item) {
                if (i <= 5) {
                  coluna1.add(linha(i, item));
                } else {
                  coluna2.add(linha(i, item));
                }

                i++;
              });

              return Container(
                width: tamanhaDaTela.width,
                height: tamanhaDaTela.height,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(Icons.arrow_back)),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              width: (tamanhaDaTela.width / 2) - 30,
                              child: Column(
                                children: coluna1,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: (tamanhaDaTela.width / 2) - 30,
                              child: Column(
                                children: coluna2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    abrirResultado() async {
      if (modalVotacaoAberto) {
        Get.back();
        modalVotacaoAberto = false;
      }

      if (controller.eventoEncerrado.value && !modalResultadoAberto) {
        await Future.delayed(Duration(milliseconds: 500));
        modalResultados();
      }
    }

    modalVotacao() async {
      await Future.delayed(Duration(microseconds: 500));
      modalVotacaoAberto = true;

      ModalGanhePremios().emBranco(
        context,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Obx(() {
                Candidato candidato = controller.candidatoEmVotacao.value;

                if (controller.eventoEncerrado.value &&
                    modalVotacaoAberto == true) {
                  abrirResultado();
                  return Container();
                }

                if (candidato.statusVotacao == null &&
                    modalVotacaoAberto == true) {
                  Get.back();
                  modalVotacaoAberto = false;
                  return Container();
                }

                Widget titulo = Text(
                  "...",
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.grey.shade500,
                  ),
                );

                if (controller.questaoVotar.value.id != null) {
                  titulo = Text(
                    controller.questaoVotar.value.descricao ?? "",
                    style: TextStyle(
                      fontSize: 50,
                      color: primaryColor,
                    ),
                  );
                }

                double tamanho = tamanhaDaTela.width * 0.35;

                Widget fotoWidget = Container(
                  width: tamanho,
                  height: tamanho,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      image: DecorationImage(
                        image: NetworkImage(candidato.foto ?? ''),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            )),
                        child: Center(
                          child: Text(
                            candidato.nome ?? "",
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                        ),
                      ),
                    ],
                  ),
                );

                Widget btnStatusWidget = Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: controller.questaoVotar.value.id != null &&
                              controller.questaoVotar.value.votando == true
                          ? Colors.green
                          : Colors.orange.shade500,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    controller.questaoVotar != null &&
                            controller.questaoVotar.value.votando == true
                        ? "VOTAÇÃO ABERTA PARA ${candidato.statusVotacao == StatusVotacao.JURADOS ? 'OS JURADOS' : 'O PÚBLICO'}"
                        : "AGUARDANDO INICIO DA VOTAÇÃO",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
                );

                return Container(
                  width: tamanhaDaTela.width,
                  height: tamanhaDaTela.height,
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 30),
                        titulo,
                        SizedBox(height: 30),
                        Row(
                          children: [
                            fotoWidget,
                            SizedBox(
                              width: 30,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                btnStatusWidget,
                                //painelNota(),
                                SizedBox(
                                  height: 20,
                                ),
                                painelJurados()
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            spinnerWidget()
          ],
        ),
      );
    }

    modalVotacaoGrupo() async {
      await Future.delayed(Duration(microseconds: 500));
      modalVotacaoAberto = true;

      ModalGanhePremios().emBranco(
        context,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Obx(() {
                Candidato candidato = controller.candidatoEmVotacao.value;
                List<Widget> questoesWidget = [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("Fechar"),
                  )
                ];

                if (controller.eventoEncerrado.value &&
                    modalVotacaoAberto == true) {
                  abrirResultado();
                  return Container();
                }

                if (candidato.statusVotacao == null &&
                    modalVotacaoAberto == true) {
                  Get.back();
                  modalVotacaoAberto = false;
                  return Container();
                }

                Widget titulo = Text(
                  "...",
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.grey.shade500,
                  ),
                );

                if (controller.questaoVotar.value.id != null) {
                  titulo = Text(
                    controller.questaoVotar.value.descricao ?? "",
                    style: TextStyle(
                      fontSize: 50,
                      color: primaryColor,
                    ),
                  );
                }

                Widget fotoWidget = Container(
                  width: tamanhaDaTela.width * 0.4,
                  height: tamanhaDaTela.height,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    image: DecorationImage(
                      image: NetworkImage(candidato.foto ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: primaryColor,
                        ),
                        child: Center(
                          child: Text(
                            candidato.nome ?? "",
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                        ),
                      ),
                    ],
                  ),
                );

                Widget btnStatusWidget = Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: controller.questaoVotar.value.id != null &&
                              controller.questaoVotar.value.votando == true
                          ? Colors.green
                          : Colors.orange.shade500,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    controller.questaoVotar != null &&
                            controller.questaoVotar.value.votando == true
                        ? "VOTAÇÃO ABERTA PARA ${candidato.statusVotacao == StatusVotacao.JURADOS ? 'OS JURADOS' : 'O PÚBLICO'}"
                        : "AGUARDANDO INICIO DA VOTAÇÃO",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
                );

                controller.questoes.value.forEach((item) {
                  Widget jurado = Container();

                  if (item.user != null) {
                    jurado = Text("Jurado(a): ${item.user?.nome}",
                        style: TextStyle(fontSize: 18));
                  }

                  double calc = 0;

                  controller.votos.value.forEach((element) {
                    if (element.candidatoId ==
                        controller.candidatoEmVotacao.value.id) {
                      if (item.user != null) {
                        if (element.questaoId == item.id) {
                          calc += element.nota != null ? element.nota! : 0;
                        }
                      } else {
                        if (element.questaoId == item.id) {
                          calc += element.nota != null ? element.nota! : 0;
                          calc = calc / controller.jurados.value.length;
                        }
                      }
                    }
                  });

                  Widget nota = Text(calc.toStringAsFixed(2).padLeft(2, "0"),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold));

                  questoesWidget.add(Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.only(bottom: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.descricao ?? "",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                            jurado
                          ],
                        ),
                        Column(
                          children: [
                            Text("Nota",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            nota
                          ],
                        )
                      ],
                    ),
                  ));
                });

                return Container(
                  width: tamanhaDaTela.width,
                  height: tamanhaDaTela.height,
                  child: SingleChildScrollView(
                    child: Row(
                      children: [
                        fotoWidget,
                        Container(
                          height: tamanhaDaTela.height,
                          width: tamanhaDaTela.width * 0.6,
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: questoesWidget,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            spinnerWidget()
          ],
        ),
      );
    }

    Widget candidatoWidget(Candidato candidato) {
      Widget notaWidget = Container();

      if (candidato.nota != null && candidato.nota! > 0) {
        notaWidget = Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: EdgeInsets.all(5),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.black26, borderRadius: BorderRadius.circular(50)),
            child: Center(
              child: Text(
                candidato.nota == null ? "" : candidato.nota.toString(),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      }

      return InkWell(
        onTap: () {
          // if (logado.roles != null && logado.roles!.contains('admin')) {
          //   painelDeControle(candidato);
          // }else{
          //   if(controller.candidatoEmVotacao.value.id == candidato.id)
          //     modalVotacao();
          // }
        },
        child: Container(
          width:
              (tamanhaDaTela.width / (tamanhaDaTela.width > 700 ? 4 : 2)) - 5,
          height: 200,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(candidato.foto ?? ""), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              notaWidget,
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: candidato.statusVotacao != null &&
                          candidato.statusVotacao != StatusVotacao.ENCERRADO
                      ? Colors.green.withOpacity(0.8)
                      : Colors.black45,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                        10,
                      ),
                      bottomRight: Radius.circular(
                        10,
                      )),
                ),
                child: Center(
                    child: Text(
                  candidato.nome ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 17),
                )),
              )
            ],
          ),
        ),
      );
    }

    Widget botaoStatusVotacao(
        {onTap, String? text, required Color color, Color? colorFont}) {
      return InkWell(
        onTap: onTap,
        child: Container(
          height: 50,
          width: tamanhaDaTela.width,
          color: color,
          child: Center(
            child: Text(
              text ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: colorFont ?? Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    Widget botaoEncerrar(eventoEncerrado) {
      // if (logado.roles == null || !logado.roles!.contains('admin')) {
      //   return Container();
      // }

      if (eventoEncerrado) {
        return Container();
      }

      return Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        width: tamanhaDaTela.width > 700 ? 300 : double.infinity,
        child: BotaoPadrao(
          onTap: () async {
            confirmDialog(
              context,
              title: "Atenção",
              message:
                  "Escolha SIM para encerrar a votação para o evento ${evento.nome}",
              onConfirm: () {
                controller.encerrar(evento.id);
                Get.back();
              },
            );
            await Future.delayed(Duration(seconds: 1));
          },
          text: "ENCERRAR",
          backgroundColor: Colors.red,
        ),
      );
    }

    return Scaffold(
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Container(
            height: tamanhaDaTela.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/background.jpg'),
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  (() {
                    if (controller.eventoEncerrado.value) {
                      return Container();
                    }

                    if (controller.eventoEncerrado.value &&
                        !modalResultadoAberto) {
                      abrirResultado();
                      return Container();
                    }

                    if (controller.candidatoEmVotacao.value.statusVotacao !=
                            null &&
                        controller.candidatoEmVotacao.value.statusVotacao !=
                            StatusVotacao.ENCERRADO &&
                        modalVotacaoAberto == false) {
                      if (modalResultadoAberto) {
                        Get.back();
                      }
                      modalVotacaoGrupo();
                      return Container();
                    }

                    return Container();
                  }),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.close))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Obx(
                  () {
                    List<Widget> lista = [];

                    controller.candidatosObserver.value.forEach((item) {
                      lista.add(Container(
                        width: tamanhaDaTela.width / 3,
                        height: 200,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            image: DecorationImage(
                              image: NetworkImage(item.foto ?? ""),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(width: 1, color: primaryColor)),
                      ));
                    });

                    return CarouselSlider(
                      options: CarouselOptions(
                        height: 400,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.4,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: false,
                      ),
                      items: lista,
                    );

                    // return Center(
                    //   child: Wrap(
                    //     spacing: 5,
                    //     runSpacing: 5,
                    //     children: lista,
                    //   ),
                    // );
                  },
                ),
                SizedBox(
                  height: 90,
                ),
                TextButton(
                    onPressed: () {
                      modalResultados();
                    },
                    child: Text("Modal Resultado")),
                TextButton(
                    onPressed: () {
                      modalVotacaoGrupo();
                    },
                    child: Text("Modal Candidata")),
                Container(
                  width: 200,
                  child: Image.asset('assets/logomarca.png'),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            )),
      ),
    );
  }
}
