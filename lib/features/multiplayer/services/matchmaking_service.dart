import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class MatchmakingService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 1. Anonymous Login
  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  // 2. Find or Create Match
  // UPDATED: Now accepts 3 parameters in the callback to prevent crashes
  Future<void> findMatch(void Function(String matchId, String symbol, String opponentUid) onMatchFound) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final matchesRef = _db.ref("matches");
    
    // Search for a 'waiting' match
    final query = matchesRef.orderByChild("status").equalTo("waiting").limitToFirst(1);
    final snapshot = await query.get();

    if (snapshot.exists) {
      // --- JOINING A MATCH ---
      final matchSnapshot = snapshot.children.first;
      String matchId = matchSnapshot.key!;
      
      // Get the Host's UID to pass as the opponent
      final matchData = matchSnapshot.value as Map;
      String hostId = matchData["hostId"] ?? "";

      await matchesRef.child(matchId).update({
        "guestId": user.uid,
        "status": "playing",
        "guestSymbol": "O",
      });

      // Pass matchId, mySymbol (O), and opponent (Host)
      onMatchFound(matchId, "O", hostId);
    } else {
      // --- CREATING A NEW MATCH ---
      String newMatchId = matchesRef.push().key!;
      await matchesRef.child(newMatchId).set({
        "hostId": user.uid,
        "guestId": "",
        "status": "waiting",
        "hostSymbol": "X",
        "turn": user.uid,
        "createdAt": ServerValue.timestamp,
      });

      // Listen for a guest to join your room
      matchesRef.child(newMatchId).onValue.listen((event) {
        final data = event.snapshot.value as Map?;
        if (data != null && data["status"] == "playing" && data["guestId"] != "") {
          // Pass matchId, mySymbol (X), and opponent (Guest)
          onMatchFound(newMatchId, "X", data["guestId"]);
        }
      });
    }
  }
}