import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../Model/LoginModel.dart';
class Userapi {

  static Future<LoginModel?> PostLogin(String mail, String password) async {
    try {
      Map<String, String> data = {

        "email": mail,
        "password": password,

      };
      final url = Uri.parse("http://192.168.0.56:5000/auth/login");
      final response = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode(data),
      );
      if (response!=null) {
        final jsonResponse = jsonDecode(response.body);
        print("PostRegister Status:${response.body}");
        return LoginModel.fromJson(jsonResponse);
      } else {
        print("Request failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }

}
