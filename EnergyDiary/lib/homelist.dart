import 'Peter.dart';
import 'package:flutter/widgets.dart';
import 'printer2.dart';
import 'printer3.dart';

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
      navigateScreen: PeterD(),
    ),
    HomeList(
      imagePath: 'assets/introduction_animation/introduction_animation.png ',
      navigateScreen: printer2(),
    ),
    HomeList(
      imagePath: 'assets/introduction_animation/introduction_animation.png  ',
      navigateScreen: printer3(),
    ),
    // HomeList(
    //   imagePath: ' ',
    //   navigateScreen:  ,
    // ),
  ];
}
