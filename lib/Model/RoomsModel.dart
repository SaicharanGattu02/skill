class RoomsModel {
  List<Rooms> data;
  Settings? settings;

  RoomsModel({required this.data, this.settings});

  RoomsModel.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as List?)?.map((v) => Rooms.fromJson(v)).toList() ?? [],
        settings = json['settings'] != null ? Settings.fromJson(json['settings']) : null;

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((room) => room.toJson()).toList(),
      'settings': settings?.toJson(),
    };
  }
}

class Rooms {
  String roomId;
  String otherUserId;
  String? otherUser; // This can be null
  String? otherUserImage; // This can be null
  String? message; // This can be null
  String? sentUser; // This can be null
  String? sentUserId; // This can be null
  String? messageSent; // This can be null
  int? messageTime; // This can be null
  int messageCount;

  Rooms({
    required this.roomId,
    required this.otherUserId,
    this.otherUser,
    this.otherUserImage,
    this.message,
    this.sentUser,
    this.sentUserId,
    this.messageSent,
    this.messageTime,
    this.messageCount = 0,
  });

  Rooms.fromJson(Map<String, dynamic> json)
      : roomId = json['room_id'],
        otherUserId = json['other_user_id'],
        otherUser = json['other_user'],
        otherUserImage = json['other_user_image'],
        message = json['message'],
        sentUser = json['sent_user'],
        sentUserId = json['sent_user_id'],
        messageSent = json['message_sent'],
        messageTime = json['message_time'],
        messageCount = json['message_count'] ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'room_id': roomId,
      'other_user_id': otherUserId,
      'other_user': otherUser,
      'other_user_image': otherUserImage,
      'message': message,
      'sent_user': sentUser,
      'sent_user_id': sentUserId,
      'message_sent': messageSent,
      'message_time': messageTime,
      'message_count': messageCount,
    };
  }
}

class Settings {
  int success;
  String? message;
  int? status;

  Settings({required this.success, this.message, this.status});

  Settings.fromJson(Map<String, dynamic> json)
      : success = json['success'],
        message = json['message'],
        status = json['status'];

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'status': status,
    };
  }
}
