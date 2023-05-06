import 'dart:convert';

import 'package:flutter/material.dart';

class MDate {
  DateTime dateTime;
  bool done;
  bool archived;

  MDate({
    required this.dateTime,
    this.done = false,
    this.archived = false
  });

  factory MDate.fromMap(Map<String, dynamic> map) {
    return MDate(
        dateTime: map['dateTime'] == null ?
        DateTime.now() : DateTime.parse(map['dateTime'] as String),
        done: map['done']  == null ? false :
        map['done'] == 'false' ? false : true,
        archived: map['archived']  == null ? false :
        map['archived'] == 'false' ? false : true,
    );
  }

  static Map<String, dynamic> toMap(MDate mDate) => {
    "dateTime": mDate.dateTime.toIso8601String(),
    "done": mDate.done,
    "archived": mDate.archived,
  };

  static String encode(List<MDate> mdList) => json.encode(
      mdList.map<Map<String, dynamic>>((md) => MDate.toMap(md)).toList());

  static List<MDate> decode(String mdList) => ((json.decode(mdList))
      .map((item) => item as Map<String, dynamic>).toList())
      .map<MDate>((item) => MDate.fromMap(item)).toList();
}


class MedicationDates {
  String medicineId;
  String medicineName;
  String desc;
  String type;
  String doctorName;
  String imageUrl;
  DateTime startDateTime;
  DateTime? dateTime;
  DateTime? endDateTime;
  int repeatInDay;
  int daysNum;
  int done;
  int archived;
  List<MDate>? datesList;

  MedicationDates({
    this.medicineId = "",
    this.medicineName = "",
    this.desc = '',
    this.type = '',
    this.doctorName = '',
    this.imageUrl = '',
    required this.startDateTime,
    this.dateTime,
    this.endDateTime,
    this.repeatInDay = 0,
    this.daysNum = 0,
    this.done = 0,
    this.archived = 0,
    this.datesList = const []
  }){
    if(datesList!.isEmpty){
      medicineId = UniqueKey().toString();
      int i = daysNum * repeatInDay;
      if(i != 0){
        datesList = [];
        for(int j = 0; j < i; j++) {
          endDateTime = startDateTime;
          datesList!.add(MDate(dateTime: endDateTime!.add(Duration(hours: (24~/repeatInDay) * j))));
        }
      }
      else {
        datesList = [MDate(dateTime: startDateTime)];
      }
      endDateTime = datesList![datesList!.length - 1].dateTime;
    }
  }

  archiveDate(DateTime date) {
    datesList!.firstWhere((element) => element.dateTime == date).archived = true;
    ++archived;
  }

  doneDate() {
    datesList![archived].done = true;
    datesList![archived].archived = true;
    ++done;
    ++archived;
  }

  delete(DateTime date) {
    if(datesList!.firstWhere((element) => element.dateTime == date).done)--done;
    if(datesList!.firstWhere((element) => element.dateTime == date).archived)--archived;
    datesList!.removeWhere((element) => element.dateTime == date);
  }

  factory MedicationDates.fromMap(Map<String, dynamic> map) {
    return MedicationDates(
      medicineId: map['dateId'] ?? '',
      medicineName: map['medicineName'] ?? '',
      desc: map['desc'] ?? '',
      type: map['type'] ?? '',
      doctorName: map['doctorName'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      startDateTime: map['startDateTime'] == null ?
        DateTime.now() : DateTime.parse(map['startDateTime'] as String),
      dateTime: map['dateTime'] == null ?
        DateTime.now() : DateTime.parse(map['dateTime'] as String),
      endDateTime: map['endDateTime'] == null ?
        DateTime.now() : DateTime.parse(map['endDateTime'] as String),
      repeatInDay: map['repeatInDay'] ?? 0,
      daysNum: map['daysNum'] ?? 0,
      done: map['done'] ?? 0,
      archived: map['archived'] ?? 0,
      datesList: map['datesList'] == null ? [] : MDate.decode(map['datesList'])
    );
  }

  static Map<String, dynamic> toMap(MedicationDates medicationDates) => {
    "dateId": medicationDates.medicineId,
    "medicineName": medicationDates.medicineName,
    "desc": medicationDates.desc,
    "type": medicationDates.type,
    "doctorName" : medicationDates.doctorName,
    "imageUrl": medicationDates.imageUrl,
    "startDateTime": medicationDates.startDateTime.toIso8601String(),
    "recentDateTime": medicationDates.dateTime?.toIso8601String(),
    "endDateTime": medicationDates.endDateTime?.toIso8601String(),
    "repeatInDay": medicationDates.repeatInDay,
    "daysNum": medicationDates.daysNum,
    "done": medicationDates.done,
    "archived": medicationDates.archived,
    "datesList" : MDate.encode(medicationDates.datesList!)
  };

  static String encode(List<MedicationDates> mdsList) => json.encode(
      mdsList.map<Map<String, dynamic>>((mds) => MedicationDates.toMap(mds)).toList());

  static List<MedicationDates> decode(String mdsList) => ((json.decode(mdsList))
      .map((item) => item as Map<String, dynamic>).toList())
      .map<MedicationDates>((item) => MedicationDates.fromMap(item)).toList();
}

class MDateCard {
  String medicineId = '';
  String medicineName = '';
  String desc = '';
  String type = '';
  String doctorName = '';
  String imageUrl = '';
  DateTime? dateTime;
  int done = 0;
  int notDone = 0;
  int archived = 0;

  MDateCard({
    required MedicationDates mds,
    this.dateTime,
  }){
    medicineId = mds.medicineId;
    medicineName = mds.medicineName;
    desc = mds.desc;
    type = mds.type;
    doctorName = mds.doctorName;
    imageUrl = mds.imageUrl;
    done = mds.done;
    notDone = mds.datesList!.length - mds.done;
    archived = mds.archived;
  }

}