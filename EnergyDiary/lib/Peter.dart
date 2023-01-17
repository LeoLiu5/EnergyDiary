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
  final client = MqttServerClient('mqtt.cetools.org', 'mandymadongyiaka');

  @override
  void initState() {
    super.initState();

    Yesterday = "connecting.....";
    Today = "connecting.....";
    Power = "connecting.....";
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
          'Current Power: $Power',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 20),
        ),
      ],
    ));
  }

  updateList(String s, int i) {
    setState(() {
      if (i == 1) {
        Yesterday = s;
      }
      if (i == 1) {
        Today = s;
      }
      if (i == 1) {
        Power = s;
      }
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
      Map<String, dynamic> data = json.decode(messageString);
      print('Data from JSON: ${data['message']}');

      print(
          'Change notification:: topic is <${c[0].topic}>, payload is <-- $messageString -->');

      if (c[0].topic == topic1) {
        updateList(messageString, 1);
      }
    });
    print('subscribed');
  }
}
