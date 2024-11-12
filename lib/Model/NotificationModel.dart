class NotificationModel {
  int? id;
  String? title;
  String? body;

  // Constructor
  NotificationModel({
    this.id,
    this.title,
    this.body,
  });

  // Convert a NotificationModel object to a Map to insert into SQLite
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
    };
  }

  // Create a NotificationModel object from a Map
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      title: map['title'],
      body: map['body'],
    );
  }
}
