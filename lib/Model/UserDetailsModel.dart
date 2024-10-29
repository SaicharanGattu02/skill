class UserDetailsModel {
  UserData? data;
  Settings? settings;

  UserDetailsModel({this.data, this.settings});

  UserDetailsModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new UserData.fromJson(json['data']) : null;
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

class UserData {
  String? id;
  String? fullName;
  String? image;
  String? email;
  String? status;
  String? mobile;
  String? userNumber;
  String? gender;
  Employee? employee;
  int? projectCount;
  int? todoCount;
  int? tasksCount;
  int? meetingCount;

  UserData(
      {this.id,
        this.fullName,
        this.image,
        this.email,
        this.status,
        this.mobile,
        this.userNumber,
        this.gender,
        this.employee,
        this.projectCount,
        this.todoCount,
        this.tasksCount,
        this.meetingCount});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    image = json['image'];
    email = json['email'];
    status = json['status'];
    mobile = json['mobile'];
    userNumber = json['user_number'];
    gender = json['gender'];
    employee = json['employee'] != null
        ? new Employee.fromJson(json['employee'])
        : null;
    projectCount = json['project_count'];
    todoCount = json['todo_count'];
    tasksCount = json['tasks_count'];
    meetingCount = json['meeting_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['image'] = this.image;
    data['email'] = this.email;
    data['status'] = this.status;
    data['mobile'] = this.mobile;
    data['user_number'] = this.userNumber;
    data['gender'] = this.gender;
    if (this.employee != null) {
      data['employee'] = this.employee!.toJson();
    }
    data['project_count'] = this.projectCount;
    data['todo_count'] = this.todoCount;
    data['tasks_count'] = this.tasksCount;
    data['meeting_count'] = this.meetingCount;
    return data;
  }
}

class Employee {
  String? id;
  Company? company;
  String? email;
  String? joiningDate;
  String? designation;
  String? resignedDate;
  String? releasedDate;
  bool? isReleased;
  String? lastUpdated;

  Employee(
      {this.id,
        this.company,
        this.email,
        this.joiningDate,
        this.designation,
        this.resignedDate,
        this.releasedDate,
        this.isReleased,
        this.lastUpdated});

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    company =
    json['company'] != null ? new Company.fromJson(json['company']) : null;
    email = json['email'];
    joiningDate = json['joining_date'];
    designation = json['designation'];
    resignedDate = json['resigned_date'];
    releasedDate = json['released_date'];
    isReleased = json['is_released'];
    lastUpdated = json['last_updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.company != null) {
      data['company'] = this.company!.toJson();
    }
    data['email'] = this.email;
    data['joining_date'] = this.joiningDate;
    data['designation'] = this.designation;
    data['resigned_date'] = this.resignedDate;
    data['released_date'] = this.releasedDate;
    data['is_released'] = this.isReleased;
    data['last_updated'] = this.lastUpdated;
    return data;
  }
}

class Company {
  String? id;
  String? name;
  String? address;
  String? city;
  int? staff;
  String? lastUpdated;

  Company(
      {this.id,
        this.name,
        this.address,
        this.city,
        this.staff,
        this.lastUpdated});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    city = json['city'];
    staff = json['staff'];
    lastUpdated = json['last_updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['city'] = this.city;
    data['staff'] = this.staff;
    data['last_updated'] = this.lastUpdated;
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
