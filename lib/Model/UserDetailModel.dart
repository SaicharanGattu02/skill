class UserDetailModel {
  Data? data;
  Settings? settings;

  UserDetailModel({this.data, this.settings});

  UserDetailModel.fromJson(Map<String, dynamic> json) {
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
  String? fullName;
  String? image;
  String? email;
  String? status;
  String? mobile;

  Data(
      {this.id,
        this.fullName,
        this.image,
        this.email,
        this.status,
        this.mobile});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['name'];
    image = json['image'];
    email = json['email'];
    status = json['status'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.fullName;
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
