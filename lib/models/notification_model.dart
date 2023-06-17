import 'dart:convert';

class NotificationCard {
  String notificationId;
  String title;
  String body;
  DateTime? dateTime;

  NotificationCard({
    this.notificationId = "",
    this.title = "",
    this.body = "",
    this.dateTime
  });

  factory NotificationCard.fromMap(Map<String, dynamic> map) {
    return NotificationCard(
      notificationId: map['notificationId'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      dateTime: map['dateTime'] == null ?
      DateTime.now() : DateTime.parse(map['dateTime'] as String),
    );
  }

  static Map<String, dynamic> toMap(NotificationCard notification) => {
    "notificationId": notification.notificationId,
    "title": notification.title,
    "body": notification.body,
    "dateTime": notification.dateTime?.toIso8601String(),
  };

  static String encode(List<NotificationCard> nList) => json.encode(
      nList.map<Map<String, dynamic>>((n) => NotificationCard.toMap(n)).toList());

  static List<NotificationCard> decode(String nList) => ((json.decode(nList))
      .map((item) => item as Map<String, dynamic>).toList())
      .map<NotificationCard>((item) => NotificationCard.fromMap(item)).toList();

}
