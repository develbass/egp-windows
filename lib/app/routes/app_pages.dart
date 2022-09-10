import 'package:get/get.dart';

import '../modules/evento/bindings/evento_binding.dart';
import '../modules/evento/views/evento_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/resultados/bindings/resultados_binding.dart';
import '../modules/resultados/views/resultados_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.EVENTO,
      page: () => EventoView(),
      binding: EventoBinding(),
    ),
    GetPage(
      name: _Paths.RESULTADOS,
      page: () => ResultadosView(),
      binding: ResultadosBinding(),
    ),
  ];
}
