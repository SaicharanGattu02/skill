class GetTaskDetailModel {
  TaskDetail? taskDetail;
  Settings? settings;

  GetTaskDetailModel({this.taskDetail, this.settings});

  GetTaskDetailModel.fromJson(Map<String, dynamic> json) {
    taskDetail = json['data'] != null ? new TaskDetail.fromJson(json['data']) : null;
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.taskDetail != null) {
      data['data'] = this.taskDetail!.toJson();
    }
    if (this.settings != null) {
      data['settings'] = this.settings!.toJson();
    }
    return data;
  }
}

class TaskDetail {
  String? id;
  String? title;
  String? description;
  String? points;
  String? milestone;
  String? assignedToId;
  String? assignedTo;
  String? assignedToImage;
  List<Collaborators>? collaborators;
  String? status;
  String? priority;
  String? startDate;
  String? endDate;

  TaskDetail(
      {this.id,
        this.title,
        this.description,
        this.points,
        this.milestone,
        this.assignedToId,
        this.assignedTo,
        this.assignedToImage,
        this.collaborators,
        this.status,
        this.priority,
        this.startDate,
        this.endDate});

  TaskDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    points = json['points'];
    milestone = json['milestone'];
    assignedToId = json['assigned_to_id'];
    assignedTo = json['assigned_to'];
    assignedToImage = json['assigned_to_image'];
    if (json['collaborators'] != null) {
      collaborators = <Collaborators>[];
      json['collaborators'].forEach((v) {
        collaborators!.add(new Collaborators.fromJson(v));
      });
    }
    status = json['status'];
    priority = json['priority'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['points'] = this.points;
    data['milestone'] = this.milestone;
    data['assigned_to_id'] = this.assignedToId;
    data['assigned_to'] = this.assignedTo;
    data['assigned_to_image'] = this.assignedToImage;
    if (this.collaborators != null) {
      data['collaborators'] =
          this.collaborators!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['priority'] = this.priority;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    return data;
  }
}

class Collaborators {
  String? id;
  String? fullName;
  String? image;

  Collaborators({this.id, this.fullName, this.image});

  Collaborators.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
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
