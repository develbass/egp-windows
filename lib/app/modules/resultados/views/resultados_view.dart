import 'package:app_windows/app/shared/constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/resultados_controller.dart';

class ResultadosView extends GetView<ResultadosController> {
  @override
  Widget build(BuildContext context) {
    tamanhaDaTela = MediaQuery.of(context).size;

    mediaWidget() {
      return Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Text(
              'Beleza',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "9,0",
              style: TextStyle(
                fontSize: 23,
              ),
            ),
            Text(
              'Nome Jurado',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      );
    }

    linha() {
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
                    "1 - ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Nome",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                mediaWidget(),
                mediaWidget(),
                mediaWidget(),
                mediaWidget(),
                mediaWidget(),
                mediaWidget(),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: tamanhaDaTela.width,
        height: tamanhaDaTela.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child:
                    IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: (tamanhaDaTela.width / 2) - 30,
                      child: Column(
                        children: [
                          linha(),
                          linha(),
                          linha(),
                          linha(),
                          linha(),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: (tamanhaDaTela.width / 2) - 30,
                      child: Column(
                        children: [
                          linha(),
                          linha(),
                          linha(),
                          linha(),
                          linha(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
