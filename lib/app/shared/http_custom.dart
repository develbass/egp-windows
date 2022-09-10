import 'package:app_windows/app/shared/constants.dart';
import 'package:get/get_connect/connect.dart';

class RestClient extends GetConnect  {
  RestClient() {
    timeout = const Duration(seconds: 60);
    maxAuthRetries = 3;
  }
}