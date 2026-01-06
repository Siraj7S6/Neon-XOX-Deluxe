import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; //
import '../services/game_provider.dart';
import '../../../core/services/ad_service.dart'; // Make sure this exists from previous step
import '../widgets/neon_board.dart';
import '../widgets/neon_turn_indicator.dart';
import '../widgets/result_overlay.dart';

class GameScreen extends StatefulWidget {
  final String matchId;
  final String mySymbol;
  final String opponentUid;

  const GameScreen({
    super.key, 
    required this.matchId, 
    required this.mySymbol, 
    required this.opponentUid
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;
  bool _hasShownEndAd = false; // Prevents ad from showing multiple times for one match

  @override
  void initState() {
    super.initState();
    
    // 1. Initialize Game Logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameProvider>().initGame(
        widget.matchId,
        FirebaseAuth.instance.currentUser!.uid,
        widget.mySymbol,
        widget.opponentUid,
      );
    });

    // 2. Load Banner Ad
    _loadBanner();
  }

  void _loadBanner() {
    _bannerAd = BannerAd(
      adUnitId: AdService.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => _isBannerLoaded = true),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint("Banner Ad Failed: $error");
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose(); // Clean up memory
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    final bool isMyTurn = game.currentTurn == FirebaseAuth.instance.currentUser!.uid;
    
    // 3. Logic to show Interstitial when game ends
if (game.status != "playing" && !_hasShownEndAd) {
  _hasShownEndAd = true; 
  
  // Natural pause: Wait for the user to see the result overlay first
  Future.delayed(const Duration(seconds: 2), () {
    if (mounted && game.status != "playing") {
      AdService.showInterstitial();
    }
  });
}

    return Scaffold(
      body: Stack(
        children: [
          // Main Game Layer
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              NeonTurnIndicator(isMyTurn: isMyTurn),
              const SizedBox(height: 40),
              const NeonBoard(),
              const Spacer(),
              
              // 4. Display Banner at the bottom
              if (_isBannerLoaded && _bannerAd != null)
                SafeArea(
                  child: SizedBox(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                ),
            ],
          ),
          
          // Result Overlay Layer
          if (game.status != "playing")
            ResultOverlay(
              result: game.status, 
              onRestart: () {
                _hasShownEndAd = false; // Reset for the next match
                game.resetGame();
              },
            ),
        ],
      ),
    );
  }
}