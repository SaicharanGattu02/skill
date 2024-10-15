class TasklistModel {
  List<Data>? data;
  Settings? settings;

  TasklistModel({this.data, this.settings});

  TasklistModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] is List) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    } else if (json['data'] != null) {
      // Handle the case where data is not a list but not null
      print("Data is not a list: ${json['data']}");
      // Optionally, you can initialize data as an empty list
      data = [];
    }
    settings = json['settings'] != null ? Settings.fromJson(json['settings']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
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
        collaborators!.add(Collaborators.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['milestone'] = milestone;
    data['assigned_to'] = assignedTo;
    data['assigned_to_image'] = assignedToImage;
    if (collaborators != null) {
      data['collaborators'] = collaborators!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
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
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['full_name'] = fullName;
    data['image'] = image;
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

  Settings({this.success, this.message, this.status, this.page, this.nextPage, this.prevPage});

  Settings.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    status = json['status'];
    page = json['page'];
    nextPage = json['next_page'];
    prevPage = json['prev_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    data['status'] = status;
    data['page'] = page;
    data['next_page'] = nextPage;
    data['prev_page'] = prevPage;
    return data;
  }
}
