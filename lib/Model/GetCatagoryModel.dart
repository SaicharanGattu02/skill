class GetCatagoryModel {
  List<Catagory>? catagory;
  Settings? settings;

  GetCatagoryModel({this.catagory, this.settings});

  GetCatagoryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      catagory = <Catagory>[];
      json['data'].forEach((v) {
        catagory!.add(new Catagory.fromJson(v));
      });
    }
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.catagory != null) {
      data['data'] = this.catagory!.map((v) => v.toJson()).toList();
    }
    if (this.settings != null) {
      data['settings'] = this.settings!.toJson();
    }
    return data;
  }
}

class Catagory {
  String? id;
  String? name;
  String? createdTime;

  Catagory({this.id, this.name, this.createdTime});

  Catagory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdTime = json['created_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
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
