import 'dart:convert';

class MDate {
  DateTime dateTime;
  bool done;
  bool archive;

  MDate({
    required this.dateTime,
    this.done = false,
    this.archive = false
  });

  factory MDate.fromMap(Map<String, dynamic> map) {
    return MDate(
        dateTime: map['dateTime'] == null ?
        DateTime.now() : DateTime.parse(map['dateTime'] as String),
        done: map['done']  == null ? false :
        map['done'] == 'false' ? false : true,
        archive: map['archive']  == null ? false :
        map['archive'] == 'false' ? false : true,
    );
  }

  static Map<String, dynamic> toMap(MDate mDate) => {
    "dateTime": mDate.dateTime.toIso8601String(),
    "done": mDate.done,
    "archive": mDate.archive,
  };

  static String encode(List<MDate> mdList) => json.encode(
      mdList.map<Map<String, dynamic>>((md) => MDate.toMap(md)).toList());

  static List<MDate> decode(String mdList) => ((json.decode(mdList))
      .map((item) => item as Map<String, dynamic>).toList())
      .map<MDate>((item) => MDate.fromMap(item)).toList();
}

class MedicationDates {
  String dateId;
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
  List<MDate>? datesList;

  MedicationDates({
    this.dateId = "",
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
    this.datesList
  }){
    int i = daysNum * repeatInDay;
    if(i!=0){
      datesList = [];
      while(i-- != 0) {
        datesList!.add(MDate(dateTime: startDateTime!.add(Duration(hours: 24~/repeatInDay))));
      }
    }
    else {
      datesList = [MDate(dateTime: dateTime!)];
    }
    endDateTime = startDateTime.add(Duration(days: daysNum));
  }

  archiveDate() {
    datesList![done].archive = true;
    done++;
    dateTime = datesList![done].dateTime;
  }
  doneDate() {
    datesList![done].done = true;
    datesList![done].archive = true;
    done++;
    dateTime = datesList![done].dateTime;
  }

  delete() {
    datesList!.removeAt(done);
  }

  factory MedicationDates.fromMap(Map<String, dynamic> map) {
    return MedicationDates(
      dateId: map['dateId'] ?? '',
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
      datesList: map['datesList'] == null ? [] : MDate.decode(map['datesList'])
    );
  }

  static Map<String, dynamic> toMap(MedicationDates medicationDates) => {
    "dateId": medicationDates.dateId,
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
    "datesList" : MDate.encode(medicationDates.datesList!)
  };

  static String encode(List<MedicationDates> mdsList) => json.encode(
      mdsList.map<Map<String, dynamic>>((mds) => MedicationDates.toMap(mds)).toList());

  static List<MedicationDates> decode(String mdsList) => ((json.decode(mdsList))
      .map((item) => item as Map<String, dynamic>).toList())
      .map<MedicationDates>((item) => MedicationDates.fromMap(item)).toList();
}