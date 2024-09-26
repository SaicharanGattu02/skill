class TasklistModel {
  List<Data>? data;
  Settings? settings;

  TasklistModel({this.data, this.settings});

  TasklistModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? uid;
  String? taskName;
  String? description;
  String? dateTime;
  String? priority;
  String? labelName;
  String? labelColor;

  Data(
      {this.uid,
        this.taskName,
        this.description,
        this.dateTime,
        this.priority,
        this.labelName,
        this.labelColor});

  Data.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    taskName = json['task_name'];
    description = json['description'];
    dateTime = json['date_time'];
    priority = json['priority'];
    labelName = json['label_name'];
    labelColor = json['label_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['task_name'] = this.taskName;
    data['description'] = this.description;
    data['date_time'] = this.dateTime;
    data['priority'] = this.priority;
    data['label_name'] = this.labelName;
    data['label_color'] = this.labelColor;
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