class MeetingModel {
  List<Data>? data;
  Settings? settings;

  MeetingModel({this.data, this.settings});

  MeetingModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null && json['data'] is List) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    } else if (json['data'] != null && json['data'] is Map) {
      // Handle case where 'data' is an empty object or a single object
      data = [Data.fromJson(json['data'])]; // Add a single Data object if necessary
    } else {
      data = [];
    }
    settings = json['settings'] != null
        ? Settings.fromJson(json['settings'])
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
  String? id;
  String? title;
  String? description;
  String? project;
  String? meetingType;
  String? external;
  String? startDate;
  String? meetingLink;

  Data(
      {this.id,
        this.title,
        this.description,
        this.project,
        this.meetingType,
        this.external,
        this.startDate,
        this.meetingLink});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    project = json['project'];
    meetingType = json['meeting_type'];
    external = json['external'];
    startDate = json['start_date'];
    meetingLink = json['meeting_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['project'] = this.project;
    data['meeting_type'] = this.meetingType;
    data['external'] = this.external;
    data['start_date'] = this.startDate;
    data['meeting_link'] = this.meetingLink;
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
