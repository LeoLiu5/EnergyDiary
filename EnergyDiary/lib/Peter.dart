import 'package:flutter/material.dart';

// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';

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
                )
              ],
            )));
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
              child: Image.asset('image/'),
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

  @override
  void initState() {
    super.initState();

    Yesterday = "connecting.....";
    Today = "connecting.....";
    Power = "connecting.....";
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
}
