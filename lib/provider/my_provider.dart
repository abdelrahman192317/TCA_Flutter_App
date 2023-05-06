import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/firebase.dart';

import '../models/medication_models.dart';
import '../models/doctor_models.dart';
import '../models/user_models.dart';

class MyPro extends ChangeNotifier {

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  void nullErrorMessage() {_errorMessage = null; notifyListeners();}
  void setErrorMessage(String e) {_errorMessage = e; notifyListeners();}

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void resetIsLoading() {_isLoading = false; notifyListeners();}

  bool _obscureText = true;
  bool get obscureText => _obscureText;
  void toggleObscureText () {_obscureText = !_obscureText; notifyListeners();}
  void resetObscureText() {_obscureText = true; notifyListeners();}

  bool _registerCObscureText = true;
  bool get registerCObscureText => _registerCObscureText;
  void toggleRegisterCObscureText () {_registerCObscureText = !_registerCObscureText; notifyListeners();}
  void resetRegisterCObscureText() {_registerCObscureText = true; notifyListeners();}

  void reset() {
    _errorMessage = null;
    _isLoading = false;
    _obscureText = true;
    _registerCObscureText = true;
  }

  // firebase
  FirebaseManager firebaseManager = FirebaseManager();

  /////////////////////////////////////////////
  // methods
  /////////////////////////////////////////////


  ///////////////////////////////////
  // auth
  bool _isSign = false;
  bool get isSign => _isSign;

  getSavedSign() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String reJson = pref.getString('sign') ?? '';
    _isSign =  reJson == 'true'? true : false;
    notifyListeners();
  }

  Future<void> sign({required String email, required String password}) async {

    _isLoading = true;
    notifyListeners();

    try{
      await firebaseManager.signInWithEmailAndPassword(email, password);
    } catch(e){
      resetIsLoading();
      rethrow;
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('sign', 'true');

    _isLoading = false;
    notifyListeners();
  }

  Future<void> register({required User user}) async {

    _isLoading = true;
    notifyListeners();

    try{
      String authId = await firebaseManager.createUserWithEmailAndPassword(user.email, user.password);
      user.authId = authId;
    } catch(e){
      resetIsLoading();
      rethrow;
    }

    try{
      String uid = await firebaseManager.createDocument("Users", User.toMap(user));
      user.userId = uid;
    } catch(e){
      resetIsLoading();
      rethrow;
    }
    _user = user;
    setUser();

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('sign', 'true');

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {

    await firebaseManager.signOut();

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('sign', '');

    _isSign = false;

    notifyListeners();
  }



  ////////////////////////////////////////////
  // user
  User _user = User();
  User get user => _user;

  getUser() async{
    SharedPreferences pref = await SharedPreferences.getInstance();

    String reUJson = pref.getString('user') ?? '';

    if(reUJson != ''){
      User user = User.decode(reUJson);
      _user = user;
    }
    notifyListeners();
  }

  setUser() async{
    SharedPreferences pref = await SharedPreferences.getInstance();

    String uJson = User.encode(_user);
    pref.setString('user', uJson);
  }

  Future<void> deleteUser() async{

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('user', '');
    _user = User();
    logout();

    notifyListeners();
  }


  ////////////////////////////////////////////
  // dates
  List<dynamic> _dsList = [];
  List<dynamic> _aDsList = [];
  List<MedicationDates> _mdsList = [];
  List<DoctorDates> _ddsList = [];

  List<String> _dNList = [];

  List<dynamic> get dsList {
    _dsList = [];
    if(_mdsList.isNotEmpty){
      for (var mds in _mdsList) {
        for (var md in mds.datesList!) {
          print('mds $md  ${md.done}');
          if(!md.archived) _dsList.add(MDateCard(mds: mds, dateTime: md.dateTime));
        }
      }
    }
    if(_ddsList.isNotEmpty){
      for (var dds in _ddsList) {
        for (var dd in dds.datesList!) {
          print('dds $dd  ${dd.done}');
          if(!dd.archived) _dsList.add(DDateCard(dds: dds, dateTime: dd.dateTime));
        }
      }
    }
    if(_dsList.isNotEmpty)_dsList.sort((a,b) => a.dateTime!.compareTo(b.dateTime!));
    return _dsList;
  }

  List<dynamic> get aDsList {
    _aDsList = [];
    if(_mdsList.isNotEmpty){
      for (var mds in _mdsList) {
        if(mds.archived != 0) _aDsList.add(MDateCard(mds: mds, dateTime: mds.datesList![mds.archived - 1].dateTime));
      }
    }
    if(_ddsList.isNotEmpty){
      for (var dds in _ddsList) {
        if(dds.archived != 0) _aDsList.add(DDateCard(dds: dds, dateTime: dds.datesList![dds.archived - 1].dateTime));
      }
    }
    if(_aDsList.isNotEmpty)_aDsList.sort((a,b) => a.dateTime!.compareTo(b.dateTime!));
    return _aDsList;
  }

  List<String> get dNList {
    _dNList = [];
    for (var dds in _ddsList) {
      _dNList.add(dds.doctorName);
    }
    return _dNList;
  }

  getDs(int index) => _index == 0? _dsList[index] : _aDsList[index];

  int get count => _index == 0? _dsList.length : _aDsList.length;


  getData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();

    String reMDsJson = pref.getString('mDsList') ?? '';
    String reDDsJson = pref.getString('dDsList') ?? '';

    if(reMDsJson.length > 10){
      List<MedicationDates> mdsList = MedicationDates.decode(reMDsJson);
      _mdsList = mdsList;
    }

    if(reDDsJson.length > 10){
      List<DoctorDates> ddsList = DoctorDates.decode(reDDsJson);
      _ddsList = ddsList;
    }

    print('ddslist $_ddsList');
    print('mdslist $_mdsList');

    dsList;
    aDsList;

    print('dslist $_dsList');
    print('adslist $_aDsList');

    notifyListeners();
  }

  Future<void> setData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();

    String mdsJson = MedicationDates.encode(_mdsList);
    pref.setString('mDsList', mdsJson);

    String ddsJson = DoctorDates.encode(_ddsList);
    pref.setString('dDsList', ddsJson);
  }


  ///////////////////////////////
  //medication
  MedicationDates getMDate(String id) =>
    _mdsList.firstWhere((element) => element.medicineId == id);

  addMDs({required MedicationDates mds}){
    _mdsList.add(mds);

    dsList;
    aDsList;

    setData();
    notifyListeners();
  }

  doneMDate(String id) {
    _mdsList.firstWhere((element) => element.medicineId == id).doneDate();

    dsList;
    aDsList;

    setData();
    notifyListeners();
  }

  archiveMDate(String id, DateTime dateTime) {
    _mdsList.firstWhere((element) => element.medicineId == id).archiveDate(dateTime);

    dsList;
    aDsList;

    setData();
    notifyListeners();
  }

  deleteFromMDsList(String id, DateTime dateTime) {
    _mdsList.firstWhere((element) => element.medicineId == id).delete(dateTime);

    dsList;
    aDsList;

    setData();
    notifyListeners();
  }



  ///////////////////////////////
  //doctor
  bool _isNewDoc = true;
  bool get isNewDoc => _isNewDoc;
  setIsNewDoc(bool val) {_isNewDoc = val; notifyListeners();}

  String _dN = '';
  String get dN => _dN;
  setDN(String name) {_dN = name; notifyListeners();}

  DoctorDates getDDate(String id) =>
      _ddsList.firstWhere((element) => element.doctorId == id);

  addDDs({required DoctorDates dds}){
    _ddsList.add(dds);

    dsList;
    aDsList;

    setData();
    notifyListeners();
  }

  addDD(DateTime date){
    _ddsList.firstWhere((element) => element.doctorName == _dN).addDate(date);

    dsList;
    aDsList;

    setData();
    notifyListeners();
  }

  doneDDate(String id) {
    _ddsList.firstWhere((element) => element.doctorId == id).doneDate();

    dsList;
    aDsList;

    setData();
    notifyListeners();
  }

  archiveDDate(String id, DateTime dateTime) {
    _ddsList.firstWhere((element) => element.doctorId == id).archiveDate(dateTime);

    dsList;
    aDsList;

    setData();
    notifyListeners();
  }

  deleteFromDDsList(String id, DateTime dateTime) {
    _ddsList.firstWhere((element) => element.doctorId == id).delete(dateTime);

    dsList;
    aDsList;

    setData();
    notifyListeners();
  }


  //////////////////////////////////
  //bottom bar
  int _index = 0;
  int get index => _index;
  moveIndex(int index) {_index = index; notifyListeners();}


  //////////////////////////////////
  //pickers
  //////////////////////////////////
  //image
  bool _isImagePicked = false;
  bool get isImagePicked => _isImagePicked;

  File _image = File('');
  File get image => _image;

  Future getImage() async {
    _isImagePicked = false;
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {_image = File(pickedFile.path);_isImagePicked = true;}
    notifyListeners();
  }


  //////////////////////////////////
  //date
  bool _isDatePicked = false;
  bool get isDatePicked => _isDatePicked;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  Future<void> selectDate(BuildContext context) async {
    _isDatePicked = false;
    notifyListeners();

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {_selectedDate = picked; _isDatePicked = true;}
    notifyListeners();
  }



  //////////////////////////////////
  //time
  bool _isTimePicked = false;
  bool get isTimePicked => _isTimePicked;

  TimeOfDay _selectedTime = TimeOfDay.now();
  TimeOfDay get selectedTime => _selectedTime;

  Future<void> selectTime(BuildContext context) async {
    _isTimePicked = false;
    notifyListeners();

    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      _selectedTime = picked;

      _isTimePicked = true;
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      notifyListeners();
    }
  }

  falsePickers() {
    _isImagePicked = false;
    _isDatePicked = false;
    _isTimePicked = false;
    notifyListeners();
  }


  /////////////////////////////
  //dismissible
  /////////////////////////////
  bool _start = false;
  bool get start => _start;
  setStart(bool s) {_start = s; notifyListeners();}



  /////////////////////////////
  //notification
  /////////////////////////////
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize the plugin
  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('launch_background');
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> setAlarm() async {

    // Define the notification details
    const androidDetails = AndroidNotificationDetails(
      'alarm_channel1', // channel ID
      'alarm', // channel name
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alarm'),
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );
    const notificationDetails =
    NotificationDetails(android: androidDetails);

    // Define the date and time when the alarm should trigger

    // Initialize time zone data
    tz.initializeTimeZones();

    // Convert the scheduled date and time to the local time zone
    final scheduledDate = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1));

    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      'alarm', // Notification title
      'Time to wake up!', // Notification body
      scheduledDate, // Scheduled date and time in the local time zone
      notificationDetails,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime, // Allow delivery while device is idle
    );
  }

  Future<void> scheduleNotification(DateTime dateTime, String title, String body) async {

    // Initialize time zone data
    tz.initializeTimeZones();

    // Convert the scheduled date and time to the local time zone
    final scheduledDate = tz.TZDateTime.from(dateTime, tz.local);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'your_channel_id', 'your_channel_name',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        0, // Notification ID
        title, // Notification title
        body, // Notification body
        scheduledDate, // Scheduled date and time
        platformChannelSpecifics,
        //androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }
}