import 'dart:convert';

class DDate {
  int dateId;
  DateTime dateTime;
  bool done;
  bool archive;

  DDate({
    required this.dateId,
    required this.dateTime,
    this.done = false,
    this.archive = false
  });

  factory DDate.fromMap(Map<String, dynamic> map) {
    return DDate(
      dateId: map['dateId'] ?? 0,
      dateTime: map['dateTime'] == null ?
      DateTime.now() : DateTime.parse(map['dateTime'] as String),
      done: map['done']  == null ? false :
      map['done'] == 'false' ? false : true,
      archive: map['archive']  == null ? false :
      map['archive'] == 'false' ? false : true,
    );
  }

  static Map<String, dynamic> toMap(DDate dDate) => {
    "dateId": dDate.dateId,
    "dateTime": dDate.dateTime.toIso8601String(),
    "done": dDate.done,
    "archive": dDate.archive,
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
  int dateId;
  List<DDate>? datesList;

  DoctorDates({
    this.doctorId = "",
    this.doctorName = "",
    this.type = '',
    this.phoneNumber = '',
    this.location = '',
    required this.dateTime,
    this.done = 0,
    this.dateId = 0,
    this.datesList
  }){
    datesList = [DDate(dateId: ++dateId, dateTime: dateTime!)];
  }

  doneDate() {
    datesList![done].done = true;
    datesList![done].archive = true;
    done++;
    dateTime = datesList![done].dateTime;
  }
  archiveDate(int id) {
    datesList!.firstWhere((element) => element.dateId == id).archive = true;
    done++;
    dateTime = datesList![done].dateTime;
  }

  delete(int id) {
    datesList!.removeWhere((element) => element.dateId == id);
  }

  addDate(DateTime date) {
    datesList!.add(DDate(dateId: ++dateId, dateTime: date));
    datesList!.sort((a,b) => a.dateTime!.compareTo(b.dateTime!));
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
        dateId: map['dateId'] ?? 0,
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
        "dateId": doctorDates.dateId,
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