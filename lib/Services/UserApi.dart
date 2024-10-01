import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:skill/Model/GetLeaveCountModel.dart';
import 'package:skill/Model/GetLeaveModel.dart';
import 'package:skill/Model/MeetingModel.dart';
import 'package:skill/Model/ProjectActivityModel.dart';
import 'package:skill/Model/ProjectStatusModel.dart';
import 'package:skill/Model/ProjectsModel.dart';

import '../Model/CreateRoomModel.dart';
import '../Model/EmployeeListModel.dart';
import '../Model/LoginModel.dart';
import '../Model/MileStoneModel.dart';
import '../Model/ProjectFileModel.dart';
import '../Model/ProjectNoteModel.dart';
import '../Model/ProjectOverviewModel.dart';
import '../Model/ProjectPrioritiesModel.dart';
import '../Model/RegisterModel.dart';
import '../Model/TaskKanBanModel.dart';
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

  static Future<TasklistModel?> GetTask(String id) async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/project/project-tasks?project_id=${id}");
      print(id);
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
  static Future<GetTaskKanBanModel?> GetTaskKanBan(String id) async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/project/project-tasks-kanban?project_id=${id}&status=to_do");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("GetTaskKanBan Response:${res.body}");

        return GetTaskKanBanModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<ProjectOverviewModel?> GetProjectsOverviewApi(String id) async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/project/project-overview/${id}");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("GetProjectsList Response:${res.body}");
        return ProjectOverviewModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<GetMileStoneModel?> GetMileStoneApi(String id) async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/project/project-milestones?project_id=${id}");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("GetMileStone Response:${res.body}");
        return GetMileStoneModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<ProjectActivityModel?> GetProjectsActivityApi(String id) async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/project/project-activity/${id}");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("GetProjectsActivityApi Response:${res.body}");
        return ProjectActivityModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<ProjectStatusModel?> GetProjectsStatusesApi() async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/project/project-task-statuses");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("GetProjectsStatusesApi Response:${res.body}");
        return ProjectStatusModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<ProjectPrioritiesModel?> GetProjectsPrioritiesApi() async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/project/project-task-priorities");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("GetProjectsPrioritiesApi Response:${res.body}");
        return ProjectPrioritiesModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }
  static Future<NoteModel?> GetProjectNote(String id) async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/project/project-notes?project_id=${id}");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("GetProjectNote Response:${res.body}");
        return NoteModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<FileModel?> GetProjectFile(String id) async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/project/project-files?project_id=${id}");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("GetProjectNote Response:${res.body}");
        return FileModel.fromJson(jsonDecode(res.body));
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
