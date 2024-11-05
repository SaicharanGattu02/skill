class EmployeeListModel {
  List<Employeedata>? data;
  Settings? settings;

  EmployeeListModel({this.data, this.settings});

  EmployeeListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Employeedata>[];
      json['data'].forEach((v) {
        data!.add(new Employeedata.fromJson(v));
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

class Employeedata {
  String? id;
  String? name;
  String? image;
  String? email;
  String? status;
  String? mobile;
  String? room_id;

  Employeedata(
      {this.id,
        this.name,
        this.image,
        this.email,
        this.status,
        this.room_id,
        this.mobile});

  Employeedata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    email = json['email'];
    status = json['status'];
    mobile = json['mobile'];
    room_id = json['room_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['email'] = this.email;
    data['status'] = this.status;
    data['mobile'] = this.mobile;
    data['room_id'] = this.room_id;
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


class User {
  final String name;
  final String id;

  User({required this.name, required this.id});

  @override
  String toString() {
    return 'User(name: $name, id: $id)';
  }
}
