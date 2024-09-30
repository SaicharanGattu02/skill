class TasklistModel {
  List<Data>? data;
  Settings? settings;

  TasklistModel({this.data, this.settings});

  TasklistModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? id;
  String? title;
  String? description;
  String? startDate;
  String? endDate;
  String? milestone;
  String? assignedTo;
  String? assignedToImage;
  List<Collaborators>? collaborators;
  String? status;

  Data(
      {this.id,
        this.title,
        this.description,
        this.startDate,
        this.endDate,
        this.milestone,
        this.assignedTo,
        this.assignedToImage,
        this.collaborators,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    milestone = json['milestone'];
    assignedTo = json['assigned_to'];
    assignedToImage = json['assigned_to_image'];
    if (json['collaborators'] != null) {
      collaborators = <Collaborators>[];
      json['collaborators'].forEach((v) {
        collaborators!.add(new Collaborators.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['milestone'] = this.milestone;
    data['assigned_to'] = this.assignedTo;
    data['assigned_to_image'] = this.assignedToImage;
    if (this.collaborators != null) {
      data['collaborators'] =
          this.collaborators!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
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
  int? page;
  bool? nextPage;
  bool? prevPage;

  Settings(
      {this.success,
        this.message,
        this.status,
        this.page,
        this.nextPage,
        this.prevPage});

  Settings.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    status = json['status'];
    page = json['page'];
    nextPage = json['next_page'];
    prevPage = json['prev_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['status'] = this.status;
    data['page'] = this.page;
    data['next_page'] = this.nextPage;
    data['prev_page'] = this.prevPage;
    return data;
  }
}
