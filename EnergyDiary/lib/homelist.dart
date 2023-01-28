import 'printer1.dart';
import 'package:flutter/widgets.dart';
import 'printer2.dart';
import 'printer3.dart';
import 'printer4.dart';
import 'screen1.dart';
import 'screen2.dart';
import 'SolderStation.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
  });

  Widget? navigateScreen;
  String imagePath;

  static List<HomeList> homeList = [
    HomeList(
      imagePath: 'assets/introduction_animation/introduction_animation.png',
      navigateScreen: printer1(),
    ),
    HomeList(
      imagePath: 'assets/introduction_animation/introduction_animation.png ',
      navigateScreen: printer2(),
    ),
    HomeList(
      imagePath: 'assets/introduction_animation/introduction_animation.png  ',
      navigateScreen: printer3(),
    ),
    HomeList(
      imagePath: 'assets/introduction_animation/introduction_animation.png ',
      navigateScreen: printer4(),
    ),
    HomeList(
      imagePath: 'assets/introduction_animation/introduction_animation.png ',
      navigateScreen: screen1(),
    ),
    HomeList(
      imagePath: 'assets/introduction_animation/introduction_animation.png ',
      navigateScreen: screen2(),
    ),
    HomeList(
      imagePath: 'assets/introduction_animation/introduction_animation.png ',
      navigateScreen: SolderStation(),
    ),
  ];
}
