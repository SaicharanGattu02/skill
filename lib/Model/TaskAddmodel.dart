class TaskAddmodel {
  final Map<String, dynamic> data;
  final Settings settings;

  TaskAddmodel({required this.data, required this.settings});

  factory TaskAddmodel.fromJson(Map<String, dynamic> json) {
    return TaskAddmodel(
      data: json['data'] ?? {},
      settings: Settings.fromJson(json['settings']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'settings': settings.toJson(),
    };
  }
}

class Settings {
  final int success;
  final String message;
  final int status;

  Settings({required this.success, required this.message, required this.status});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      success: json['success'] ?? 1,
      message: json['message'] ?? 'Data saved successfully.',
      status: json['status'] ?? 200,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'status': status,
    };
  }
}
