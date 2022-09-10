import 'package:app_windows/app/models/evento_model.dart';
import 'package:app_windows/app/modules/evento/providers/evento_provider.dart';
import 'package:app_windows/app/modules/home/providers/home_provider.dart';
import 'package:get/get.dart';

import '../../../shared/constants.dart';

class HomeController extends GetxController {
  final Rx<bool> spinner = Rx<bool>(false);
  HomeProvider provider = HomeProvider();

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  
  
  Future<Evento?> getEvento(codigo)async{
    try {
      spinner.value = true;
      Evento evento =  await provider.getEvento(codigo);
      spinner.value = false;

      return evento;
    } catch (e) {
      spinner.value = false;
      alerta(title: "Atenção", description: e.toString());
      return null;
    }
  }
}
