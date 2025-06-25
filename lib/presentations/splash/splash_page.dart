import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const String _noteBook = 'assets/lotties/note.json';


  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 2500),(){
      context.goNamed('home');
    });
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
