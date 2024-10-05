class LeaveRequestModel {
  int? success;
  String? message;
  Data? data;

  LeaveRequestModel({this.success, this.message, this.data});

  LeaveRequestModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] as int?;
    message = json['message'] as String?;
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = {};
    jsonData['success'] = success;
    jsonData['message'] = message;
    if (data != null) {
      jsonData['data'] = data!.toJson();
    }
    return jsonData;
  }
}

class Data {
  String? leaveType;
  String? leaveStatus;
  DateTime? leaveStartDate;
  DateTime? leaveEndDate;

  Data({
    this.leaveType,
    this.leaveStatus,
    this.leaveStartDate,
    this.leaveEndDate,
  });

  Data.fromJson(Map<String, dynamic> json) {
    leaveType = json['leaveType'] as String?;
    leaveStatus = json['leaveStatus'] as String?;
    leaveStartDate = json['leaveStartDate'] != null
        ? DateTime.parse(json['leaveStartDate'])
        : null;
    leaveEndDate = json['leaveEndDate'] != null
        ? DateTime.parse(json['leaveEndDate'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = {};
    jsonData['leaveType'] = leaveType;
    jsonData['leaveStatus'] = leaveStatus;
    jsonData['leaveStartDate'] = leaveStartDate?.toIso8601String();
    jsonData['leaveEndDate'] = leaveEndDate?.toIso8601String();
    return jsonData;
  }
}
