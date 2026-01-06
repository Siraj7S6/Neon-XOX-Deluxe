import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class GameProvider extends ChangeNotifier {
  final FirebaseDatabase _db = FirebaseDatabase.instance;
  
  String? _matchId;
  String? _mySymbol;
  String? _myUid;
  String? _opponentUid;
  
  List<String> board = List.filled(9, ""); 
  String currentTurn = ""; 
  String status = "playing"; 

  // --- STABILITY ADDITIONS ---
  bool _isProcessingMove = false; // Prevent double-moves
  StreamSubscription<DatabaseEvent>? _gameSubscription; // For clean disposal

  final List<List<int>> _winPatterns = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8],
    [0, 3, 6], [1, 4, 7], [2, 5, 8],
    [0, 4, 8], [2, 4, 6],
  ];

  void initGame(String matchId, String myUid, String mySymbol, String opponentUid) {
    _matchId = matchId;
    _myUid = myUid;
    _mySymbol = mySymbol;
    _opponentUid = opponentUid;

    // 1. Handle Disconnects (Presence Detection)
    // If this player loses connection, the server automatically forfeits the match.
    _db.ref("matches/$_matchId").onDisconnect().update({
      "status": "abandoned",
      "winner": _opponentUid,
    });

    // 2. Clean up old listener before starting new one
    _gameSubscription?.cancel();

    _gameSubscription = _db.ref("matches/$_matchId").onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        if (data["board"] != null) {
          board = List<String>.from(data["board"]);
        }
        currentTurn = data["turn"] ?? "";
        status = data["status"] ?? "playing";
        notifyListeners();
      }
    }, onError: (error) {
      debugPrint("Firebase Stream Error: $error"); //
    });
  }

  Future<void> makeMove(int index) async {
    // 3. UI Guard: Prevent moves if already processing or invalid
    if (_isProcessingMove || currentTurn != _myUid || board[index] != "" || status != "playing") {
      return; 
    }

    _isProcessingMove = true; 
    
    // Save previous state for rollback in case of failure
    final previousBoard = List<String>.from(board);
    
    // Optimistic Update
    board[index] = _mySymbol!;
    notifyListeners();

    String newStatus = _checkWinner();
    String nextTurn = (newStatus == "playing") ? _opponentUid! : "";

    try {
      await _db.ref("matches/$_matchId").update({
        "board": board,
        "turn": nextTurn,
        "status": newStatus,
      });
    } catch (e) {
      // 4. Rollback Logic: Revert UI if server update fails
      board = previousBoard;
      debugPrint("Move failed, rolling back: $e");
      notifyListeners();
    } finally {
      _isProcessingMove = false; // Always unlock the UI
    }
  }

  String _checkWinner() {
    for (var pattern in _winPatterns) {
      if (board[pattern[0]] != "" &&
          board[pattern[0]] == board[pattern[1]] &&
          board[pattern[0]] == board[pattern[2]]) {
        return "${board[pattern[0]]}_wins";
      }
    }
    if (!board.contains("")) return "draw";
    return "playing";
  }

  void resetGame() async {
    // Only host should reset to avoid double-writes
    if (_mySymbol == "X") {
      await _db.ref("matches/$_matchId").update({
        "board": List.filled(9, ""),
        "turn": _myUid,
        "status": "playing",
      });
    }
  }

  @override
  void dispose() {
    _gameSubscription?.cancel(); // Prevent memory leaks
    super.dispose();
  }
}