import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mime/mime.dart';
import 'package:skill/Model/GetLeaveCountModel.dart';
import 'package:skill/Model/GetLeaveModel.dart';
import 'package:skill/Model/MeetingModel.dart';
import 'package:skill/Model/ProjectActivityModel.dart';
import 'package:skill/Model/ProjectCommentsModel.dart';
import 'package:skill/Model/ProjectLabelColorModel.dart';
import 'package:skill/Model/ProjectStatusModel.dart';
import 'package:skill/Model/ProjectsModel.dart';
import '../Model/CreateRoomModel.dart';
import '../Model/EmployeeListModel.dart';
import '../Model/GetCatagoryModel.dart';
import '../Model/GetEditProjectNoteModel.dart';
import '../Model/FetchmesgsModel.dart';
import '../Model/Get_Color_Response.dart';
import '../Model/GetMilestonedetailsModel.dart';
import '../Model/GetFileModel.dart';
import '../Model/LeaveRequestModel.dart';
import '../Model/LoginModel.dart';
import '../Model/MileStoneModel.dart';
import '../Model/ProjectFileModel.dart';
import '../Model/ProjectLabelModel.dart';
import '../Model/ProjectNoteModel.dart';
import '../Model/ProjectOverviewModel.dart';
import '../Model/ProjectPrioritiesModel.dart';
import '../Model/ProjectUserTasksModel.dart';
import '../Model/RegisterModel.dart';
import '../Model/RoomsDetailsModel.dart';
import '../Model/RoomsModel.dart';
import '../Model/TaskAddmodel.dart';
import '../Model/TaskKanBanModel.dart';
import '../Model/TasklistModel.dart';
import '../Model/TimeSheeetDeatilModel.dart';
import '../Model/ToDoListModel.dart';
import '../ProjectModule/UserDetailsModel.dart';
import 'otherservices.dart';
import 'package:path/path.dart' as p;

class Userapi {
  static String host = "http://192.168.0.56:8000";
  // static String host = "https://stage.skil.in";

  static Future<RegisterModel?> PostRegister(String fullname, String mail,
      String phone, String password, String gender) async {
    try {
      Map<String, String> data = {
        "full_name": fullname,
        "email": mail,
        "mobile": phone,
        "password": password,
        "gender": gender
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

  static Future<FetchmesgsModel?> fetchroommessages(
      String rommid, String lats_msg_id) async {
    try {
      final headers = await getheader();

      final url = Uri.parse("${host}/chat/room-messages/$rommid/$lats_msg_id");
      print("URL:${url}");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("fetchroommessages Response:${res.body}");
        return FetchmesgsModel.fromJson(jsonDecode(res.body));
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
      final url = Uri.parse(
          "${host}/project/project-tasks-kanban?project_id=${id}&status=to_do");
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
      final url =
          Uri.parse("${host}/project/project-milestones?project_id=${id}");
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

  static Future<TimeSheetDetailsModel?> GetProjectTimeSheetDetails(
      String id) async {
    try {
      final headers = await getheader();
      final url = Uri.parse('${host}/project/project-timesheets/${id}');
      final res = await get(url, headers: headers);
      if (res != null) {
        print("TimeSheetDetails Response:${res.body}");
        return TimeSheetDetailsModel.fromJson(jsonDecode(res.body));
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

  static Future<ProjectLabelModel?> GetProjectsLabelApi() async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/todo/labels");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("GetProjectsLabelApi Response:${res.body}");
        return ProjectLabelModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }


  static Future<ProjectLabelColorModel?> GetProjectsLabelColorApi() async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/todo/color-choices");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("GetProjectsLabelColorApi Response:${res.body}");
        return ProjectLabelColorModel.fromJson(jsonDecode(res.body));
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

  static Future<ProjectCommentsModel?> GetProjectComments(String id) async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/project/project-comments?project_id=$id");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("GetProjectComments Response:${res.body}");
        return ProjectCommentsModel.fromJson(jsonDecode(res.body));
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

  static Future<TaskAddmodel?> CreateTask(
    String projectId,
    String title,
    String desc,
    String milestone,
    String assignedTo,
    String status,
    String priority,
    String startDate,
    String endDate,
    List<String> collaborators, // Change type from String to List<String>
    File image,
  ) async {
    try {
      // Check if the file is an image
      String? mimeType = lookupMimeType(image.path);
      if (mimeType == null || !mimeType.startsWith('image/')) {
        print('Selected file is not a valid image.');
        return null; // Return null for invalid image
      }
      final url = Uri.parse("${host}/project/project-tasks");
      Map<String, String> body = {
        "project_id": projectId,
        "title": title,
        "description": desc,
        "points": '3', // Update as needed
        "milestone": milestone,
        "assign_to": assignedTo,
        "status": status,
        "priority": priority,
        "start_date": startDate,
        "end_date": endDate,
      };
      print("CreateTask:${body}");
      print("Image : ${image}");
      final headers = await getheader();
      // Create a multipart request
      var req = http.MultipartRequest('POST', url)
        ..headers.addAll(headers)
        ..fields.addAll(body);

      // Add collaborators as a separate field
      for (String collaborator in collaborators) {
        req.fields['collaborators[]'] = collaborator; // Use array notation
      }

      // Add the image file to the request
      req.files.add(
        await http.MultipartFile.fromPath(
          'file',
          image.path,
          contentType: MediaType.parse(mimeType),
        ),
      );

      // Send the request
      var res = await req.send();

      // Read the response body
      var responseBody = await res.stream.bytesToString();

      if (res.statusCode == 200) {
        print("Response: $responseBody");
        return TaskAddmodel.fromJson(jsonDecode(responseBody));
      } else {
        print('Error: ${res.statusCode}, Response: $responseBody');
        return null; // Return null for an unsuccessful response
      }
    } catch (e) {
      print('Exception: $e');
      return null; // Handle error case by returning null
    }
  }

  static Future<UserDetailsModel?> GetUserdetails() async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/dashboard/user-detail");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("GetUserdetails Response:${res.body}");
        return UserDetailsModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<LoginModel?> PostMileStone(
      String title, String description, String id, String date) async {
    try {
      Map<String, String> data = {
        'title': title,
        'description': description,
        'project_id': id,
        'due_date': date,
      };
      print("PostMileStone ${data}");

      final url = Uri.parse('${host}/project/project-milestones');
      final headers = await getheader();
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );
      if (response != null) {
        final jsonResponse = jsonDecode(response.body);
        print("PostMileStone Status:${response.body}");
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

  static Future<LoginModel?> putMileStone(
      String editId, String title, String description, String date) async {
    try {
      Map<String, String> data = {
        'title': title,
        'description': description,
        'due_date': date,
      };
      print("putMileStone ${data}");

      final url =
          Uri.parse('${host}/project/project-milestone-detail/${editId}');
      final headers = await getheader();
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );
      if (response != null) {
        final jsonResponse = jsonDecode(response.body);
        print("putMileStone Status:${response.body}");
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

  static Future<LoginModel?> PostAddNote(
      String title, String description, File image, String id) async {
    String? mimeType = lookupMimeType(image.path);
    if (mimeType == null || !mimeType.startsWith('image/')) {
      print('Selected file is not a valid image.');
      return null;
    }

    try {
      // API URL
      final url = Uri.parse('${host}/project/project-notes');
      // Headers (make sure they include the authorization token if required)
      final headers = await getheader();

      // Create a multipart request
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll(headers)
        ..fields['title'] = title
        ..fields['description'] = description
        ..fields['project_id'] = id;

      // Attach the image file to the request
      request.files.add(
        await http.MultipartFile.fromPath(
          'file', // The field name for the image, make sure it matches your API
          image.path,
          contentType: MediaType.parse(mimeType),
        ),
      );

      // Send the request
      var response = await request.send();

      // Check if the request was successful
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(respStr);
        print("PostAddNote Response: $jsonResponse");

        // Return the parsed response as a LoginModel object
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

  static Future<LoginModel?> PutEditNote(String editid, String title,
      String description, File image, String id) async {
    print("editid2>>${editid}");

    // Validate the file type to ensure it's an image
    String? mimeType = lookupMimeType(image.path);
    if (mimeType == null || !mimeType.startsWith('image/')) {
      print('Selected file is not a valid image.');
      return null;
    }

    try {
      // API URL
      final url = Uri.parse('${host}/project/project-note-detail/$editid');
      // Headers (make sure they include the authorization token if required)
      final headers = await getheader();

      // Create a multipart request
      var request = http.MultipartRequest('PUT', url)
        ..headers.addAll(headers)
        ..fields['title'] = title
        ..fields['description'] = description
        ..fields['project_id'] = id;

      // Attach the image file to the request
      request.files.add(
        await http.MultipartFile.fromPath(
          'file', // The field name for the image, adjust it according to the API if needed
          image.path,
          contentType: MediaType.parse(mimeType),
        ),
      );

      // Send the request
      var response = await request.send();

      // Check if the request was successful
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(respStr);
        print("PutEditNote Response: $jsonResponse");

        // Return the parsed response as a LoginModel object
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

  static Future<GetEditProjectNoteModel?> GetProjectEditNotes(editId) async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/project/project-note-detail/${editId}");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("GetProjectEditNotes Response:${res.body}");
        return GetEditProjectNoteModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<LoginModel?> ProjectDelateNotes(id) async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/project/project-note-detail/${id}");
      final res = await http.delete(url, headers: headers);
      if (res != null) {
        print("ProjectDelateNotes Response:${res.body}");
        return LoginModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<RoomsModel?> getrommsApi() async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/chat/rooms");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("getrommsApi Response:${res.body}");
        return RoomsModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<RoomsDetailsModel?> getrommsdetailsApi(String room_id) async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/chat/room/${room_id}");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("getrommsdetailsApi Response:${res.body}");
        return RoomsDetailsModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<ToDoListModel?> gettodolistApi() async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/todo/tasks");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("gettodolistApi Response:${res.body}");
        return ToDoListModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<GetMilestonedetailsModel?> getmilestonedeatilsApi(
      String id) async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/project/project-milestone-detail/${id}");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("getmilestonedeatilsApi Response:${res.body}");
        return GetMilestonedetailsModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<ProjectUserTasksModel?> getprojectusertasksApi(
      String id) async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/project/project-user-tasks/${id}");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("getprojectusertasksApi Response:${res.body}");
        return ProjectUserTasksModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<LeaveRequestModel?> LeaveRequest(
      String fromdate, String todate, String reason) async {
    try {
      Map<String, String> body = {
        "from_date": fromdate,
        "to_date": todate,
        "reason": reason,
      };
      final url = Uri.parse("${host}/leave/leave");
      final headers = await getheader();
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      if (response != null) {
        final jsonResponse = jsonDecode(response.body);
        print("PostRegister Status:${response.body}");
        return LeaveRequestModel.fromJson(jsonResponse);
      } else {
        print("Request failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }

  static Future<LoginModel?> AddLogtimeApi(String start_time, String end_time,
      String note, String task_id, String projectID) async {
    try {
      Map<String, String> body = {
        "start_time": start_time,
        "end_time": end_time,
        "note": note,
        "task_id": task_id,
      };
      print("AddLogtimeApi data: ${body}");
      final url = Uri.parse("${host}/project/project-timesheets/${projectID}");
      final headers = await getheader();
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      if (response != null) {
        final jsonResponse = jsonDecode(response.body);
        print("AddLogtimeApi response:${response.body}");
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

  static Future<LoginModel?> sendComment(
      String comment, String id, List images) async {
    var url = Uri.parse('${host}/project/project-comments');
    final headers = await getheader();

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers); // Add headers to the request
    request.fields['project_id'] = id;
    request.fields['comment'] = comment;

    // Add all selected files
    for (var imageFile in images) {
      request.files.add(await http.MultipartFile.fromPath(
        'files',
        imageFile.path,
        filename: p.basename(imageFile.path),
      ));
    }

    try {
      var response = await request.send();
      // Read the response body
      final responseBody = await response.stream.bytesToString();

      if (response != null) {
        final jsonResponse = jsonDecode(responseBody);
        print("sendComment response: $responseBody");
        return LoginModel.fromJson(jsonResponse);
      } else {
        print('Failed to send comment: ${response.statusCode}');
        print('Response body: $responseBody');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null; // Return null if there's an error or failure
  }

  static Future<GetCatagoryModel?> GetProjectCatagory(String id) async {
    try {
      final headers = await getheader();
      final url =
          Uri.parse("${host}/project/project-file-categories?project_id=${id}");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("getcatagory Response:${res.body}");
        return GetCatagoryModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<LoginModel?> postProjectFile(
      String id, String category, File image, String description) async {
    // Validate the file type to ensure it's an image
    String? mimeType = lookupMimeType(image.path);
    if (mimeType == null || !mimeType.startsWith('image/')) {
      print('Selected file is not a valid image.');
      return null;
    }

    try {
      final url = Uri.parse("${host}/project/project-files");

      // Headers
      final headers =
          await getheader(); // Make sure this includes your authorization token

      // Create multipart request
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll(headers)
        ..fields['project_id'] = id
        ..fields['category_id'] = category
        ..fields['description'] = description;

      // Attach the image file to the request
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          image.path,
          contentType: MediaType.parse(mimeType), // Set the MIME type
        ),
      );

      // Send the request
      var response = await request.send();

      // Check for response status
      if (response.statusCode == 200) {
        // Parse the response body
        final respStr = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(respStr);
        print("PostProjectFile: $jsonResponse");

        // Return the parsed login model
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

  static Future<LoginModel?> putProjectFile(
      String id, String category, File image, String description) async {
    // Validate the file type to ensure it's an image
    String? mimeType = lookupMimeType(image.path);
    if (mimeType == null || !mimeType.startsWith('image/')) {
      print('Selected file is not a valid image.');
      return null;
    }

    try {
      final url = Uri.parse("${host}/project/project-file-detail/${id}");

      // Headers
      final headers =
          await getheader(); // Make sure this includes your authorization token

      // Create multipart request
      var request = http.MultipartRequest('PUT', url)
        ..headers.addAll(headers)
        ..fields['project_id'] = id
        ..fields['category_id'] = category
        ..fields['description'] = description;
      print("putProjectFile>>${request}");
      // Attach the image file to the request
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          image.path,
          contentType: MediaType.parse(mimeType), // Set the MIME type
        ),
      );

      // Send the request
      var response = await request.send();

      // Check for response status
      if (response.statusCode == 200) {
        // Parse the response body
        final respStr = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(respStr);
        print("PostProjectFile: $jsonResponse");

        // Return the parsed login model
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

  static Future<LoginModel?> PostProjectCategory(String name, String id) async {
    try {
      Map<String, String> data = {'name': name, 'project_id': id};

      final url = Uri.parse('${host}/project/project-file-categories');
      final headers = await getheader();
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );
      if (response != null) {
        final jsonResponse = jsonDecode(response.body);
        print("PostProjectCategory :${response.body}");
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

  static Future<LoginModel?> PostProjectTodo(
      String name,
      String description,
      String date,
      String priority,
      String label) async {

    try {
      Map<String,String> data = {
      'task_name': name,
    'description': description,
    'date': date,
    'priority': priority,
    'label': label};

      final url = Uri.parse('${host}/todo/add-task');
      final headers = await getheader();
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );
      if (response != null) {
        final jsonResponse = jsonDecode(response.body);
        print("PostProjectTodo :${response.body}");
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
  static Future<LoginModel?> PostProjectTodoAddLabel(
      String name,
      String color,
    ) async {

    try {
      Map<String,String> data = {
        'name': name,
        'color': color,
       };

      final url = Uri.parse('${host}/todo/add-label');
      final headers = await getheader();
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );
      if (response != null) {
        final jsonResponse = jsonDecode(response.body);
        print("PostProjectTodoAddLabel :${response.body}");
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


  static Future<LoginModel?> PutProjectCategory(String name, String id) async {
    try {
      Map<String, String> data = {
        'name': name,
      };
      final url =
          Uri.parse('${host}/project/project-file-category-detail/${id}');
      final headers = await getheader();
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(data),
      );
      if (response != null) {
        final jsonResponse = jsonDecode(response.body);
        print("PostProjectCategory :${response.body}");
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

  static Future<GetFileModel?> GetEditFile(String id) async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/project/project-file-detail/${id}");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("GetFile Response:${res.body}");
        return GetFileModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<Get_Color_Response?> Getcolorcodes() async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/color-choices");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("GetProjectsPrioritiesApi Response:${res.body}");
        return Get_Color_Response.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<EmployeeListModel?> GetSearchUsers(String text) async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/chat/search-user?text=${text}");
      print("URL: ${url}");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("GetSearchUsers Response:${res.body}");
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
}
