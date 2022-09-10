
import 'package:app_windows/app/shared/constants.dart';
import 'package:hasura_connect/hasura_connect.dart';

HasuraConnect hasuraConnect = HasuraConnect(URL_HASURA, 
  headers: {
    "content-type": "application/json",
    "x-hasura-admin-secret": "xdIcvwTyzz5BU9l2bf8G0UnZ5r7pErQNLWuECm9yszBC1w1vkL0zMpjQ3WVBUs5m"
  });