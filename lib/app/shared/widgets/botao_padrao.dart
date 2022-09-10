import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';

import '../constants.dart';
import 'botao_custom.dart';

///
/// onTap deve ser sempre async
///
class BotaoPadrao extends StatefulWidget {
  final AsyncCallback onTap;
  final String? text;
  final Widget? icon;
  final Color? textColor;
  final Color? backgroundColor;
  final double? radius;
  final double? iconSpaceLeft;
  final bool progress;
  final Color? borderColor;
  final double? heigth;

  const BotaoPadrao({
    Key? key,
    required this.onTap,
    this.text,
    this.textColor = Colors.white,
    this.backgroundColor,
    this.radius,
    this.icon,
    this.iconSpaceLeft,
    this.progress = true,
    this.borderColor,
    this.heigth = 60,
  }) : super(key: key);

  @override
  State<BotaoPadrao> createState() => _BotaoPadraoState();
}

class _BotaoPadraoState extends State<BotaoPadrao> {
  @override
  Widget build(BuildContext context) {
    Widget texto = Text(
      widget.text ?? "",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: widget.textColor,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    );

    Widget espaco = SizedBox(
      width: 0,
    );

    Widget conteudo(w) {
      Widget saida = Container();

      if (tamanhaDaTela.width > 400 && tamanhaDaTela.width < 576) {
        espaco = SizedBox(
          width: 30,
        );
      }


      if (widget.icon != null) {
        saida = BootstrapContainer(
          children: [
            BootstrapRow(
                decoration: BoxDecoration(color: Colors.transparent),
                children: [
                  BootstrapCol(
                    sizes: "col-sm-2 col-md-4",
                    child: Container(),
                  ),
                  BootstrapCol(
                    sizes: "col-10",
                    child: Container(
                      height: widget.heigth,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          espaco,
                          Container(
                            child: widget.icon,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          texto
                        ],
                      ),
                    ),
                  ),
                ])
          ],
        );
      } else {
        saida = Container(
          child: Center(
            child: texto,
          ),
        );
      }
      return saida;
    }

    return LayoutBuilder(
      builder: (c, constraints) {
        return BotaoCustom(
          progress: widget.progress,
          onTap: widget.onTap,
          borderColor: widget.borderColor,
          child: conteudo(constraints.maxWidth),
          // child: Row(
          //   mainAxisAlignment: widget.icon != null
          //           ? MainAxisAlignment.start
          //           : MainAxisAlignment.center,
          //   children: [
          //     espaco,
          //     Container(
          //       child: Row(
          //         children: [
          //           icone,
          //           SizedBox(
          //             width: 10,
          //           ),
          //           Text(
          //             widget.text ?? "",
          //             textAlign: TextAlign.center,
          //             style: TextStyle(
          //               color: widget.textColor,
          //               fontSize: 17,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           )
          //         ],
          //       ),
          //     )
          //   ],
          // ),
          backgroundColor: widget.backgroundColor ?? Colors.white,
          radius: widget.radius ?? 25,
          width: tamanhaDaTela.width,
          heigth: widget.heigth,
        );
      },
    );
  }
}
