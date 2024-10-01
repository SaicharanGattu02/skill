class ProjectActivityModel {
  List<Activity>? data;
  Settings? settings;

  ProjectActivityModel({this.data, this.settings});

  ProjectActivityModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Activity>[];
      json['data'].forEach((v) {
        data!.add(new Activity.fromJson(v));
      });
    }
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.settings != null) {
      data['settings'] = this.settings!.toJson();
    }
    return data;
  }
}

class Activity {
  String? userName;
  String? userImage;
  String? description;
  String? action;
  String? projectName;
  String? createdTime;

  Activity(
      {this.userName,
        this.userImage,
        this.description,
        this.action,
        this.projectName,
        this.createdTime});

  Activity.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    userImage = json['user_image'];
    description = json['description'];
    action = json['action'];
    projectName = json['project_name'];
    createdTime = json['created_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    data['description'] = this.description;
    data['action'] = this.action;
    data['project_name'] = this.projectName;
    data['created_time'] = this.createdTime;
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
