class ProjectStatusModel {
  List<Statuses>? data;
  Settings? settings;

  ProjectStatusModel({this.data, this.settings});

  ProjectStatusModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Statuses>[];
      json['data'].forEach((v) {
        data!.add(new Statuses.fromJson(v));
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

class Statuses {
  String? statusKey;
  String? statusValue;

  Statuses({this.statusKey, this.statusValue});

  Statuses.fromJson(Map<String, dynamic> json) {
    statusKey = json['status_key'];
    statusValue = json['status_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_key'] = this.statusKey;
    data['status_value'] = this.statusValue;
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
