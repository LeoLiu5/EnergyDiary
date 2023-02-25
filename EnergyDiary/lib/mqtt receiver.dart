import 'package:mqtt_client/mqtt_server_client.dart';

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

class Convert {
  final String Time;
  final User ENERGY;

  Convert(this.Time, this.ENERGY);

  factory Convert.fromJson(dynamic json) {
    return Convert(json['Time'] as String, User.fromJson(json['ENERGY']));
  }

  @override
  String toString() {
    return '{ ${this.Time}, ${this.ENERGY}}';
  }
}
