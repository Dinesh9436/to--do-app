import 'package:flutter/cupertino.dart';
import 'package:to_do_app/constants/constants.dart';

class Slider {
  final String sliderImageUrl;
  final String sliderHeading;
  final String sliderSubHeading;
  final String skipBtn;

  Slider(
      {required this.sliderImageUrl,
      required this.sliderHeading,
      required this.sliderSubHeading,
      required this.skipBtn});
}

final sliderArrayList = [
  Slider(
      sliderImageUrl: 'assets/images/1.png',
      sliderHeading: Constants.SLIDER_HEADING_1,
      sliderSubHeading: Constants.SLIDER_DESC1,
      skipBtn: Constants.SKIP),
  Slider(
      sliderImageUrl: 'assets/images/2.png',
      sliderHeading: Constants.SLIDER_HEADING_2,
      sliderSubHeading: Constants.SLIDER_DESC2,
      skipBtn: Constants.SKIP),
  Slider(
      sliderImageUrl: 'assets/images/3.png',
      sliderHeading: Constants.SLIDER_HEADING_3,
      sliderSubHeading: Constants.SLIDER_DESC3,
      skipBtn: ""),
  Slider(
      sliderImageUrl: 'assets/images/4.png',
      sliderHeading: Constants.SLIDER_HEADING_4,
      sliderSubHeading: Constants.SLIDER_DESC4,
      skipBtn: ""),
  Slider(
      sliderImageUrl: 'assets/images/5.png',
      sliderHeading: Constants.SLIDER_HEADING_5,
      sliderSubHeading: Constants.SLIDER_DESC5,
      skipBtn: ""),
];
