import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/matchEnded.dart';
import 'package:caps_app/models/tournamentInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference capseursCollection =
      FirebaseFirestore.instance.collection('capseurs');

  final CollectionReference matchsCollection =
      FirebaseFirestore.instance.collection('matchs');

  final CollectionReference tournamentsCollection =
      FirebaseFirestore.instance.collection('tournaments');

  final CollectionReference capseursInTournamentsCollection =
      FirebaseFirestore.instance.collection('capseursInTournaments');

  Future updateCapseurData(
      String _uid,
      String firstname,
      String lastname,
      int matchsPlayed,
      int matchsWon,
      int capsHit,
      int bottlesEmptied,
      double points) async {
    return await capseursCollection.doc(_uid).set({
      'firstname': firstname,
      'lastname': lastname,
      'matchsPlayed': matchsPlayed,
      'matchsWon': matchsWon,
      'capsHit': capsHit,
      'bottlesEmptied': bottlesEmptied,
      'points': points,
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

  Future updateTournamentData(String name, int numberMaxPlayers,
      int numberPlayersGettingOutOfEachPool) async {
    return await tournamentsCollection.doc().set({
      'name': name,
      'numberMaxPlayers': numberMaxPlayers,
      'numberPlayersGettingOutOfEachPool': numberPlayersGettingOutOfEachPool
    });
  }

  Future updateCapseursInTournamentsData(
      String tournamentUid, String poolUid, String capseurUid) async {
    return await capseursInTournamentsCollection.doc().set({
      'tournamentUid': tournamentUid,
      'poolUid': poolUid,
      'capseurUid': capseurUid
    });
  }

  // Capseur list from snapshot
  List<Capseur> _capseurListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Capseur(
        doc.data()['firstname'] ?? '',
        doc.data()['lastname'] ?? '',
        doc.data()['matchsPlayed'] ?? '',
        doc.data()['matchsWon'] ?? '',
        doc.data()['capsHit'] ?? '',
        doc.data()['bottlesEmptied'] ?? '',
        doc.id ?? '',
        doc.data()['points'] ?? '',
      );
    }).toList();
  }

  List<MatchEnded> _matchListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return MatchEnded.official(
          doc.id,
          doc.data()['capseur1'] ?? '',
          doc.data()['capseur2'] ?? '',
          doc.data()['date'] ?? Timestamp.now(),
          doc.data()['scorePlayer1'] ?? 0,
          doc.data()['scorePlayer2'] ?? 0,
          doc.data()['uidTournament'] ?? '',
          doc.data()['uidPool'] ?? '');
    }).toList();
  }

  List<TournamentInfo> _tournamentListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return TournamentInfo(
          doc.id,
          doc.data()['name'] ?? '',
          doc.data()['numberMaxPlayers'] ?? 0,
          doc.data()['numberPlayersGettingOutOfEachPool'] ?? 0);
    }).toList();
  }

  Map<String, Map<String, String>> _capseursInTournamentsMapFromSnapshot(
      QuerySnapshot snapshot) {
    Map<String, Map<String, String>> listOfPoolsAndCapseursInTournaments =
        new Map();
    // tournamentUid: poolUid: capseurUid
    snapshot.docs.forEach((doc) {
      Map<String, String> tournamentMap =
          listOfPoolsAndCapseursInTournaments[doc.data()['tournamentUid']] ??
              new Map();
      tournamentMap[doc.data()['capseurUid']] = doc.data()['poolUid'];
      listOfPoolsAndCapseursInTournaments[doc.data()['tournamentUid']] =
          tournamentMap;
    });
    return listOfPoolsAndCapseursInTournaments;
  }

  Capseur _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return Capseur(
      snapshot.data()['firstname'] ?? '',
      snapshot.data()['lastname'] ?? '',
      snapshot.data()['matchsPlayed'] ?? '',
      snapshot.data()['matchsWon'] ?? '',
      snapshot.data()['capsHit'] ?? '',
      snapshot.data()['bottlesEmptied'] ?? '',
      uid,
      snapshot.data()['points'] ?? '',
    );
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

  Stream<List<TournamentInfo>> get tournaments {
    return tournamentsCollection
        .snapshots()
        .map((snapshot) => _tournamentListFromSnapshot(snapshot));
  }

  Stream<Map<String, Map<String, String>>> get capseursInTournaments {
    return capseursInTournamentsCollection
        .snapshots()
        .map((snapshot) => _capseursInTournamentsMapFromSnapshot(snapshot));
  }

  // get user doc stream
  Stream<Capseur> get userData {
    return capseursCollection
        .doc(uid)
        .snapshots()
        .map((snapshot) => _userDataFromSnapshot(snapshot));
  }
}
