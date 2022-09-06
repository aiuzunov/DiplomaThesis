import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreChecklists {
  final CollectionReference _checklistCollection =
      FirebaseFirestore.instance.collection('checklist');

  static final FirestoreChecklists database = FirestoreChecklists();

  Future<CollectionReference<Object?>> getChecklistsFromFirestore() async {
    return _checklistCollection;
  }

  deleteChecklistFromFirestore(id) async {
    await _checklistCollection.doc(id).delete();
  }

  createChecklistFromFirestore(checklist) async {
    await _checklistCollection.add(checklist);
  }

  updateChecklistFromFirestore(documentSnapshot, checklist) async {
    await _checklistCollection.doc(documentSnapshot!.id).update(checklist);
  }
}
