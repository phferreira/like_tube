import 'package:dio/io.dart';

class CustomDio extends DioForNative {
  CustomDio() {
    options.baseUrl = 'https://www.googleapis.com/youtube/v3';
    options.connectTimeout = const Duration(milliseconds: 30000);
    options.receiveTimeout = const Duration(milliseconds: 30000);
  }
}
