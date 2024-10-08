class UserDetailsModel {
  UserData? data;
  Settings? settings;

  UserDetailsModel({this.data, this.settings});

  UserDetailsModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new UserData.fromJson(json['data']) : null;
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.settings != null) {
      data['settings'] = this.settings!.toJson();
    }
    return data;
  }
}

class UserData {
  String? id;
  String? fullName;
  String? image;
  String? email;
  String? status;
  String? mobile;
  String? userNumber;
  int? projectCount;
  int? todoCount;
  int? tasksCount;
  int? meetingCount;

  UserData(
      {this.id,
        this.fullName,
        this.image,
        this.email,
        this.status,
        this.mobile,
        this.userNumber,
        this.projectCount,
        this.todoCount,
        this.tasksCount,
        this.meetingCount});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    image = json['image'];
    email = json['email'];
    status = json['status'];
    mobile = json['mobile'];
    userNumber = json['user_number'];
    projectCount = json['project_count'];
    todoCount = json['todo_count'];
    tasksCount = json['tasks_count'];
    meetingCount = json['meeting_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['image'] = this.image;
    data['email'] = this.email;
    data['status'] = this.status;
    data['mobile'] = this.mobile;
    data['user_number'] = this.userNumber;
    data['project_count'] = this.projectCount;
    data['todo_count'] = this.todoCount;
    data['tasks_count'] = this.tasksCount;
    data['meeting_count'] = this.meetingCount;
    return data;
  }
}

class Settings {
  int? success;
  String? message;
  int? status;

  Settings({this.success, this.message, this.status});

  Settings.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
