import 'package:flutter/material.dart';
// import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/services.dart';
import 'dart:io'
    show
        Platform; //Information about the environment in which the current program is running.
import 'home_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // running on the web!
import 'dart:math' as math;
import 'package:screen_loader/screen_loader.dart';

const String username = 'student';
const String password = 'ce2021-mqtt-forget-whale';
final client = MqttServerClient('mqtt.cetools.org', 'LeoLiu');

double Today = 1.0;
String TotalStartTime = '2022-11-16';
double Yesterday = 1.0;
double Total = 1.0;
int Power = 0;
int ApparentPower = 0;
int ReactivePower = 0;
String Time = '2022-11-16';
int Voltage = 236;
double Current = 1.0;
int Period = 0;
double Factor = 1.0;

//Prevent device orientation changes and force portrait up and down
Future<void> main() async {
  //Global loading screen
  configScreenLoader(
    loader: AlertDialog(
      title: Text('Connecting to MQTT...'),
    ),
    bgBlur: 20.0,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

//change the status bar colour to transparent
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
        platform: TargetPlatform.iOS,
      ),
      home: MyHomePage(),
    );
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
  final String Time;
  final User ENERGY;

  Tutorial(this.Time, this.ENERGY);

  factory Tutorial.fromJson(dynamic json) {
    return Tutorial(json['Time'] as String, User.fromJson(json['ENERGY']));
  }

  @override
  String toString() {
    return '{ ${this.Time}, ${this.ENERGY}}';
  }
}

class CurvePainter extends CustomPainter {
  final double? angle;
  final List<Color>? colors;

  CurvePainter({this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color> colorsList = [];
    if (colors != null) {
      colorsList = colors ?? [];
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }

    final shdowPaint = new Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final shdowPaintCenter = new Offset(size.width / 2, size.height / 2);
    final shdowPaintRadius =
        math.min(size.width / 2, size.height / 2) - (14 / 2);
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.3);
    shdowPaint.strokeWidth = 16;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.2);
    shdowPaint.strokeWidth = 20;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.1);
    shdowPaint.strokeWidth = 22;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = new SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList,
    );
    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        paint);

    final gradient1 = new SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = new Paint();
    cPaint..shader = gradient1.createShader(rect);
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle! + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(new Offset(0, 0), 14 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
