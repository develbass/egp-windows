import 'package:app_windows/app/shared/http_custom.dart';
import 'package:get/get.dart';

import '../../../models/evento_model.dart';
import '../../../shared/constants.dart';

class HomeProvider extends RestClient {
  @override
  void onInit() {
  }

  Future<Evento> getEvento(eventoId) async {
    var response = await post("${URL_API}/eventos/painel",{"evento_id": eventoId},);
      
    return Evento.fromJson(requestFiltro(response));
  }
}
