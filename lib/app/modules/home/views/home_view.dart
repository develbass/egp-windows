import 'package:app_windows/app/routes/app_pages.dart';
import 'package:app_windows/app/shared/constants.dart';
import 'package:app_windows/app/shared/widgets/botao_padrao.dart';
import 'package:app_windows/app/shared/widgets/hex_color.dart';
import 'package:app_windows/app/shared/widgets/input_tradicional.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../models/evento_model.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    tamanhaDaTela = MediaQuery.of(context).size;
    TextEditingController _codigoController = TextEditingController(text: "");

    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage('assets/background.jpg'),
      )),
      child: Container(
        height: tamanhaDaTela.height,
        child: SingleChildScrollView(
          child: Container(
            height: tamanhaDaTela.height,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    child: Logo,
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    width: 400,
                    child: Column(
                      children: [
                        InputTradicional(
                          controller: _codigoController,
                          label: "Código do Evento",
                          labelStyle: TextStyle(color: primaryColor),
                          cor: HexColor("#e5f7ff"),
                          borderColor: primaryColor,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        BotaoPadrao(
                          backgroundColor: primaryColor,
                          radius: 5,
                          onTap: () async {
                            Evento? e = await controller.getEvento(_codigoController.text);
                            if(e != null){
                              Get.toNamed(Routes.EVENTO, arguments: e);
                            }
                            await Future.delayed(Duration(seconds: 1));
                          },
                          text: "ENTRAR",
                        )
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ),
    ));
  }
}
