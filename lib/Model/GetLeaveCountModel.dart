class GetLeaveCountModel {
  int? success;
  String? message;
  Count? data;

  GetLeaveCountModel({this.success, this.message, this.data});

  GetLeaveCountModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Count.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Count {
  Null? availableLeaves;
  int? rejectedLeaves;
  int? pendingLeaves;
  Null? unusedLeaves;

  Count(
      {this.availableLeaves,
        this.rejectedLeaves,
        this.pendingLeaves,
        this.unusedLeaves});

  Count.fromJson(Map<String, dynamic> json) {
    availableLeaves = json['available_leaves'];
    rejectedLeaves = json['rejected_leaves'];
    pendingLeaves = json['pending_leaves'];
    unusedLeaves = json['unused_leaves'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['available_leaves'] = this.availableLeaves;
    data['rejected_leaves'] = this.rejectedLeaves;
    data['pending_leaves'] = this.pendingLeaves;
    data['unused_leaves'] = this.unusedLeaves;
    return data;
  }
}
