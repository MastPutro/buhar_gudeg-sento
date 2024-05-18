import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dio.dart';

class Auth extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool get authenticated => _isLoggedIn;
  late String token;

  Future<void> login({required Map creds}) async {
    print(creds);

    try {
      final response = await dio.post(
        '/sanctum/token',
        data: creds,
        options: Options(method: 'POST'),
      );

      print(response.data.toString());
      token = response.data;

      _isLoggedIn = true;
      notifyListeners();
    } catch (e) {
      if (e is DioError) {
        print("Login failed: ${e.message}");
        print("DioError type: ${e.type}");
        if (e.response != null) {
          print("DioError response data: ${e.response?.data}");
          print("DioError response status: ${e.response?.statusCode}");
        } else {
          print("No response received");
        }
      } else {
        print("Login failed with non-Dio error: $e");
      }
    }
  }

  Future<void> logout() async {
    var headers = {
      'Authorization': 'Bearer ${token}'
    };
    var request = http.Request('GET', Uri.parse('http://192.168.1.3:8000/api/user/revoke'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      _isLoggedIn = false;
      notifyListeners();
      print(await response.stream.bytesToString());
    }
    else {
    print(response.reasonPhrase);
    }

  }
}


