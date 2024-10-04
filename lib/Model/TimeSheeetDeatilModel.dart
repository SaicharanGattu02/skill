class TimeSheetDetailsModel {
  List<Data>? data;
  String? totalTime;
  Settings? settings;

  TimeSheetDetailsModel({this.data, this.totalTime, this.settings});

  TimeSheetDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    totalTime = json['total_time'];
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['total_time'] = this.totalTime;
    if (this.settings != null) {
      data['settings'] = this.settings!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? member;
  String? task;
  String? startTime;
  String? endTime;
  String? note;
  String? total;
  String? image;

  Data(
      {this.id,
        this.member,
        this.task,
        this.startTime,
        this.endTime,
        this.note,
        this.total,
        this.image});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    member = json['member'];
    task = json['task'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    note = json['note'];
    total = json['total'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['member'] = this.member;
    data['task'] = this.task;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['note'] = this.note;
    data['total'] = this.total;
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
