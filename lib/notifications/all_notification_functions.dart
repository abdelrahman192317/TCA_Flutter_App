
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationsHandler {

  // Initialize Flutter Local Notifications plugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationsHandler(this.flutterLocalNotificationsPlugin) {
    subscribeToToken();
  }

  subscribeToToken(){
    FirebaseMessaging.instance.subscribeToTopic('Admin');
  }

  Future<void> showNotification(String? title, String? body) async {
    const androidDetails = AndroidNotificationDetails(
        'danger_channel_id',
        'danger_channel_name',
        playSound: true,
        sound: RawResourceAndroidNotificationSound('model_alarm'),
        importance: Importance.max,
        priority: Priority.high
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  }

  Future<void> scheduleDatesNotification(String dateId, int id ,DateTime dateTime, String title, String desc) async {

    // Define the notification details
    const androidDetails = AndroidNotificationDetails(
      'dates-channel-id', // channel ID
      'dates-channel-name', // channel name
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification_alarm'),
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    // Define the date and time when the alarm should trigger
    // Initialize time zone data
    tz.initializeTimeZones();
    // Convert the scheduled date and time to the local time zone
    final scheduledDate = tz.TZDateTime.from(dateTime,tz.local);

    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id, // Notification ID
      title, // Notification title
      desc, // Notification body
      scheduledDate, // Scheduled date and time in the local time zone
      notificationDetails,
      payload: json.encode(<String, dynamic> {
        'id': dateId,
        'dateTime': dateTime.toIso8601String(),
      }),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, // Allow delivery while device is idle
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> scheduleRepeatsNotification() async {

    // Define the notification details
    const androidDetails = AndroidNotificationDetails(
      'repeat-channel-id', // channel ID
      'repeat-channel-name', // channel name
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alarm'),
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    // Schedule the notification to repeat every 11 hours
    await flutterLocalNotificationsPlugin.periodicallyShow(
      1, // Notification ID
      'Hello Sir, This Message Is For Social Reminder', // Notification title
      'Please Try to Talk to Someone or Call Another ^_^', // Notification body
      RepeatInterval.hourly,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

}