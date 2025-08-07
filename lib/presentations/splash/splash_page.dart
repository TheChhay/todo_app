import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app/configs/appUnitid.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const String _noteBook = 'assets/lotties/note.json';


  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

    InterstitialAd? _interstitialAd;
  bool isInterstitialReady = false;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 2500), () {
      context.goNamed('home');
    });
    // MARK:screen ads
    _loadInterstitialAd();

  }

  // Call this method anywhere to show the interstitial ad
  void showInterstitialAd() {
    if (isInterstitialReady && _interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null;
      isInterstitialReady = false;
      
    }
  }

    void _loadInterstitialAd() {
    InterstitialAd.load(
      // adUnitId: AppUnitId.interstitialDev,
      adUnitId: AppUnitId.interstitialProd,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          isInterstitialReady = true;
          showInterstitialAd(); // Show as soon as loaded
        },
        onAdFailedToLoad: (error) {
          isInterstitialReady = false;
          debugPrint('Interstitial failed: $error');
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Animate(
                effects: [FadeEffect(), ScaleEffect()],
                child: Text("To do list!", style: TextStyle(fontSize: 30.0.sp),),
                ),
              Lottie.asset(
                SplashPage._noteBook,
                width: 200.w,
                height: 200.w,
                // repeat: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
