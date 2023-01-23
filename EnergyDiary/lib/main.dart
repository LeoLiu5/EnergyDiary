import 'package:flutter/material.dart';
import 'Peter.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'app_theme.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';

const String username = 'student';
const String password = 'ce2021-mqtt-forget-whale';

final client = MqttServerClient('mqtt.cetools.org', 'LeoLiu');
double? Today;
String? TotalStartTime;
double? Yesterday;
double? Total;
int? Power;
int? ApparentPower;
int? ReactivePower;

int? Voltage;
double? Current;

int? Period;
double? Factor;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: 'Energy Diary',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: AppTheme.textTheme,
        platform: TargetPlatform.iOS,
      ),
      home: MyHomePage(),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

class User {
  String TotalStartTime;
  double Total;
  double Yesterday;
  double Today;
  int Period;
  int Power;
  int ApparentPower;
  int ReactivePower;
  double Factor;
  int Voltage;
  double Current;

  User(
      this.TotalStartTime,
      this.Total,
      this.Yesterday,
      this.Today,
      this.Period,
      this.Power,
      this.ApparentPower,
      this.ReactivePower,
      this.Factor,
      this.Voltage,
      this.Current);

  factory User.fromJson(dynamic json) {
    return User(
        json['TotalStartTime'] as String,
        json['Total'] as double,
        json['Yesterday'] as double,
        json['Today'] as double,
        json['Period'] as int,
        json['Power'] as int,
        json['ApparentPower'] as int,
        json['ReactivePower'] as int,
        json['Factor'] as double,
        json['Voltage'] as int,
        json['Current'] as double);
  }

  @override
  String toString() {
    return '{ ${this.TotalStartTime}, ${this.Total},${this.Yesterday}, ${this.Today}, ${this.Period}, ${this.Power}, ${this.ApparentPower}, ${this.ReactivePower}, ${this.Factor}, ${this.Voltage}, ${this.Current} }';
  }
}

class Tutorial {
  String Time;

  User ENERGY;

  Tutorial(this.Time, this.ENERGY);

  factory Tutorial.fromJson(dynamic json) {
    return Tutorial(json['Time'] as String, User.fromJson(json['ENERGY']));
  }

  @override
  String toString() {
    return '{ ${this.Time}, ${this.ENERGY}}';
  }
}
