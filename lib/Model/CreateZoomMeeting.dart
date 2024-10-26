class CreateZoomMeeting {
  Data? data;
  Settings? settings;

  CreateZoomMeeting({this.data, this.settings});

  CreateZoomMeeting.fromJson(Map<String, dynamic> json) {
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
  Content? content;

  Data({this.content});

  Data.fromJson(Map<String, dynamic> json) {
    content =
    json['content'] != null ? new Content.fromJson(json['content']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content!.toJson();
    }
    return data;
  }
}

class Content {
  String? meetingUrl;
  String? password;
  String? meetingTime;
  String? purpose;
  int? duration;
  String? agenda;
  String? message;
  int? status;

  Content(
      {this.meetingUrl,
        this.password,
        this.meetingTime,
        this.purpose,
        this.duration,
        this.agenda,
        this.message,
        this.status});

  Content.fromJson(Map<String, dynamic> json) {
    meetingUrl = json['meeting_url'];
    password = json['password'];
    meetingTime = json['meetingTime'];
    purpose = json['purpose'];
    duration = json['duration'];
    agenda = json['agenda'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['meeting_url'] = this.meetingUrl;
    data['password'] = this.password;
    data['meetingTime'] = this.meetingTime;
    data['purpose'] = this.purpose;
    data['duration'] = this.duration;
    data['agenda'] = this.agenda;
    data['message'] = this.message;
    data['status'] = this.status;
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
