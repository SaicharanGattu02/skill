class Get_Color_Response {
  List<ColorItem>? colorItem;
  Settings? settings;

  Get_Color_Response({this.colorItem, this.settings});

  Get_Color_Response.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      colorItem = <ColorItem>[];
      json['data'].forEach((v) {
        colorItem!.add(new ColorItem.fromJson(v));
      });
    }
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.colorItem != null) {
      data['data'] = this.colorItem!.map((v) => v.toJson()).toList();
    }
    if (this.settings != null) {
      data['settings'] = this.settings!.toJson();
    }
    return data;
  }
}

class ColorItem {
  String? colorName;
  String? colorCode;

  ColorItem({this.colorName, this.colorCode});

  ColorItem.fromJson(Map<String, dynamic> json) {
    colorName = json['color_name'];
    colorCode = json['color_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['color_name'] = this.colorName;
    data['color_code'] = this.colorCode;
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
