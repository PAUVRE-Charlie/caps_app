import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/matchEnded.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference capseursCollection =
      FirebaseFirestore.instance.collection('capseurs');

  final CollectionReference matchsCollection =
      FirebaseFirestore.instance.collection('matchs');

  Future updateCapseurData(
      String _uid,
      String firstname,
      String lastname,
      int rank,
      int matchsPlayed,
      int matchsWon,
      int capsHit,
      int bottlesEmptied) async {
    return await capseursCollection.doc(_uid).set({
      'firstname': firstname,
      'lastname': lastname,
      'rank': rank,
      'matchsPlayed': matchsPlayed,
      'matchsWon': matchsWon,
      'capsHit': capsHit,
      'bottlesEmptied': bottlesEmptied,
    });
  }

  Future updateMatchData(String uidCapseur1, String uidCapseur2,
      int scorePlayer1, int scorePlayer2) async {
    return await matchsCollection.doc().set({
      'capseur1': uidCapseur1,
      'capseur2': uidCapseur2,
      'date': Timestamp.now(),
      'scorePlayer1': scorePlayer1,
      'scorePlayer2': scorePlayer2
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

  List<MatchEnded> _matchListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return MatchEnded(
          doc.id,
          doc.data()['capseur1'] ?? '',
          doc.data()['capseur2'] ?? '',
          doc.data()['date'] ?? Timestamp.now(),
          doc.data()['scorePlayer1'] ?? 0,
          doc.data()['scorePlayer2'] ?? 0);
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

  Stream<List<MatchEnded>> get matchs {
    return matchsCollection
        .snapshots()
        .map((snapshot) => _matchListFromSnapshot(snapshot));
  }

  // get user doc stream
  Stream<Capseur> get userData {
    return capseursCollection
        .doc(uid)
        .snapshots()
        .map((snapshot) => _userDataFromSnapshot(snapshot));
  }
}
