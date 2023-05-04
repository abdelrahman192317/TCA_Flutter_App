import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
//import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/firebase.dart';

import '../models/medication_models.dart';
import '../models/doctor_models.dart';
import '../models/user_models.dart';

class MyPro extends ChangeNotifier {

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  nullErrorMessage() {_errorMessage = null; notifyListeners();}
  setErrorMessage(String e) {_errorMessage = e; notifyListeners();}


  ///////////////////////////////
  //sign
  bool _signIsLoading = false;
  bool get signIsLoading => _signIsLoading;

  bool _signObscureText = true;
  bool get signObscureText => _signObscureText;
  toggleSignObscureText () {_signObscureText = !_signObscureText; notifyListeners();}

  String? _signErrorMessage;
  String? get signErrorMessage => _signErrorMessage;
  nullSignErrorMessage() {_signErrorMessage = null; notifyListeners();}
  setSignErrorMessage(String e) {_signErrorMessage = e; notifyListeners();}

  ///////////////////////////////
  //register
  bool _registerIsLoading = false;
  bool get registerIsLoading => _registerIsLoading;

  bool _registerObscureText = true;
  bool get registerObscureText => _registerObscureText;
  toggleRegisterObscureText () {_registerObscureText = !_registerObscureText; notifyListeners();}

  bool _registerCObscureText = true;
  bool get registerCObscureText => _registerCObscureText;
  toggleRegisterCObscureText () {_registerCObscureText = !_registerCObscureText; notifyListeners();}

  String? _registerErrorMessage;
  String? get registerErrorMessage => _registerErrorMessage;
  nullRegisterErrorMessage() {_registerErrorMessage = null; notifyListeners();}
  setRegisterErrorMessage(String e) {_registerErrorMessage = e; notifyListeners();}



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

    _signIsLoading = true;
    notifyListeners();

    try{
      await firebaseManager.signInWithEmailAndPassword(email, password);
    } catch(e){
      _signIsLoading = false;
      notifyListeners();
      rethrow;
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('sign', 'true');

    _signIsLoading = false;
    notifyListeners();
  }

  Future<void> register({required User user}) async {

    _registerIsLoading = true;
    notifyListeners();

    try{
      String authId = await firebaseManager.createUserWithEmailAndPassword(user.email, user.password);
      user.authId = authId;
    } catch(e){
      _registerIsLoading = false;
      notifyListeners();
      rethrow;
    }

    try{
      String uid = await firebaseManager.createDocument("Users", User.toMap(user));
      user.userId = uid;
    } catch(e){
      _registerIsLoading = false;
      notifyListeners();
      rethrow;
    }
    _user = user;
    setUser();

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('sign', 'true');

    _registerIsLoading = false;
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
    _isSign = false;

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
    if(_mdsList.isNotEmpty){_mdsList.forEach((mds) {mds.datesList!.forEach((md) {if(!md.archive){ mds.dateTime = md.dateTime; _dsList.add(mds);} }); }); }
    if(_ddsList.isNotEmpty){_ddsList.forEach((dds) { dds.datesList!.forEach((dd) {if(!dd.archive){dds.dateId = dd.dateId; dds.dateTime = dd.dateTime; _dsList.add(dds);}});});}
    if(_dsList.isNotEmpty)_dsList.sort((a,b) => a.dateTime!.compareTo(b.dateTime!));
    return _dsList;
  }
  List<dynamic> get aDsList {
    _aDsList = [];
    if(_mdsList.isNotEmpty){_mdsList.forEach((mds) { mds.datesList!.forEach((md) {if(md.archive){ mds.dateTime = md.dateTime; _aDsList.add(mds);}});});}
    if(_ddsList.isNotEmpty){_ddsList.forEach((dds) { dds.datesList!.forEach((dd) {if(dd.archive){dds.dateId = dd.dateId; dds.dateTime = dd.dateTime; _aDsList.add(dds);}});});}
    if(_aDsList.isNotEmpty)_aDsList.sort((a,b) => a.dateTime!.compareTo(b.dateTime!));
    return _aDsList;
  }


  List<String> get dNList {
    _ddsList.forEach((e) => _dNList.add(e.doctorName));
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

    dsList;
    aDsList;
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
  addMDs({required MedicationDates mds}) async{
    _mdsList.add(mds);

    dsList;

    await setData();
    notifyListeners();
  }

  doneMDate(MedicationDates mds) {
    (_mdsList.firstWhere((element) => element.dateTime! == mds.dateTime!)).doneDate();

    _index == 0? dsList : aDsList;

    setData();
    notifyListeners();
  }

  archiveMDate(MedicationDates mds) {
    (_mdsList.firstWhere((element) => element.dateTime! == mds.dateTime!)).archiveDate();

    _index == 0? dsList : aDsList;

    setData();
    notifyListeners();
  }

  deleteFromMDsList(MedicationDates mds) {
    (_mdsList.firstWhere((element) => element.dateTime! == mds.dateTime!)).delete();

    _index == 0? dsList : aDsList;

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

  addDDs({required DoctorDates dds}) async{
    _ddsList.add(dds);

    dsList;

    await setData();
    notifyListeners();
  }

  doneDDate(DoctorDates dds) {
    (_ddsList.firstWhere((element) => element.doctorId == dds.doctorId)).doneDate();

    _index == 0? dsList : aDsList;

    setData();
    notifyListeners();
  }

  archiveDDate(DoctorDates dds) {
    (_ddsList.firstWhere((element) => element.dateTime! == dds.dateTime!)).archiveDate(dds.dateId);

    _index == 0? dsList : aDsList;

    setData();
    notifyListeners();
  }

  deleteFromDDsList(DoctorDates dds) {
    (_ddsList.firstWhere((element) => element.dateTime! == dds.dateTime!)).delete(dds.dateId);

    _index == 0? dsList : aDsList;

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

}