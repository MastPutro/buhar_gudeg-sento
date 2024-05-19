import 'package:dio/dio.dart';

Dio configureDio() {
  final dio = Dio();
  dio.options.baseUrl = 'https://depotbuhar.com/api';
  dio.options.headers['accept'] = 'Application/Json';
  dio.interceptors.add(LogInterceptor(responseBody: true));
  return dio;
}

final dio = configureDio();
