
import 'package:app_windows/app/shared/widgets/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "dart:developer" as developer;


bool DEBUUG = false;
String URL_API = DEBUUG ? "http://192.168.28.125:5000" : "https://painel-votacao.herokuapp.com";
String URL_HASURA = "https://discrete-condor-59.hasura.app/v1/graphql";
late Size tamanhaDaTela;
Widget Logo = Image.asset("assets/logomarca.png", scale: 0.8,);


Color primaryColor = HexColor("#0A4373");

dynamic requestFiltro(Response response){
  if(response.hasError){
    throw response.statusText ?? "";
  }

  if(response.body['response']){
    var r = response.body['dados'];
    printar(r);
    return r;
  }else{
    throw response.body['mensagem'];
  }
}

printar(
  message, {
  DateTime? time,
  int? sequenceNumber,
  int level = 0,
  String name = '',
  Object? error,
  StackTrace? stackTrace,
}) {
  developer.log(
    message is String ? message : message.toString(),
    time: time,
    sequenceNumber: sequenceNumber,
    level: level,
    name: name,
    error: error,
    //stackTrace: stackTrace,
  );
}

alerta({title, description}){
  return Get.defaultDialog(
    title: title,
    content: Text(description, textAlign: TextAlign.center,),
    onConfirm: () => Get.back(),
    confirmTextColor: Colors.white,
    titleStyle: TextStyle(fontSize: 22),
    radius: 5
  );
}

class StatusVotacao{
  static String VISUALIZAR = "VISUALIZAR";
  static String JURADOS = "JURADOS";
  static String PUBLICO = "PUBLICO";
  static String PAUSADO = "PAUSADO";
  static String ENCERRADO = "ENCERRADO";
}

confirmDialog(BuildContext context,
    {title, message, confirmLabel, cancelLabel, onConfirm}) {
  Widget cancelButton = TextButton(
    child: Text(cancelLabel ?? "Não"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget launchButton = TextButton(
    child: Text(confirmLabel ?? "Sim"),
    onPressed: () {
      onConfirm();
      //Navigator.pop(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title ?? ""),
    content: Text(message ?? ""),
    actions: [
      cancelButton,
      launchButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}