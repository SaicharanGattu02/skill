class ProjectsModel {
  List<Data>? data;
  Settings? settings;

  ProjectsModel({this.data, this.settings});

  ProjectsModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? description;
  String? icon;
  String? status;
  String? startDate;
  int? total_percent;
  int? endDate;

  Data(
      {this.name,
        this.description,
        this.icon,
        this.status,
        this.startDate,
        this.total_percent,
        this.endDate});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    icon = json['icon'];
    status = json['status'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    total_percent = json['total_percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['icon'] = this.icon;
    data['status'] = this.status;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['total_percent'] = this.total_percent;
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
