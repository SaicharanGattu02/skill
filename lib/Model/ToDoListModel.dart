class ToDoListModel {
  List<TODOList>? data;
  Settings? settings;

  ToDoListModel({this.data, this.settings});

  ToDoListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TODOList>[];
      json['data'].forEach((v) {
        data!.add(new TODOList.fromJson(v));
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

class TODOList {
  String? id;
  String? taskName;
  String? description;
  String? dateTime;
  String? priority;
  String? labelId;
  String? labelName;
  String? labelColor;

  TODOList(
      {this.id,
        this.taskName,
        this.description,
        this.dateTime,
        this.priority,
        this.labelId,
        this.labelName,
        this.labelColor});

  TODOList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskName = json['task_name'];
    description = json['description'];
    dateTime = json['date_time'];
    priority = json['priority'];
    labelId = json['label_id'];
    labelName = json['label_name'];
    labelColor = json['label_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['task_name'] = this.taskName;
    data['description'] = this.description;
    data['date_time'] = this.dateTime;
    data['priority'] = this.priority;
    data['label_id'] = this.labelId;
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