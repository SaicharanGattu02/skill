class ProjectPrioritiesModel {
  List<Priorities>? data;
  Settings? settings;

  ProjectPrioritiesModel({this.data, this.settings});

  ProjectPrioritiesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Priorities>[];
      json['data'].forEach((v) {
        data!.add(new Priorities.fromJson(v));
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

class Priorities {
  String? priorityKey;
  String? priorityValue;

  Priorities({this.priorityKey, this.priorityValue});

  Priorities.fromJson(Map<String, dynamic> json) {
    priorityKey = json['priority_key'];
    priorityValue = json['priority_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['priority_key'] = this.priorityKey;
    data['priority_value'] = this.priorityValue;
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
