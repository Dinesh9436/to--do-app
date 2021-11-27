import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/ui_views/onboardinglayoutview.dart';

class LandingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffebe5dd),
      body: onBordingBody(),
    );
  }

  Widget onBordingBody() => Container(
        child: OnBoardingLayoutView(),
      );
}
