class CreateRoomModel {
  Data? data;
  Settings? settings;

  CreateRoomModel({this.data, this.settings});

  CreateRoomModel.fromJson(Map<String, dynamic> json) {
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
  String? room;
  List<Messages>? messages;
  OtherUser? otherUser;

  Data({this.room, this.messages, this.otherUser});

  Data.fromJson(Map<String, dynamic> json) {
    room = json['room'];
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(new Messages.fromJson(v));
      });
    }
    otherUser = json['other_user'] != null
        ? new OtherUser.fromJson(json['other_user'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room'] = this.room;
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    if (this.otherUser != null) {
      data['other_user'] = this.otherUser!.toJson();
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
  bool? isRead;

  Messages(
      {this.id,
        this.sentUser,
        this.msg,
        this.lastUpdated,
        this.unixTimestamp,
        this.isRead});

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sentUser = json['sent_user'];
    msg = json['msg'];
    lastUpdated = json['last_updated'];
    unixTimestamp = json['unix_timestamp'];
    isRead = json['is_read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sent_user'] = this.sentUser;
    data['msg'] = this.msg;
    data['last_updated'] = this.lastUpdated;
    data['unix_timestamp'] = this.unixTimestamp;
    data['is_read'] = this.isRead;
    return data;
  }
}

class OtherUser {
  String? id;
  String? fullName;
  String? image;
  String? email;
  String? status;
  String? mobile;

  OtherUser(
      {this.id,
        this.fullName,
        this.image,
        this.email,
        this.status,
        this.mobile});

  OtherUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    image = json['image'];
    email = json['email'];
    status = json['status'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['image'] = this.image;
    data['email'] = this.email;
    data['status'] = this.status;
    data['mobile'] = this.mobile;
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
