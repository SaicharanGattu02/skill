class TimeSheetDetailsModel {
  List<Data>? data;
  String? totalTime;
  Settings? settings;

  TimeSheetDetailsModel({this.data, this.totalTime, this.settings});

  TimeSheetDetailsModel.fromJson(Map<String, dynamic> json) {
    // Check if 'data' is a List and not an empty object
    if (json['data'] is List) {
      data = (json['data'] as List).map((v) => Data.fromJson(v)).toList();
    } else if (json['data'] is Map && json['data'].isEmpty) {
      // If it's an empty object, assign an empty list
      data = [];
    } else {
      data = null; // Handle unexpected formats
    }

    totalTime = json['total_time'];
    settings = json['settings'] != null
        ? Settings.fromJson(json['settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    if (data != null) {
      dataMap['data'] = data!.map((v) => v.toJson()).toList();
    }
    dataMap['total_time'] = totalTime;
    if (settings != null) {
      dataMap['settings'] = settings!.toJson();
    }
    return dataMap;
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
    return {
      'id': id,
      'member': member,
      'task': task,
      'start_time': startTime,
      'end_time': endTime,
      'note': note,
      'total': total,
      'image': image,
    };
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
    return {
      'success': success,
      'message': message,
      'status': status,
    };
  }
}
