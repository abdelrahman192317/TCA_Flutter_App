import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_database/firebase_database.dart';

class FirebaseManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //final databaseReference = FirebaseDatabase.instance.reference();


  // Authentication methods
  Future<String> createUserWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user!.uid;
    }on FirebaseAuthException {
      rethrow;
    }
  }

  Future<String> signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user!.uid;
    }on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try{
      await _auth.signOut();
    }on FirebaseException{
      rethrow;
    }
  }

  // Firestore methods
  Future<void> createUser(String userId ,Map<String, dynamic> documentData) async {
    try{
      await _firestore
          .collection('User')
          .doc(userId).set(documentData);
    }on FirebaseException {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUser(String userId) async {
    DocumentSnapshot doc;
    try{
      doc = await _firestore
          .collection('User')
          .doc(userId)
          .get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        throw('This User Not Exists');
      }
    }on FirebaseException {
      rethrow;
    }
  }

  Future<void> updateEmail(String userId, String newEmail, Map<String, dynamic> mapData) async {

    try{
      await _auth.currentUser?.updateEmail(newEmail);
      await _firestore
          .collection('User')
          .doc(userId)
          .update(mapData);
    }on FirebaseException {
      rethrow;
    }
  }

  Future<void> updatePassword(String userId, String newPassword, Map<String, dynamic> mapData) async {

    try{
      await _auth.currentUser?.updatePassword(newPassword);
      await _firestore
          .collection('User')
          .doc(userId)
          .update(mapData);
    }on FirebaseException {
      rethrow;
    }
  }

  Future<void> updatePhone(String userId, Map<String, dynamic> updateData) async {
    try{
      await _firestore
          .collection('User')
          .doc(userId)
          .update(updateData);
    }on FirebaseException {
      rethrow;
    }
  }

  Future<void> deleteUser(String userId) async {
    try{
      await _auth.currentUser?.delete();
      await _firestore.collection('User').doc(userId).delete();
    }on FirebaseException {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try{
      await _auth.sendPasswordResetEmail(email: email);
    }on FirebaseException {
      rethrow;
    }
  }
}