
class ProjectOverviewModel {
  Data? data;
  Settings? settings;

  ProjectOverviewModel({this.data, this.settings});

  ProjectOverviewModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  String? id;
  String? name;
  String? description;
  String? client; 
  List<Members>? members;
  String? icon;
  String? status;
  String? startDate;
  String? endDate;
  String? totalTimeWorked;
  String? totalPercent;
  String? todoPercent;
  String? inProgressPercent;

  Data({
    this.id,
    this.name,
    this.description,
    this.client,
    this.members,
    this.icon,
    this.status,
    this.startDate,
    this.endDate,
    this.totalTimeWorked,
    this.totalPercent,
    this.todoPercent,
    this.inProgressPercent,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    client = json['client'];

    if (json['members'] != null) {
      members = <Members>[];
      json['members'].forEach((v) {
        members!.add(Members.fromJson(v));
      });
    }

    icon = json['icon'];
    status = json['status'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    totalTimeWorked = json['total_time_worked'];

    // Safely parsing the percent values
    totalPercent = json['total_percent'].toString();
    todoPercent = json['todo_percent'].toString();
    inProgressPercent = json['in_progress_percent'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['client'] = this.client;
    if (this.members != null) {
      data['members'] = this.members!.map((v) => v.toJson()).toList();
    }
    data['icon'] = this.icon;
    data['status'] = this.status;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['total_time_worked'] = this.totalTimeWorked;
    data['total_percent'] = this.totalPercent;
    data['todo_percent'] = this.todoPercent;
    data['in_progress_percent'] = this.inProgressPercent;
    return data;
  }

  // Helper method to parse strings to int safely
  int? _parseInt(dynamic value) {
    if (value is String) {
      return int.tryParse(value);
    } else if (value is int) {
      return value;
    }
    return null;
  }
}

class Members {
  String? id;
  String? fullName;
  String? image;

  Members({this.id, this.fullName, this.image});

  Members.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['image'] = this.image;
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
