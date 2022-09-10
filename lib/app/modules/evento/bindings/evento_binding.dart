import 'package:get/get.dart';

import '../controllers/evento_controller.dart';

class EventoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventoController>(
      () => EventoController(),
    );
  }
}
