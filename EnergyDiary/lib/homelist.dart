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
    this.title = '',
  });

  Widget? navigateScreen;
  String imagePath;
  String title;

  static List<HomeList> homeList = [
    HomeList(
      imagePath: 'assets/introduction_animation/Peter.jpeg',
      navigateScreen: printer1(),
      title: 'Peter',
    ),
    HomeList(
      imagePath: 'assets/introduction_animation/Pertuina.jpeg',
      navigateScreen: printer2(),
      title: 'Pertuina',
    ),
    HomeList(
      imagePath: 'assets/introduction_animation/Paul.jpeg',
      navigateScreen: printer3(),
      title: 'Paul',
    ),
    HomeList(
      imagePath: 'assets/introduction_animation/Penelope.jpeg',
      navigateScreen: printer4(),
      title: 'Penelope',
    ),
    HomeList(
      imagePath: 'assets/introduction_animation/Sally.jpeg',
      navigateScreen: screen1(),
      title: 'Sally',
    ),
    HomeList(
      imagePath: 'assets/introduction_animation/Sammy.jpeg',
      navigateScreen: screen2(),
      title: 'Sammy',
    ),
    HomeList(
      imagePath: 'assets/introduction_animation/Sandy.jpeg',
      navigateScreen: SolderStation(),
      title: 'Sandy',
    ),
  ];
}
