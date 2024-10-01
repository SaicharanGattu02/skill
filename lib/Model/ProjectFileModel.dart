class FileModel {
  List<Data>? data;
  Settings? settings;

  FileModel({this.data, this.settings});

  FileModel.fromJson(Map<String, dynamic> json) {
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
  String? uploadedBy;
  String? uploadedByImage;
  String? fileUrl;
  String? fileName;
  String? fileExtension;
  String? description;
  String? category;
  String? categoryId;
  String? size;
  String? createdTime;

  Data(
      {this.id,
        this.uploadedBy,
        this.uploadedByImage,
        this.fileUrl,
        this.fileName,
        this.fileExtension,
        this.description,
        this.category,
        this.categoryId,
        this.size,
        this.createdTime});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uploadedBy = json['uploaded_by'];
    uploadedByImage = json['uploaded_by_image'];
    fileUrl = json['file_url'];
    fileName = json['file_name'];
    fileExtension = json['file_extension'];
    description = json['description'];
    category = json['category'];
    categoryId = json['category_id'];
    size = json['size'];
    createdTime = json['created_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uploaded_by'] = this.uploadedBy;
    data['uploaded_by_image'] = this.uploadedByImage;
    data['file_url'] = this.fileUrl;
    data['file_name'] = this.fileName;
    data['file_extension'] = this.fileExtension;
    data['description'] = this.description;
    data['category'] = this.category;
    data['category_id'] = this.categoryId;
    data['size'] = this.size;
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
