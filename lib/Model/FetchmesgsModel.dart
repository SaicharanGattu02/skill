class FetchmesgsModel {
  List<Message>? data;
  Settings? settings;

  FetchmesgsModel({this.data, this.settings});

  FetchmesgsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Message>[];
      json['data'].forEach((v) {
        data!.add(new Message.fromJson(v));
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

class Message {
  String? id;
  String? sentUser;
  String? msg;
  String? lastUpdated;
  int? unixTimestamp;
  bool? isRead;

  Message(
      {this.id,
        this.sentUser,
        this.msg,
        this.lastUpdated,
        this.unixTimestamp,
        this.isRead});

  Message.fromJson(Map<String, dynamic> json) {
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
