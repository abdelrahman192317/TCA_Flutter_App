import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:app2m/models/notification_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/firebase.dart';

import '../models/medication_models.dart';
import '../models/doctor_models.dart';
import '../models/user_model.dart';
import '../notifications/all_notification_functions.dart';
import '../widgets/done_confirm_widget.dart';

class MyPro extends ChangeNotifier {

  late NotificationsHandler notificationsHandler;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  MyPro(){
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initializeNotifications();
    notificationsHandler = NotificationsHandler(flutterLocalNotificationsPlugin);
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  }


  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  void nullErrorMessage() {_errorMessage = null; notifyListeners();}
  void setErrorMessage(String e) {_errorMessage = e; notifyListeners();}

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void resetIsLoading() {_isLoading = false; notifyListeners();}

  bool _oldObscureText = true;
  bool get oldObscureText => _oldObscureText;
  void toggleOldObscureText () {_oldObscureText = !_oldObscureText; notifyListeners();}
  void resetOldObscureText() {_oldObscureText = true; notifyListeners();}

  bool _obscureText = true;
  bool get obscureText => _obscureText;
  void toggleObscureText () {_obscureText = !_obscureText; notifyListeners();}
  void resetObscureText() {_obscureText = true; notifyListeners();}

  bool _registerCObscureText = true;
  bool get registerCObscureText => _registerCObscureText;
  void toggleRegisterCObscureText () {_registerCObscureText = !_registerCObscureText; notifyListeners();}
  void resetRegisterCObscureText() {_registerCObscureText = true; notifyListeners();}

  bool _forget = false;
  bool get forget => _forget;
  void toggleForget() {_forget = !_forget; notifyListeners();}
  void resetForget() {_forget = false; notifyListeners();}

  void reset() {
    _errorMessage = null;
    _isLoading = false;
    _oldObscureText = true;
    _obscureText = true;
    _registerCObscureText = true;
    _forget = false;
    notifyListeners();
  }


  bool _isCPress = false;
  bool get isCPress => _isCPress;
  void setIsCPress(bool val) {_isCPress = val; notifyListeners();}

  bool _isGPress = false;
  bool get isGPress => _isGPress;
  void setIsGPress(bool val) {_isGPress = val; notifyListeners();}


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

    String uAuthId = '';

    try{
      uAuthId = await firebaseManager.signInWithEmailAndPassword(email, password);
    } catch(e){
      resetIsLoading();
      rethrow;
    }

    SharedPreferences pref = await SharedPreferences.getInstance();

    String reUJson = pref.getString('user') ?? '';
    if(reUJson != ''){
      _user = User.decode(reUJson);
    }else{
      Map<String, dynamic> userMap = await firebaseManager.getUser(uAuthId);
      _user = User.fromMap(userMap);
    }

    setUser();

    pref.setString('sign', 'true');

    _isLoading = false;
    notifyListeners();
  }

  Future<void> register({required User user}) async {

    _isLoading = true;
    notifyListeners();

    String authId = '';

    try{
      authId = await firebaseManager.createUserWithEmailAndPassword(user.email, user.password);
    } catch(e){
      resetIsLoading();
      rethrow;
    }

    try{
      await firebaseManager.createUser(authId ,User.toMap(user));
    } catch(e){
      resetIsLoading();
      rethrow;
    }
    _user = user;
    _user.userId = authId;

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
    pref.setString('user', '');

    _user = User();

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
    _isLoading = true;
    notifyListeners();

    try{
      firebaseManager.deleteUser(_user.userId);
    } catch(e){
      resetIsLoading();
      rethrow;
    }

    resetIsLoading();
    notifyListeners();
  }

  Future<void> updateMail(String newEmail) async{
    _isLoading = true;
    notifyListeners();

    try{
      _user.email = newEmail;
      firebaseManager.updateEmail(_user.userId, newEmail,User.toMap(_user));
    } catch(e){
      resetIsLoading();
      rethrow;
    }

    resetIsLoading();
    notifyListeners();
  }

  Future<void> updatePass(String newPass) async{
    _isLoading = true;
    notifyListeners();

    try{
      _user.password = newPass;
      firebaseManager.updatePassword(_user.userId, newPass,User.toMap(_user));
    } catch(e){
      resetIsLoading();
      rethrow;
    }

    resetIsLoading();
    notifyListeners();
  }

  Future<void> updatePN(String newPhone) async{
    _isLoading = true;
    notifyListeners();

    try{
      _user.userPN = newPhone;
      firebaseManager.updatePhone(_user.userId,User.toMap(_user));
    } catch(e){
      resetIsLoading();
      rethrow;
    }

    resetIsLoading();
    notifyListeners();
  }

  Future<void> resetPw(String email) async{
    _isLoading = true;
    notifyListeners();

    try{
      firebaseManager.resetPassword(email);
    } catch(e){
      resetIsLoading();
      rethrow;
    }

    resetIsLoading();
    notifyListeners();
  }



  ////////////////////////////////////////////
  // dates
  ////////////////////////////////////////////
  List<dynamic> _datesCardsList = []; // list of dates cards
  List<dynamic> _archiveDatesCardsList = []; // list of archived dates cards
  List<MedicationDates> _medicationDatesList = [];
  List<DoctorDates> _doctorDatesList = [];

  List<String> _doctorsNamesList = [];

  List<dynamic> get datesCardsList {
    _datesCardsList = [];
    if(_medicationDatesList.isNotEmpty){
      for (var mds in _medicationDatesList) {
        for (var md in mds.datesList!) {
          if(!md.archived) _datesCardsList.add(MDateCard(mds: mds, dateTime: md.dateTime));
        }
      }
    }
    if(_doctorDatesList.isNotEmpty){
      for (var dds in _doctorDatesList) {
        for (var dd in dds.datesList!) {
          if(!dd.archived) _datesCardsList.add(DDateCard(dds: dds, dateTime: dd.dateTime));
        }
      }
    }
    if(_datesCardsList.isNotEmpty)_datesCardsList.sort((a,b) => a.dateTime!.compareTo(b.dateTime!));
    return _datesCardsList;
  }

  List<dynamic> get archiveDatesCardsList {
    _archiveDatesCardsList = [];
    if(_medicationDatesList.isNotEmpty){
      for (var mds in _medicationDatesList) {
        for (var md in mds.datesList!) {
          if(md.archived) _archiveDatesCardsList.add(MDateCard(mds: mds, dateTime: md.dateTime));
        }
      }
    }
    if(_doctorDatesList.isNotEmpty){
      for (var dds in _doctorDatesList) {
        for (var dd in dds.datesList!) {
          if(dd.archived) _archiveDatesCardsList.add(DDateCard(dds: dds, dateTime: dd.dateTime));
        }
      }
    }
    if(_archiveDatesCardsList.isNotEmpty)_archiveDatesCardsList.sort((a,b) => a.dateTime!.compareTo(b.dateTime!));
    return _archiveDatesCardsList;
  }

  List<String> get doctorsNamesList {
    _doctorsNamesList = [];
    for (var dds in _doctorDatesList) {
      _doctorsNamesList.add(dds.doctorName);
    }
    return _doctorsNamesList;
  }

  getDs(int index) => _index == 0? _datesCardsList[index] : _archiveDatesCardsList[index];

  getDsList(int index) => _index == 0? _datesCardsList[index] : _archiveDatesCardsList[index];

  int get count => _index == 0? _datesCardsList.length : _archiveDatesCardsList.length;


  getData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();

    String reMDsJson = pref.getString('mDsList') ?? '';
    String reDDsJson = pref.getString('dDsList') ?? '';

    String reNsJson = pref.getString('nList') ?? '';

    if(reMDsJson.length > 10){
      List<MedicationDates> mdsList = MedicationDates.decode(reMDsJson);
      _medicationDatesList = mdsList;
    }


    if(reDDsJson.length > 10){
      List<DoctorDates> ddsList = DoctorDates.decode(reDDsJson);
      _doctorDatesList = ddsList;
    }


    datesCardsList;
    archiveDatesCardsList;


    if(reNsJson.length > 10){
      List<NotificationCard> nList = NotificationCard.decode(reNsJson);
      _notificationCardList = nList;
    }

    notifyListeners();
  }

  Future<void> setData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();

    String mdsJson = MedicationDates.encode(_medicationDatesList);
    pref.setString('mDsList', mdsJson);

    String ddsJson = DoctorDates.encode(_doctorDatesList);
    pref.setString('dDsList', ddsJson);

    String nJson = NotificationCard.encode(_notificationCardList);
    pref.setString('nList', nJson);
  }


  ///////////////////////////////
  //medication
  MedicationDates getMDate(String id) =>
    _medicationDatesList.firstWhere((element) => element.medicineId == id);

  addMDs({required MedicationDates mds}){
    _medicationDatesList.add(mds);
    datesCardsList;
    archiveDatesCardsList;

    setData();
    notifyListeners();
  }

  doneMDate(String id) {
    _medicationDatesList.firstWhere((element) => element.medicineId == id).doneDate();

    datesCardsList;
    archiveDatesCardsList;

    setData();
    notifyListeners();
  }

  archiveMDate(String id, DateTime dateTime) {
    _medicationDatesList.firstWhere((element) => element.medicineId == id).archiveDate(dateTime);

    flutterLocalNotificationsPlugin.cancel(120 + dateTime.day + dateTime.hour + dateTime.minute);

    datesCardsList;
    archiveDatesCardsList;

    setData();
    notifyListeners();
  }

  deleteFromMDsList(String id, DateTime dateTime) {
    _medicationDatesList.firstWhere((element) => element.medicineId == id).delete(dateTime);

    flutterLocalNotificationsPlugin.cancel(120 + dateTime.day + dateTime.hour + dateTime.minute);

    datesCardsList;
    archiveDatesCardsList;

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
      _doctorDatesList.firstWhere((element) => element.doctorId == id);

  addDDs({required DoctorDates dds}){
    _doctorDatesList.add(dds);

    datesCardsList;
    archiveDatesCardsList;

    setData();
    notifyListeners();
  }

  addDD(DateTime date){
    _doctorDatesList.firstWhere((element) => element.doctorName == _dN).addDate(
        date: date, notificationsHandler: notificationsHandler
    );

    datesCardsList;
    archiveDatesCardsList;

    setData();
    notifyListeners();
  }

  doneDDate(String id) {
    _doctorDatesList.firstWhere((element) => element.doctorId == id).doneDate();

    datesCardsList;
    archiveDatesCardsList;

    setData();
    notifyListeners();
  }

  archiveDDate(String id, DateTime dateTime) {
    _doctorDatesList.firstWhere((element) => element.doctorId == id).archiveDate(dateTime);

    flutterLocalNotificationsPlugin.cancel(dateTime.day + dateTime.hour + dateTime.minute);

    datesCardsList;
    archiveDatesCardsList;

    setData();
    notifyListeners();
  }

  deleteFromDDsList(String id, DateTime dateTime) {
    _doctorDatesList.firstWhere((element) => element.doctorId == id).delete(dateTime);

    flutterLocalNotificationsPlugin.cancel(dateTime.day + dateTime.hour + dateTime.minute);

    datesCardsList;
    archiveDatesCardsList;

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

  Future getImage(ImageSource imageSource) async {
    _isImagePicked = false;
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
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


  /////////////////////////////////
  //notifications

  List<NotificationCard> _notificationCardList = [
    NotificationCard(notificationId: 'a', title: 'Initial', body: 'These Notification Is for Danger Alert', dateTime: DateTime.now()),
    NotificationCard(notificationId: 'b', title: 'These for Knowledge', body: 'You Can Delete These Notifications', dateTime: DateTime.now().add(const Duration(hours: 1))),
    NotificationCard(notificationId: 'c', title: 'fall', body: 'This Notification Is Means That The Elderly Fall', dateTime: DateTime.now().add(const Duration(hours: 2))),
    NotificationCard(notificationId: 'd', title: 'Danger', body: 'The Elderly May Be In Danger', dateTime: DateTime.now().add(const Duration(hours: 3))),
    NotificationCard(notificationId: 'e', title: 'Faints', body: 'The Elderly faints', dateTime: DateTime.now().add(const Duration(hours: 4))),
    NotificationCard(notificationId: 'f', title: 'Coma', body: 'The Elderly In Coma', dateTime: DateTime.now().add(const Duration(hours: 5))),
  ];
  List<NotificationCard> get notificationCardList => _notificationCardList;

  bool _isRead = true;
  bool get isRead => _isRead;
  resetIsRead(){ _isRead = true; notifyListeners();}

  Future<void> addNotification(String title, String body, DateTime dateTime) async{
    _notificationCardList.add(NotificationCard(notificationId: UniqueKey().toString(), title: title, body: body, dateTime: dateTime));
    _isRead = false;
    await setData();
    notifyListeners();
  }

  Future<void> deleteNotification(int index) async{
    _notificationCardList.removeAt(index);
    await setData();
    notifyListeners();
  }

  void toast(BuildContext context ,String message, {bool isRed = false}){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).shadowColor,
        textColor: isRed? Colors.red : Theme.of(context).primaryColor,
        fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize
    );
  }

  ///////////////////////////////
  //theme
  void setTheme() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isDark', _isDark);
  }
  void getTheme() async{
    SharedPreferences pref = await SharedPreferences.getInstance();

    bool reRJson = pref.getBool('isDark') ?? false;
    _isDark = reRJson;
    notifyListeners();
  }
  bool _isDark = false;
  bool get isDark => _isDark;
  toggleIsDark(){
    _isDark =!_isDark;
    setTheme();
    notifyListeners();
  }


  ///////////////////////////////
  //repeat notification
  void repeatNotifications() async{
    SharedPreferences pref = await SharedPreferences.getInstance();

    String reRJson = pref.getString('repeat') ?? '';
    if(reRJson == ''){
      notificationsHandler.scheduleRepeatsNotification();
      pref.setString('repeat', 'true');
      notifyListeners();
    }
  }


  /////////////////////////////////
  //notifications
  /////////////////////////////////

  // Initialize the plugin
  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      //onDidReceiveBackgroundNotificationResponse: onSelectNotification,
      onDidReceiveNotificationResponse: onSelectNotification
    );
  }

  String _newMessage = '';
  String get newMessage => _newMessage;
  setNewMessage(String message){
    _newMessage = message;
    notifyListeners();
  }

  static late NotificationResponse _payload;
  NotificationResponse get payload => _payload;
  setPayload(NotificationResponse payload){
    _payload = payload;
    notifyListeners();
  }

  static void onSelectNotification(NotificationResponse payload) {
    if(payload.id! != 0 && payload.id! != 1) {
      final instance = MyPro();
      instance.setPayload(payload);
      instance.setNewMessage('screen');
    }
  }

  // Save the notification data on back received danger notification
  static Future<void> onBackgroundMessage(RemoteMessage message) async {
    final instance = MyPro();
    await instance.notificationsHandler.showNotification(message.notification!.title!, message.notification!.body!);
    await instance.addNotification(message.notification!.title!, message.notification!.body!, DateTime.now());
  }


  Future<void> myShowDialog (BuildContext ctx) async{
    print('\n screen \n');
    Map<String, dynamic> map = json.decode(_payload.payload!);
    if(_payload.id! > 120){
      print('\n medication \n');
      await showDialog(context:  ctx, barrierDismissible: false, builder: (_) => DoneConfirmWidget(
        isDoctor: false,
        dateTime: DateTime.parse(map['dateTime'] as String),
        id: map['id'] as String,
      ));
    }
    else {
      print('\n doctor \n');
      await showDialog(context: ctx, barrierDismissible: false, builder: (_) => DoneConfirmWidget(
        isDoctor: true,
        dateTime: DateTime.parse(map['dateTime'] as String),
        id: map['id'] as String,
      ));
    }
  }

}