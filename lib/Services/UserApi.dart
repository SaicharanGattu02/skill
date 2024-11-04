import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mime/mime.dart';
import 'package:skill/Model/CountriesModel.dart';
import 'package:skill/Model/GetLeaveCountModel.dart';
import 'package:skill/Model/GetLeaveModel.dart';
import 'package:skill/Model/GetTaskDetailModel.dart';
import 'package:skill/Model/MeetingModel.dart';
import 'package:skill/Model/ProjectActivityModel.dart';
import 'package:skill/Model/ProjectCommentsModel.dart';
import 'package:skill/Model/ProjectLabelColorModel.dart';
import 'package:skill/Model/ProjectStatusModel.dart';
import 'package:skill/Model/ProjectsModel.dart';
import 'package:skill/Model/StatesModel.dart';
import '../Model/CreateRoomModel.dart';
import '../Model/CreateZoomMeeting.dart';
import '../Model/DashboardTaksModel.dart';
import '../Model/EmployeeListModel.dart';
import '../Model/GetCatagoryModel.dart';
import '../Model/GetEditProjectNoteModel.dart';
import '../Model/FetchmesgsModel.dart';
import '../Model/Get_Color_Response.dart';
import '../Model/GetMilestonedetailsModel.dart';
import '../Model/GetFileModel.dart';
import '../Model/LeaveRequestModel.dart';
import '../Model/LoginModel.dart';
import '../Model/MeetingProviders.dart';
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
import '../Model/UserDetailModel.dart';
import '../Model/UserDetailsModel.dart';
import '../utils/constants.dart';
import 'otherservices.dart';
import 'package:path/path.dart' as p;

class Userapi {
  static String host = "http://192.168.0.32:8000";
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

  static Future<LoginModel?> PostLogin(String mail, String password,String fcm_token,String token_type) async {
    try {
      Map<String, String> data = {
        "email": mail,
        "password": password,
        "fcm_token": fcm_token,
        "token_type": token_type
      };
      print("PostLogin data:${data}");
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

  static Future<MeetingModel?> GetMeetingbydate(String date) async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/dashboard/user-meetings?date=$date");
      print("URL:${url}");
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

  static Future<TasklistModel?> GetTask(String id,String milestone,String status,String assigned,String priority,String deadline) async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/project/project-tasks?project_id=${id}&status=${status}&assigned_to=${assigned}&deadline=${deadline}&milestone=${milestone}");
      print(id);
      final res = await get(url, headers: headers);
      if (res != null) {
        print("GetTask Response:${res.body}");
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

  static Future<GetTaskKanBanModel?> GetTaskKanBan(String id,String Status) async {
    try {
      final headers = await getheader();
      final url = Uri.parse(
          "${host}/project/project-tasks-kanban?project_id=${id}&status=${Status}");

      final res = await get(url, headers: headers);
      if (res != null) {
        print("GetTaskKanBan $Status Response:${res.body}");

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

  static Future<GetTaskKanBanModel?> TaskKanBanUpdate (String id,String Status) async {
    try {
      final headers = await getheader();
      final url = Uri.parse(
          "${host}/project/project-task-kanban-update/${id}?status=${Status}");
      final res = await http.patch(url, headers: headers);
      if (res != null) {
        print("GetTaskKanBanUpdate $Status Response:${res.body}");

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
        print("GetProjectsOverviewApi Response:${res.body}");
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

  static Future<GetTaskDetailModel?> GetTaskDetail(String taskid) async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/project/project-task-detail/$taskid");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("GetTaskDetail Response:${res.body}");
        return GetTaskDetailModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>> GetMileStoneApi(String id) async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/project/project-milestones?project_id=$id");
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 200 || res.statusCode == 201) {
        print("GetMileStone Response: ${res.body}");
        final result = GetMileStoneModel.fromJson(jsonDecode(res.body));
        return {'success': true, 'response': result};
      } else {
        final errorResponse = jsonDecode(res.body);
        return {
          'success': false,
          'response': errorResponse
        };
      }
    } on SocketException {
      return {
        'success': false,
        'response': NO_INTERNET
      };
    } on FormatException {
      return {
        'success': false,
        'response':BAD_RESPONSE
      };
    } on HttpException {
      return {
        'success': false,
        'response': SOMETHING_WRONG // Server not responding
      };
    } catch (e) {
      debugPrint('Error: $e');
      return {
        'success': false,
        'response':SOMETHING_WRONG // Handle any other unexpected errors
      };
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
      List<String> collaborators,
      File? image, // Make image optional
          {int points = 3} // Make points dynamic with a default
      ) async {
    try {
      final url = Uri.parse("${host}/project/project-tasks");
      Map<String, String> body = {
        "project_id": projectId,
        "title": title,
        "description": desc,
        "points": points.toString(), // Use dynamic points
        "milestone": milestone,
        "assign_to": assignedTo,
        "status": status,
        "priority": priority,
        "start_date": startDate,
        "end_date": endDate,
      };

      print("CreateTask: $body");

      final headers = await getheader();

      var req = http.MultipartRequest('POST', url)
        ..headers.addAll(headers)
        ..fields.addAll(body);

      req.fields.addAll({
        for (int i = 0; i < collaborators.length; i++) 'collaborators[$i]': collaborators[i],
      });

      print("Request fields: ${req.fields}");

      if (image != null) {
        String? mimeType = lookupMimeType(image.path);
        if (mimeType == null || !mimeType.startsWith('image/')) {
          print('Selected file is not a valid image.');
          return null;
        }
        req.files.add(
          await http.MultipartFile.fromPath(
            'file',
            image.path,
            contentType: MediaType.parse(mimeType),
          ),
        );
      } else {
        print('No image provided.');
      }

      var res = await req.send();
      var responseBody = await res.stream.bytesToString();

      if (res.statusCode == 200) {
        print("Response: $responseBody");
        return TaskAddmodel.fromJson(jsonDecode(responseBody));
      } else {
        print('Error: ${res.statusCode}, Response: $responseBody');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  static Future<TaskAddmodel?> updateTask(
      String taskId,
      String title,
      String desc,
      String milestone,
      String assignedTo,
      String status,
      String priority,
      String startDate,
      String endDate,
      List<String> collaborators,
      File? image,
      ) async {
    try {
      print("Collaborators: $collaborators");
      final url = Uri.parse("${host}/project/project-task-detail/$taskId");

      // Create a multipart request
      var req = http.MultipartRequest('PUT', url)
        ..headers.addAll(await getheader())
        ..fields['title'] = title
        ..fields['description'] = desc
        ..fields['points'] = '3' // Adjust as needed
        ..fields['milestone'] = milestone
        ..fields['assign_to'] = assignedTo
        ..fields['status'] = status
        ..fields['priority'] = priority
        ..fields['start_date'] = startDate
        ..fields['end_date'] = endDate;

      // Use this approach to handle multiple collaborators
      req.fields.addAll({
        for (int i = 0; i < collaborators.length; i++) 'collaborators[$i]': collaborators[i],
      });

      // Print the requested fields
      print("Requested Fields: ${req.fields}");

      // Check if an image is provided
      if (image != null) {
        String? mimeType = lookupMimeType(image.path);
        if (mimeType == null || !mimeType.startsWith('image/')) {
          print('Selected file is not a valid image.');
          return null; // Return null for invalid image
        }

        // Add the image file to the request
        req.files.add(
          await http.MultipartFile.fromPath(
            'file',
            image.path,
            contentType: MediaType.parse(mimeType),
          ),
        );
      } else {
        print('No image provided.');
      }

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
      final response = await http.put(
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
      String title, String description, File? image, String id) async {
    String? mimeType;
    if (image != null) {
      mimeType = lookupMimeType(image.path);
      if (mimeType == null || !mimeType.startsWith('image/')) {
        print('Selected file is not a valid image.');
        return null;
      }
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

      // Attach the image file to the request if it's provided
      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file', // The field name for the image, make sure it matches your API
            image.path,
            contentType: mimeType != null ? MediaType.parse(mimeType) : null,
          ),
        );
      }

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


  static Future<LoginModel?> PutEditNote(
      String editid, String title, String description, File? image, String id) async {
    print("editid2>>${editid}");

    String? mimeType;
    if (image != null) {
      // Validate the file type to ensure it's an image
      mimeType = lookupMimeType(image.path);
      if (mimeType == null || !mimeType.startsWith('image/')) {
        print('Selected file is not a valid image.');
        return null;
      }
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

      // Attach the image file to the request if it's provided
      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            image.path,
            contentType: mimeType != null ? MediaType.parse(mimeType) : null,
          ),
        );
      }

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

  static Future<LoginModel?> ProjectDelateComments(id) async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/project/project-comment-detail/${id}");
      final res = await http.delete(url, headers: headers);
      if (res != null) {
        print("ProjectDelateComments Response:${res.body}");
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

  static Future<LoginModel?> ProjectDelateTask(id) async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/project/project-task-detail/$id");
      final res = await http.delete(url, headers: headers);
      if (res != null) {
        print("ProjectDelateTask Response:${res.body}");
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

  static Future<ToDoListModel?> gettodolistApi(String date) async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/dashboard/user-todos?date=$date");
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

  static Future<DashboardTaksModel?> gettaskaApi(String date) async {
    try {
      final headers = await getheader();
      final url = Uri.parse("${host}/dashboard/user-tasks?date=$date");
      final res = await get(url, headers: headers);
      if (res != null) {
        print("gettaskaApi Response:${res.body}");
        return DashboardTaksModel.fromJson(jsonDecode(res.body));
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
      String id, String category, File? image, String description) async {
    // Validate the file type if image is provided
    if (image != null) {
      String? mimeType = lookupMimeType(image.path);
      if (mimeType == null || !mimeType.startsWith('image/')) {
        print('Selected file is not a valid image.');
        return null;
      }
    }

    try {
      final url = Uri.parse("${host}/project/project-files");

      // Headers
      final headers = await getheader(); // Ensure this includes your authorization token

      // Create multipart request
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll(headers)
        ..fields['project_id'] = id
        ..fields['category_id'] = category
        ..fields['description'] = description;

      // Attach the image file to the request if it's not null
      if (image != null) {
        String? mimeType = lookupMimeType(image.path);
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            image.path,
            contentType: MediaType.parse(mimeType!), // Set the MIME type
          ),
        );
      }

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
      String id, String category, File? image, String description) async {
    // Validate the file type if image is provided
    if (image != null) {
      String? mimeType = lookupMimeType(image.path);
      if (mimeType == null || !mimeType.startsWith('image/')) {
        print('Selected file is not a valid image.');
        return null;
      }
    }

    try {
      final url = Uri.parse("${host}/project/project-file-detail/${id}");

      // Headers
      final headers = await getheader(); // Ensure this includes your authorization token

      // Create multipart request
      var request = http.MultipartRequest('PUT', url)
        ..headers.addAll(headers)
        ..fields['project_id'] = id
        ..fields['category_id'] = category
        ..fields['description'] = description;

      print("putProjectFile>>${request}");

      // Attach the image file to the request if it's not null
      if (image != null) {
        String? mimeType = lookupMimeType(image.path);
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            image.path,
            contentType: MediaType.parse(mimeType!), // Set the MIME type
          ),
        );
      }

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

  static Future<LoginModel?> PostProjectTodo(String name, String description,
      String date, String priority, String label) async {
    try {
      Map<String, String> data = {
        'task_name': name,
        'description': description,
        'date': date,
        'priority': priority,
        'label': label
      };

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

  static Future<LoginModel?> postAddMeeting(
      String title,
      String description,
      String projects,
      String meetingType,
      List<String> collaborators, // Changed to a List for multiple collaborators
      String datetime,
      String meetingLink,
      String mail
      ) async {
    try {
      // Define the URL
      final url = Uri.parse('${host}/meeting/add-meeting');

      // Fetch the headers (including auth headers)
      final headers = await getheader();

      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', url);

      // Add headers to the request
      request.headers.addAll(headers);

      // Add fields to the request
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['project'] = projects;
      request.fields['meeting_type'] = meetingType;
      request.fields['start_date'] = datetime;
      request.fields['meeting_link'] = meetingLink;
      request.fields['external'] = mail;

      // Use this approach to handle multiple collaborators
      request.fields.addAll({
        for (int i = 0; i < collaborators.length; i++) 'collaborators[$i]': collaborators[i],
      });

      print(" request.fields :${request.fields}");

      // Send the request
      final response = await request.send();

      // Check response status
      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseString);
        print("postAddMeeting: $responseString");
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
      Map<String, String> data = {
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

  static Future<LoginModel?> addMeeting() async {
    final url = Uri.parse('${host}/meeting/add-meeting');
    // Prepare headers
    final headers = await getheader();
    // Prepare form data
    final request = http.MultipartRequest('POST', url)
      ..headers.addAll(headers)
      ..fields['title'] = 'meeting 5'
      ..fields['description'] = 'test meeting 5'
      ..fields['project'] = 'b2a78098d7b142e0bb69a3214c35aa8f'
      ..fields['meeting_type'] = 'internal'
      ..fields['external'] = 'charandeep dokara'
      ..fields['start_date'] = '2024-09-28 14:50:55'
      ..fields['meeting_link'] = 'https://meeting5.com'
      ..fields['collaborators'] = 'a952174dfa5548628ed606d44e55ddbb'
      ..fields['collaborators'] = '7fceb6a6ee0546e48f365e15079561e2';
    try {
      // Send the request
      final response = await request.send();
      // Check the response status
      if (response.statusCode == 200) {
        final responseBody = await http.Response.fromStream(response);
        print('Meeting added successfully: ${responseBody.body}');
        return LoginModel.fromJson(jsonDecode(responseBody.body));
      } else {
        print('Failed to add meeting: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  static Future<LoginModel?> UpdateUserDetails(
      String fullname, String phonenumber, File? image) async {
    String? mimeType; // Declare mimeType outside the condition

    // Validate the file type if an image is provided
    if (image != null) {
      mimeType = lookupMimeType(image.path);
      if (mimeType == null || !mimeType.startsWith('image/')) {
        print('Selected file is not a valid image.');
        return null;
      }
    }

    try {
      final url = Uri.parse("$host/dashboard/user-detail");

      // Headers
      final headers = await getheader(); // Ensure this includes your authorization token

      // Create multipart request
      var request = http.MultipartRequest('PUT', url)
        ..headers.addAll(headers)
        ..fields['full_name'] = fullname
        ..fields['mobile'] = phonenumber;

      // Attach the image file to the request if it exists
      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            image.path,
            contentType: MediaType.parse(mimeType!), // Use the non-nullable mimeType
          ),
        );
      }

      print("Request: $request");

      // Send the request
      var response = await request.send();

      // Check for response status
      if (response.statusCode == 200) {
        // Parse the response body
        final respStr = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(respStr);
        print("UpdateUserDetails: $jsonResponse");

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

  static Future<LoginModel?> notifyUser(String id) async {
    final url = '${host}/dashboard/notify-user/$id';
    final headers = await getheader();
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        print("notifyUser Response:${response.body}");
        return LoginModel.fromJson(jsonDecode(response.body));
      } else {
        // Handle error response
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
    }
  }

  static Future<UserDetailModel?>UserDetails(String id) async {
    final url = '${host}/chat/user/$id';
    final headers = await getheader();
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        print("UserDetails Response:${response.body}");
        return UserDetailModel.fromJson(jsonDecode(response.body));
      } else {
        // Handle error response
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
    }
  }

 static Future<LoginModel?> deleteTask(String taskId) async {
    final url = '${host}/todo/delete-task/$taskId';
    final headers = await getheader();
    final response = await http.put(
      Uri.parse(url),
      headers: headers,
      // You can include a body if your API expects it
    );

    if (response.statusCode == 200) {
      print("UserDetails Response:${response.body}");
      return LoginModel.fromJson(jsonDecode(response.body));
    } else {
      // Handle error
      print('Failed to delete task: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  }

  static Future<LoginModel?> PostPunchOutAPI(
      String lat, String long,String location,) async {
    try {
      Map<String, String> data = {
        "punch_out_latitude": lat,
        "punch_out_longitude": long,
        "punch_out_address": location,
      };
      print("PostPunchOutAPI data: $data");
      final url = Uri.parse("${host}/dashboard/punch");
      final headers = await getheader();
      final response = await http.put(url, headers: headers,body: jsonEncode(data));
      if (response!=null) {
        final jsonResponse = jsonDecode(response.body);
        print("PostPunchOutAPI response:${response.body}");
        return LoginModel.fromJson(jsonResponse);
      } else {
        return null;
      }

    } catch (e) {}
  }


  static Future<LoginModel?> PostPunchInAPI(
      String lat, String long,String location,) async {
    try {
      Map<String, String> data = {
        "punch_in_latitude": lat,
        "punch_in_longitude": long,
        "punch_in_address": location,
      };
      print("Punching data: $data");

      final url = Uri.parse("${host}/dashboard/punch");
      final headers = await getheader();
      final response = await http.post(url, headers: headers,body: jsonEncode(data));
      if (response!=null) {
        final jsonResponse = jsonDecode(response.body);
        print("Punchin response:${response.body}");
        return LoginModel.fromJson(jsonResponse);
      } else {
        return null;
      }

    } catch (e) {}
  }

  static Future<LoginModel?>VerifyEmail(String email, String otp) async {
    try {
      Map<String, String> data = {
        "email": email,
        "otp": otp,
      };
      print("VerifyEmail data: $data");
      final url = Uri.parse("${host}/auth/verify-email-otp");
      final headers = await getheader();
      final response = await http.post(url, headers: headers,body: jsonEncode(data));
      if (response!=null) {
        final jsonResponse = jsonDecode(response.body);
        print("VerifyEmail response:${response.body}");
        return LoginModel.fromJson(jsonResponse);
      } else {
        return null;
      }

    } catch (e) {}
  }

  static Future<LoginModel?>resendemail(String email) async {
    try {
      Map<String, String> data = {
        "email": email,
      };
      print("resendemail data: $data");
      final url = Uri.parse("${host}/auth/resend-email-otp");
      final headers = await getheader();
      final response = await http.post(url, headers: headers,body: jsonEncode(data));
      if (response!=null) {
        final jsonResponse = jsonDecode(response.body);
        print("resendemail response:${response.body}");
        return LoginModel.fromJson(jsonResponse);
      } else {
        return null;
      }

    } catch (e) {}
  }

  static Future<LoginModel?>resendMobile(String mobile) async {
    try {
      Map<String, String> data = {
        "mobile": mobile
      };
      print("resendMobile data: $data");
      final url = Uri.parse("${host}/auth/resend-mobile-otp");
      final headers = await getheader();
      final response = await http.post(url, headers: headers,body: jsonEncode(data));
      if (response!=null) {
        final jsonResponse = jsonDecode(response.body);
        print("resendMobile response:${response.body}");
        return LoginModel.fromJson(jsonResponse);
      } else {
        return null;
      }

    } catch (e) {}
  }

  static Future<LoginModel?>VerifyMobile(String mobile, String otp) async {
    try {
      Map<String, String> data = {
        "mobile": mobile,
        "otp": otp,
      };
      print("VerifyMobile data: $data");
      final url = Uri.parse("${host}/auth/verify-mobile-otp");
      final headers = await getheader();
      final response = await http.post(url, headers: headers,body: jsonEncode(data));
      if (response!=null) {
        final jsonResponse = jsonDecode(response.body);
        print("VerifyMobile response:${response.body}");
        return LoginModel.fromJson(jsonResponse);
      } else {
        return null;
      }

    } catch (e) {}
  }

  static Future<LoginModel?> createCompany(String name,String address,String staff,String state,String country,String city) async {
    Map<String, String> data = {
      'name': name,
      'address': address,
      'staff': staff,
      'state': state,
      'country': country,
      'city': city,
    };
    print("createCompany data: $data");
    final url = Uri.parse("${host}/company/list");
    final headers = await getheader();
    final response = await http.post(url, headers: headers,body: jsonEncode(data));
    if (response!=null) {
      final jsonResponse = jsonDecode(response.body);
      print("createCompany response:${response.body}");
      return LoginModel.fromJson(jsonResponse);
    } else {
      return null;
    }
  }

  static Future<CountriesModel?> getcountries() async {
    final url = Uri.parse("${host}/company/countries");
    final headers = await getheader();
    final response = await http.get(url, headers: headers);
    if (response!=null) {
      final jsonResponse = jsonDecode(response.body);
      print("getcountries response:${response.body}");
      return CountriesModel.fromJson(jsonResponse);
    } else {
      return null;
    }
  }

  static Future<StatesModel?> getstates() async {
    final url = Uri.parse("${host}/company/states");
    final headers = await getheader();
    final response = await http.get(url, headers: headers);
    if (response!=null) {
      final jsonResponse = jsonDecode(response.body);
      print("getstates response:${response.body}");
      return StatesModel.fromJson(jsonResponse);
    } else {
      return null;
    }
  }

  static  Future<MeetingProviders?> fetchMeetingProviders() async {
    final url = Uri.parse("${host}/meeting/meeting-providers");
    final headers = await getheader();
    try {
      final response = await http.get(url, headers: headers);
      if (response!=null) {
        final jsonResponse = jsonDecode(response.body);
        print("fetchMeetingProviders response:${response.body}");
        return MeetingProviders.fromJson(jsonResponse);
      } else {
        print('Error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  static Future<CreateZoomMeeting?> createZoomMeeting(
      String title,
      String description,
      String start_date,
      String collaborators,
      String meeting_type,
      String external) async {
    final url = Uri.parse("${host}/meeting/zoom-meeting");
    final headers = await getheader();

    // Create the body as a JSON string
    final body = jsonEncode({
      'title': title,
      'description': description,
      'start_date': start_date,
      'collaborators': ['nagagopi@pixl.in', 'balaji@pixl.in'], // Use your variable if needed
      'meeting_type': meeting_type,
      'external': external,
    });

    try {
      final response = await http.post(
        url,
        headers:headers,
        body: body, // Send the JSON string as the body
      );
      if (response.statusCode == 200) { // Check for successful response
        final jsonResponse = jsonDecode(response.body);
        print("createZoomMeeting response: ${response.body}");
        return CreateZoomMeeting.fromJson(jsonResponse);
      } else {
        print('Error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
    return null; // Return null if an error occurs
  }


}
