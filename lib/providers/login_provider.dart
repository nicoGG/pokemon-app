import 'package:dio/dio.dart';

class LoginProvider {
  final Dio _dio = Dio();
  final String loginUrl = 'http://localhost:3000/api/auth/login';

  Future<String> login(String username, String password) async {
    try {
      final response = await _dio.post(loginUrl, data: {
        'username': username,
        'password': password,
      });

      return response.data['token'];
    } catch (e) {
      throw Exception("Error en el login: ${e.toString()}");
    }
  }
}
