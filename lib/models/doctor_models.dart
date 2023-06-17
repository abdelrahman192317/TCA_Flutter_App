import 'dart:convert';

import 'package:flutter/material.dart';

import '../notifications/all_notification_functions.dart';

class DDate {
  DateTime dateTime;
  bool done;
  bool archived;

  DDate({
    required this.dateTime,
    this.done = false,
    this.archived = false
  });

  factory DDate.fromMap(Map<String, dynamic> map) {
    return DDate(
      dateTime: map['dateTime'] == null ?
      DateTime.now() : DateTime.parse(map['dateTime'] as String),
      done: map['done'] ?? false,
      archived: map['archived'] ?? false,
    );
  }

  static Map<String, dynamic> toMap(DDate dDate) => {
    "dateTime": dDate.dateTime.toIso8601String(),
    "done": dDate.done,
    "archived": dDate.archived,
  };

  static String encode(List<DDate> ddList) => json.encode(
      ddList.map<Map<String, dynamic>>((dd) => DDate.toMap(dd)).toList());

  static List<DDate> decode(String ddList) => ((json.decode(ddList))
      .map((item) => item as Map<String, dynamic>).toList())
      .map<DDate>((item) => DDate.fromMap(item)).toList();
}

class DoctorDates {
  String doctorId;
  String doctorName;
  String type;
  String phoneNumber;
  String location;
  DateTime? dateTime;
  int done;
  int archived;
  List<DDate>? datesList;

  DoctorDates({
    this.doctorId = "",
    this.doctorName = "",
    this.type = '',
    this.phoneNumber = '',
    this.location = '',
    required this.dateTime,
    this.done = 0,
    this.archived = 0,
    this.datesList,
    NotificationsHandler? notificationsHandler
  }){
    if(datesList == null){
      doctorId = UniqueKey().toString();
      datesList = [DDate(dateTime: dateTime!)];
      notificationsHandler!.scheduleDatesNotification(
        doctorId,
        dateTime!.day + dateTime!.hour + dateTime!.minute,
        dateTime!, 'Doctor $doctorName Date',
        'This Is Reminder for Your Date With Doctor $doctorName'
      );
    }
  }

  doneDate() {
    datesList![archived].done = true;
    datesList![archived].archived = true;
    ++done;
    ++archived;
  }

  archiveDate(DateTime date) {
    datesList!.firstWhere((element) => element.dateTime == date).archived = true;
    ++archived;
  }

  delete(DateTime date) {
    if(datesList!.firstWhere((element) => element.dateTime == date).done) {
      --done; --archived;
    } else if(datesList!.firstWhere((element) => element.dateTime == date).archived) {
      --archived;
    }
    datesList!.removeWhere((element) => element.dateTime == date);
  }

  addDate({required DateTime date, required NotificationsHandler notificationsHandler}) {
    datesList!.add(DDate(dateTime: date));
    datesList!.sort((a,b) => a.dateTime.compareTo(b.dateTime));

    notificationsHandler.scheduleDatesNotification(
      doctorId, (date.day + date.hour + date.minute),
      date, 'Doctor $doctorName Date',
      'This Is Reminder for Your Date With Doctor $doctorName'
    );
  }


  factory DoctorDates.fromMap(Map<String, dynamic> map) {
    return DoctorDates(
        doctorId: map['doctorId'] ?? '',
        doctorName: map['doctorName'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        type: map['type'] ?? '',
        dateTime: map['dateTime'] == null ?
        DateTime.now() : DateTime.parse(map['dateTime'] as String),
        location: map['location'] ?? '',
        done: map['done'] ?? 0,
        archived: map['archived'] ?? 0,
        datesList: map['datesList'] == null ? [] : DDate.decode(
            map['datesList'])
    );
  }

  static Map<String, dynamic> toMap(DoctorDates doctorDates) =>
      {
        "doctorId": doctorDates.doctorId,
        "doctorName": doctorDates.doctorName,
        "phoneNumber": doctorDates.phoneNumber,
        "type": doctorDates.type,
        "location": doctorDates.location,
        "dateTime": doctorDates.dateTime?.toIso8601String(),
        "done": doctorDates.done,
        "archived": doctorDates.archived,
        "datesList": DDate.encode(doctorDates.datesList!)
      };

  static String encode(List<DoctorDates> ddsList) =>
      json.encode(
          ddsList.map<Map<String, dynamic>>((dds) => DoctorDates.toMap(dds))
              .toList());

  static List<DoctorDates> decode(String ddsList) => ((json.decode(ddsList))
          .map((item) => item as Map<String, dynamic>).toList())
          .map<DoctorDates>((item) => DoctorDates.fromMap(item)).toList();
}

class DDateCard {
  String doctorId = '';
  String doctorName = '';
  String type = '';
  String location = '';
  DateTime? dateTime;
  int done = 0;
  int archived = 0;

  DDateCard({
    required DoctorDates dds,
    required this.dateTime,
  }) {
    doctorId = dds.doctorId;
    doctorName = dds.doctorName;
    type = dds.type;
    location = dds.location;
    done = dds.done;
    archived = dds.archived;
  }
}