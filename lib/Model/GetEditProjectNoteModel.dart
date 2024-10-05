class GetEditProjectNoteModel {
  EditData? editData;
  Settings? settings;

  GetEditProjectNoteModel({this.editData, this.settings});

  GetEditProjectNoteModel.fromJson(Map<String, dynamic> json) {
    editData = json['data'] != null ? new EditData.fromJson(json['data']) : null;
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.editData != null) {
      data['data'] = this.editData!.toJson();
    }
    if (this.settings != null) {
      data['settings'] = this.settings!.toJson();
    }
    return data;
  }
}

class EditData {
  String? id;
  String? title;
  String? description;
  String? file;
  String? createdTime;

  EditData({this.id, this.title, this.description, this.file, this.createdTime});

  EditData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    file = json['file'];
    createdTime = json['created_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['file'] = this.file;
    data['created_time'] = this.createdTime;
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
