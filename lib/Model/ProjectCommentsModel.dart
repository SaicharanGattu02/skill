class ProjectCommentsModel {
  List<Data>? data;
  Settings? settings;

  ProjectCommentsModel({this.data, this.settings});

  ProjectCommentsModel.fromJson(Map<String, dynamic> json) {
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
  String? commentBy;
  String? commentByImage;
  String? comment;
  List<CommentFiles>? commentFiles;
  String? createdTime;

  Data(
      {this.id,
        this.commentBy,
        this.commentByImage,
        this.comment,
        this.commentFiles,
        this.createdTime});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commentBy = json['comment_by'];
    commentByImage = json['comment_by_image'];
    comment = json['comment'];
    if (json['comment_files'] != null) {
      commentFiles = <CommentFiles>[];
      json['comment_files'].forEach((v) {
        commentFiles!.add(new CommentFiles.fromJson(v));
      });
    }
    createdTime = json['created_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment_by'] = this.commentBy;
    data['comment_by_image'] = this.commentByImage;
    data['comment'] = this.comment;
    if (this.commentFiles != null) {
      data['comment_files'] =
          this.commentFiles!.map((v) => v.toJson()).toList();
    }
    data['created_time'] = this.createdTime;
    return data;
  }
}

class CommentFiles {
  String? id;
  String? file;
  String? fileName;
  String? fileExtension;
  String? fileSize;

  CommentFiles(
      {this.id, this.file, this.fileName, this.fileExtension, this.fileSize});

  CommentFiles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    file = json['file'];
    fileName = json['file_name'];
    fileExtension = json['file_extension'];
    fileSize = json['file_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['file'] = this.file;
    data['file_name'] = this.fileName;
    data['file_extension'] = this.fileExtension;
    data['file_size'] = this.fileSize;
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
