import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

void setupCertificate(Dio dio) {
  if (dio.httpClientAdapter is IOHttpClientAdapter) {
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }
}
