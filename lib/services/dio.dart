import 'package:dio/dio.dart';

Dio configureDio() {
  final dio = Dio();
  dio.options.baseUrl = 'http://192.168.1.3:8000/api';
  dio.options.headers['accept'] = 'Application/Json';
  dio.interceptors.add(LogInterceptor(responseBody: true));
  return dio;
}

final dio = configureDio();
