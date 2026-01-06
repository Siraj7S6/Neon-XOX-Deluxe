import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static InterstitialAd? _interstitialAd;
  static bool _isInterstitialReady = false;

  // TEST IDs (Replace with real IDs before publishing)
  static String get bannerAdUnitId => Platform.isAndroid 
      ? 'ca-app-pub-3940256099942544/6300978111' 
      : 'ca-app-pub-3940256099942544/2934735716';

  static String get interstitialAdUnitId => Platform.isAndroid 
      ? 'ca-app-pub-3940256099942544/1033173712' 
      : 'ca-app-pub-3940256099942544/4411468910';

  // 1. Initialize SDK
  static Future<void> init() async {
    await MobileAds.instance.initialize();
    loadInterstitial(); // Preload on startup
  }

  // 2. Preload Interstitial
  static void loadInterstitial() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialReady = true;
        },
        onAdFailedToLoad: (error) {
          _isInterstitialReady = false;
          print("Interstitial failed to load: $error");
        },
      ),
    );
  }

  // 3. Show Interstitial with Safe Fallback
  static void showInterstitial() {
    if (_isInterstitialReady && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadInterstitial(); // Preload the next one
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          loadInterstitial();
        },
      );
      _interstitialAd!.show();
    } else {
      print("Ad not ready yet. Skipping to maintain flow.");
    }
  }
}