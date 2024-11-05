class RoomsDetailsModel {
  Data? data;
  Settings? settings;

  RoomsDetailsModel({this.data, this.settings});

  RoomsDetailsModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.settings != null) {
      data['settings'] = this.settings!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? userId;
  String? userName;
  String? userImage;
  List<Messages>? messages;

  Data({this.id, this.userId, this.userName, this.userImage, this.messages});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userName = json['user_name'];
    userImage = json['user_image'];
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(new Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  String? id;
  String? sentUser;
  String? msg;
  String? lastUpdated;
  int? unixTimestamp;
  String? msgType;
  bool? isRead;
  List<Media>? media;

  Messages(
      {this.id,
        this.sentUser,
        this.msg,
        this.lastUpdated,
        this.unixTimestamp,
        this.msgType,
        this.isRead,
        this.media});

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sentUser = json['sent_user'];
    msg = json['msg'];
    lastUpdated = json['last_updated'];
    unixTimestamp = json['unix_timestamp'];
    msgType = json['msg_type'];
    isRead = json['is_read'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sent_user'] = this.sentUser;
    data['msg'] = this.msg;
    data['last_updated'] = this.lastUpdated;
    data['unix_timestamp'] = this.unixTimestamp;
    data['msg_type'] = this.msgType;
    data['is_read'] = this.isRead;
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Media {
  String? id;
  String? room;
  String? file;
  String? fileSize;
  String? contentType;
  bool? isActive;

  Media(
      {this.id,
        this.room,
        this.file,
        this.fileSize,
        this.contentType,
        this.isActive});

  Media.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    room = json['room'];
    file = json['file'];
    fileSize = json['file_size'];
    contentType = json['content_type'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['room'] = this.room;
    data['file'] = this.file;
    data['file_size'] = this.fileSize;
    data['content_type'] = this.contentType;
    data['is_active'] = this.isActive;
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
