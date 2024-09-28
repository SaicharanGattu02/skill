import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:skill/Model/GetLeaveCountModel.dart';
import 'package:skill/Model/GetLeaveModel.dart';
import 'package:skill/Model/MeetingModel.dart';
import 'package:skill/Model/ProjectsModel.dart';

import '../Model/CreateRoomModel.dart';
import '../Model/EmployeeListModel.dart';
import '../Model/LoginModel.dart';
import '../Model/RegisterModel.dart';
import '../Model/TasklistModel.dart';
import 'otherservices.dart';

class Userapi {
  static String host = "http://192.168.0.56:8000";

  static Future<RegisterModel?> PostRegister(
      String name, String mail, String password) async {
    try {
      Map<String, String> data = {
        "full_name": name,
        "email": mail,
        "password": password
      };
      final url = Uri.parse("${host}/auth/register");
      final response = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode(data),
      );
      if (response != null) {
        final jsonResponse = jsonDecode(response.body);
        print("PostRegister Status:${response.body}");
        return RegisterModel.fromJson(jsonResponse);
      } else {
        print("Request failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }

  static Future<LoginModel?> PostLogin(String mail, String password) async {
    try {
      Map<String, String> data = {
        "email": mail,
        "password": password,
      };
      final url = Uri.parse("${host}/auth/login");
      final response = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode(data),
      );
      if (response != null) {
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

  static Future<EmployeeListModel?> GetEmployeeList() async {
    try {
      final headers = await getheader();
      final url = Uri.parse('${host}/chat/users');
      final res = await get(url, headers: headers);
      if (res != null) {
        print("GetEmployeeDetailsApi Response:${res.body}");
        return EmployeeListModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<ProjectsModel?> GetProjectsList() async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/project/projects/on_going");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("GetProjectsList Response:${res.body}");
        return ProjectsModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<MeetingModel?> GetMeeting() async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/meeting/meetings");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("GetMeeting Response:${res.body}");
        return MeetingModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<TasklistModel?> GetTask() async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/todo/tasks");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("GetProjectsList Response:${res.body}");
        return TasklistModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<CreateRoomModel?> CreateChatRoomAPi(String id) async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/chat/check-room/${id}");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("CreateChatRoomAPi Response:${res.body}");
        return CreateRoomModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<GetLeaveModel?> GetLeave() async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/leave/leave");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("GetProjectsList Response:${res.body}");
        return GetLeaveModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<GetLeaveCountModel?> GetLeaveCount() async {
    try {

      final headers = await getheader();
      final url = Uri.parse("${host}/leave/leave-count");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("GetLeaveCount Response:${res.body}");
        return GetLeaveCountModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }
}
