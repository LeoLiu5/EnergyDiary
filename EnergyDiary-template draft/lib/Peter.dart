import 'package:flutter/material.dart';
import 'Peter2.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:convert';

class PeterD extends StatefulWidget {
  const PeterD({Key? key}) : super(key: key);

  @override
  State<PeterD> createState() => PeterDState();
}

class PeterDState extends State<PeterD> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Peter Diary'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Column(
            children: [
              Petercontent(),
              Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: Peter(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: list(),
              ),
            ],
          )),
    );
  }
}

class Petercontent extends StatelessWidget {
  const Petercontent({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 75.0, top: 40.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              // child: Image.asset('image/'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50.0, top: 100.0),
            child: Container(
              child: Column(
                children: [
                  Text(
                    'Prusa MMU2S multi-filament printer 1',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class list extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Column(children: [
          ElevatedButton(
            child: Text('Peter, Prusa 1'),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return PeterC();
              }));
            },
          ),
        ]),
      ]),
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
    return '{ ${this.TotalStartTime}, ${this.Yesterday}, ${this.Today}, ${this.Period}, ${this.Power}, ${this.ApparentPower}, ${this.ReactivePower}, ${this.Factor}, ${this.Voltage}, ${this.Current} }';
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

class Peter extends StatefulWidget {
  @override
  PeterState createState() {
    return PeterState();
  }
}

class PeterState extends State<Peter> {
  String? Yesterday;
  String? Today;
  String? Power;
  String? Total;
  String? Time;
  final client = MqttServerClient('mqtt.cetools.org', 'mandymadongyiaka');

  @override
  void initState() {
    super.initState();

    Yesterday = "connecting.....";
    Today = "connecting.....";
    Power = "connecting.....";
    Total = "connecting.....";
    Time = "connecting.....";
    startMQTT();
  }

  @override
  void dispose() {
    client.disconnect();
    print('client disconnected');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Text(
          'Total energy used: $Total',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 20),
        ),
        Text(
          'since $Time',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 20),
        ),
        Text(
          'Yesterday energy used: $Yesterday',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 20),
        ),
        Text(
          'Today energy used: $Today',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 20),
        ),
        Text(
          'Current power usage: $Power',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 20),
        ),
      ],
    ));
  }

  updateList(String y, String t, String T, String Ti, String p) {
    setState(() {
      Yesterday = y;

      Today = t;

      Total = T;
      Time = Ti;
      Power = p;
    });
  }

  Future<void> startMQTT() async {
    client.port = 1884;
    client.setProtocolV311();
    client.keepAlivePeriod = 10;
    const String username = 'student';
    const String password = 'ce2021-mqtt-forget-whale';
    try {
      await client.connect(username, password);
    } catch (e) {
      print('client exception - $e');
      client.disconnect();
    }
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('Mosquitto client connected');
    } else {
      print(
          'ERROR Mosquitto client connection failed - disconnecting, state is ${client.connectionStatus!.state}');
      client.disconnect();
    }
    const topic1 = 'UCL/OPS/107/EM/gosund/penelope-the-prusa-4/SENSOR';
    client.subscribe(topic1, MqttQos.atMostOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final receivedMessage = c![0].payload as MqttPublishMessage;
      final messageString = MqttPublishPayload.bytesToStringAsString(
          receivedMessage.payload.message);
      Tutorial tutorial = Tutorial.fromJson(jsonDecode(messageString));

      print(
          'Change notification:: topic is <${c[0].topic}>, payload is <-- $tutorial -->');

      if (c[0].topic == topic1) {
        updateList(
            tutorial.ENERGY.Yesterday.toString(),
            tutorial.ENERGY.Today.toString(),
            tutorial.ENERGY.Total.toString(),
            tutorial.ENERGY.TotalStartTime.toString(),
            tutorial.ENERGY.Power.toString());
      }
    });
  }
}
