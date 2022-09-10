import 'package:get/get.dart';

import '../controllers/resultados_controller.dart';

class ResultadosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResultadosController>(
      () => ResultadosController(),
    );
  }
}
