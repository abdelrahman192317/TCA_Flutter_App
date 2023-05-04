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
    }on FirebaseAuthException catch(e) {rethrow;}
  }

  Future<String> signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user!.uid;
    }on FirebaseAuthException catch(e) {
      throw e.message!;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Firestore methods
  Future<String> createDocument(String collectionName, Map<String, dynamic> documentData) async {
    try{
      DocumentReference docRef = await _firestore
          .collection(collectionName)
          .add(documentData);
      return docRef.id;
    }on FirebaseException catch(e) {
      throw e.message!;
    }

  }

  Future<Map<String, dynamic>> getDocument(
      String collectionName, String documentId) async {
    DocumentSnapshot doc = await _firestore
        .collection(collectionName)
        .doc(documentId)
        .get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    } else {
      return {};
    }
  }

  Future<void> updateDocument(
      String collectionName, String documentId,
      Map<String, dynamic> updateData) async {
    await _firestore
        .collection(collectionName)
        .doc(documentId)
        .update(updateData);
  }

  Future<void> deleteDocument(
      String collectionName, String documentId) async {
    await _firestore.collection(collectionName).doc(documentId).delete();
  }

  // Realtime methods (not implemented in this example)
  void subscribeToTopic(String topicName) {
    // TODO: Implement this method
  }

  void unsubscribeFromTopic(String topicName) {
    // TODO: Implement this method
  }
}