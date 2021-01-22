import 'package:caps_app/models/capseur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference capseursCollection =
      FirebaseFirestore.instance.collection('capseurs');

  Future updateCapseurData(String firstname, String lastname, int rank,
      int matchsPlayed, int matchsWon, int capsHit, int bottlesEmptied) async {
    return await capseursCollection.doc(uid).set({
      'firstname': firstname,
      'lastname': lastname,
      'rank': rank,
      'matchsPlayed': matchsPlayed,
      'matchsWon': matchsWon,
      'capsHit': capsHit,
      'bottlesEmptied': bottlesEmptied,
    });
  }

  // Capseur list from snapshot
  List<Capseur> _capseurListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Capseur(
          doc.data()['firstname'] ?? '',
          doc.data()['lastname'] ?? '',
          doc.data()['rank'] ?? '',
          doc.data()['matchsPlayed'] ?? '',
          doc.data()['matchsWon'] ?? '',
          doc.data()['capsHit'] ?? '',
          doc.data()['bottlesEmptied'] ?? '',
          doc.id ?? '');
    }).toList();
  }

  Capseur _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return Capseur(
        snapshot.data()['firstname'] ?? '',
        snapshot.data()['lastname'] ?? '',
        snapshot.data()['rank'] ?? '',
        snapshot.data()['matchsPlayed'] ?? '',
        snapshot.data()['matchsWon'] ?? '',
        snapshot.data()['capsHit'] ?? '',
        snapshot.data()['bottlesEmptied'] ?? '',
        uid);
  }

  // get capseurs stream
  Stream<List<Capseur>> get capseurs {
    return capseursCollection
        .snapshots()
        .map((snapshot) => _capseurListFromSnapshot(snapshot));
  }

  // get user doc stream
  Stream<Capseur> get userData {
    return capseursCollection
        .doc(uid)
        .snapshots()
        .map((snapshot) => _userDataFromSnapshot(snapshot));
  }
}
