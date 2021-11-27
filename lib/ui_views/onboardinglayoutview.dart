import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/constants/constants.dart';
import 'package:to_do_app/models/slider.dart';
import 'package:to_do_app/screens/home.dart';
import 'package:to_do_app/widgets/get_started_button.dart';
import 'package:to_do_app/widgets/slide_dots.dart';
import 'package:to_do_app/widgets/slider_item.dart';

class OnBoardingLayoutView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OnBoardingLayoutView();
}

class _OnBoardingLayoutView extends State<OnBoardingLayoutView> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) => SliderLayout();

  bool inFinalPage() {
    if (_currentPage == sliderArrayList.length - 1) {
      return true;
    }
    return false;
  }

  Widget SliderLayout() => Container(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.17),
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: sliderArrayList.length,
                itemBuilder: (ctx, i) => SlideItem(i),
              ),
            ),
            Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 25.0,
                        top: MediaQuery.of(context).size.width * 0.12),
                  ),
                ),
                Container(
                  alignment: AlignmentDirectional.center,
                  margin: EdgeInsets.only(
                      bottom: 0.0,
                      top: MediaQuery.of(context).size.height * 0.2),
                  child: inFinalPage()
                      ? GetStartedButton()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            for (int i = 0; i < sliderArrayList.length; i++)
                              if (i == _currentPage)
                                SlideDots(true)
                              else
                                SlideDots(false)
                          ],
                        ),
                ),
              ],
            )
          ],
        ),
      );
}
