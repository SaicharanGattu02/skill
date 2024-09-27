class GetLeaveModel {
  int? success;
  String? message;
  List<Data>? data;

  GetLeaveModel({this.success, this.message, this.data});

  GetLeaveModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? fromDate;
  String? toDate;
  String? reason;
  String? leaveType;
  String? status;
  String? fromDayType;
  String? toDayType;
  String? dayCount;

  Data(
      {this.fromDate,
        this.toDate,
        this.reason,
        this.leaveType,
        this.status,
        this.fromDayType,
        this.toDayType,
        this.dayCount});

  Data.fromJson(Map<String, dynamic> json) {
    fromDate = json['from_date'];
    toDate = json['to_date'];
    reason = json['reason'];
    leaveType = json['leave_type'];
    status = json['status'];
    fromDayType = json['from_day_type'];
    toDayType = json['to_day_type'];

    // Handling both String and int for day_count
    dayCount = json['day_count'] != null ? json['day_count'].toString() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['reason'] = this.reason;
    data['leave_type'] = this.leaveType;
    data['status'] = this.status;
    data['from_day_type'] = this.fromDayType;
    data['to_day_type'] = this.toDayType;
    data['day_count'] = this.dayCount;
    return data;
  }
}

