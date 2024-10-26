class MeetingProviders {
  List<Providers>? data;
  Settings? settings;

  MeetingProviders({this.data, this.settings});

  MeetingProviders.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Providers>[];
      json['data'].forEach((v) {
        data!.add(new Providers.fromJson(v));
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

class Providers {
  String? providerKey;
  String? providerValue;

  Providers({this.providerKey, this.providerValue});

  Providers.fromJson(Map<String, dynamic> json) {
    providerKey = json['provider_key'];
    providerValue = json['provider_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['provider_key'] = this.providerKey;
    data['provider_value'] = this.providerValue;
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
