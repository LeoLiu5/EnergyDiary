import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:screen_loader/screen_loader.dart';
import 'dart:convert';
import 'Capsule_wave_view.dart';
import 'glass_view.dart';
import '../mqtt receiver.dart';
import '../app_theme.dart';

class printer1 extends StatefulWidget {
  @override
  _printer1State createState() => _printer1State();
}

//"ScreenLoader" shows and hides the loader without updating the
//state of the widget which increases the performance
class _printer1State extends State<printer1> with ScreenLoader {
  @override
  void initState() {
    startMQTT();
    super.initState();
  }

  updateList(String z, double a, String i, double h, double g, int f, int e,
      int d, int c, double b) {
    setState(() {
      Time = z;
      Today = a;
      TotalStartTime = i;
      Yesterday = h;
      Total = g;
      Power = f;
      ApparentPower = e;
      ReactivePower = d;

      Voltage = c;
      Current = b;
    });
  }

  Future<void> startMQTT() async {
    client.port = 1884;
    client.setProtocolV311();
    client.keepAlivePeriod = 10;

    try {
      await client.connect(username, password);
    } catch (e) {
      print('client exception - $e');
      client.disconnect();
    }
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('Mosquitto client connected');

      startLoading(); //Function from the "screen_loader" library, Showing the Loading screen while connecting to the MQTT server
    } else {
      print(
          'ERROR Mosquitto client connection failed - disconnecting, state is ${client.connectionStatus!.state}');
      client.disconnect();
    }
    const topic1 = 'UCL/OPS/107/EM/gosund/peter-the-prusa-1/SENSOR';
    client.subscribe(topic1, MqttQos.atMostOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final receivedMessage = c![0].payload as MqttPublishMessage;
      final messageString = MqttPublishPayload.bytesToStringAsString(
          receivedMessage.payload.message);
      Convert convert = Convert.fromJson(jsonDecode(messageString));
      if (c[0].topic == topic1) {
        print(
            'Change notification:: topic is <${c[0].topic}>, payload is <-- $convert -->');

        updateList(
            convert.Time,
            convert.ENERGY.Today,
            convert.ENERGY.TotalStartTime,
            convert.ENERGY.Yesterday,
            convert.ENERGY.Total,
            convert.ENERGY.Power,
            convert.ENERGY.ApparentPower,
            convert.ENERGY.ReactivePower,
            convert.ENERGY.Voltage,
            convert.ENERGY.Current);
      }
      stopLoading(); //Function from the "screen_loader" library, Closing the Loading screen after the mqtt data is updated
    });
  }

  @override
  void dispose() {
    client.disconnect();
    print('client disconnected');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loadableWidget(
        child: Container(
            color: AppTheme.background,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                //Allow this page to be scrolled
                child: Stack(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(
                          top: 175,
                        ),
                        child: TitleView(
                          titleTxt: 'Peter, Multi-Filament 3D Printer 1',
                        )),
                    Padding(
                        padding: const EdgeInsets.only(top: 195),
                        child: PowerView()),
                    Padding(
                        padding: const EdgeInsets.only(
                          top: 418,
                        ),
                        child: TitleView(
                          titleTxt: 'Energy Consumption',
                        )),
                    Padding(
                        padding: const EdgeInsets.only(top: 435),
                        child: EnergyConsumption()),
                    Padding(
                        padding: const EdgeInsets.only(
                          top: 662,
                        ),
                        child: TitleView(
                          titleTxt: 'Electricity',
                        )),
                    Padding(
                        padding: const EdgeInsets.only(top: 681),
                        child: Electricity()),
                    Padding(
                        padding: EdgeInsets.only(
                            top: 940,
                            left: 0.23 * MediaQuery.of(context).size.width),
                        child: IconView()),
                    getAppBarUI(),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom,
                    )
                  ],
                ),
              ),
              // The Refresh floating button
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endContained,
              floatingActionButton: FloatingActionButton(
                focusColor: Colors.green,
                tooltip: 'Refresh this Page',
                autofocus: true,
                onPressed: startMQTT,
                child: Icon(Icons.refresh),
              ),
            )));
  }

  Widget getAppBarUI() {
    return Column(children: <Widget>[
      Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32.0),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: AppTheme.grey.withOpacity(0.5),
                offset: const Offset(1.1, 1.1),
                blurRadius: 10.0),
          ],
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Energy Diary',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          letterSpacing: 1.2,
                          color: AppTheme.darkerText,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 38,
                    width: 38,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(32.0)),
                      onTap: () {},
                      child: Center(
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          color: AppTheme.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                    ),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.calendar_today,
                            color: AppTheme.grey,
                            size: 18,
                          ),
                        ),
                        Text(
                          '${Time.substring(0, 10)}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            letterSpacing: -0.2,
                            color: AppTheme.darkerText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 38,
                    width: 38,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(32.0)),
                      onTap: () {},
                      child: Center(
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: AppTheme.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ]);
  }

  Widget PowerView() {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
              topRight: Radius.circular(68.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: AppTheme.grey.withOpacity(0.2),
                offset: Offset(1.1, 1.1),
                blurRadius: 10.0),
          ],
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                height: 48,
                                width: 2,
                                decoration: BoxDecoration(
                                  color: HexColor('#87A0E5').withOpacity(0.5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4, bottom: 2),
                                      child: Text(
                                        'Apparent Power (S)',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          letterSpacing: -0.1,
                                          color: AppTheme.grey.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 28,
                                          height: 28,
                                          child: Image.asset(
                                              "assets/app/eaten.png"),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4, bottom: 3),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4, bottom: 3),
                                          child: Text(
                                            '$ApparentPower VA',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontName,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              letterSpacing: -0.2,
                                              color: AppTheme.grey
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                height: 48,
                                width: 2,
                                decoration: BoxDecoration(
                                  color: HexColor('#F56E98').withOpacity(0.5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4, bottom: 2),
                                      child: Text(
                                        'Reactive Power (Q)',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          letterSpacing: -0.1,
                                          color: AppTheme.grey.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 28,
                                          height: 28,
                                          child: Image.asset(
                                              "assets/app/burned.png"),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4, bottom: 3),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4, bottom: 3),
                                          child: Text(
                                            '$ReactivePower VAR',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontName,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              letterSpacing: -0.2,
                                              color: AppTheme.grey
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: AppTheme.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100.0),
                                ),
                                border: new Border.all(
                                    width: 4,
                                    color: AppTheme.nearlyDarkBlue
                                        .withOpacity(0.2)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Active Power (P)     $Power W',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      letterSpacing: 0.0,
                                      color: AppTheme.grey.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),

                            //Adding the blue color gradient to represent the current active power value.

                            child: CustomPaint(
                              painter: CurvePainter(
                                  colors: [
                                    AppTheme.nearlyDarkBlue,
                                    HexColor("#8A98E8"),
                                    HexColor("#8A98E8")
                                  ],
                                  //The maxmium active power is estimated as around 10 W.
                                  //Tne responsive circle is 360 degree and is then
                                  //divided into 10 portions (36 degrees each):
                                  angle: (10 * Power).toDouble()),
                              child: SizedBox(
                                width: 108,
                                height: 108,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget EnergyConsumption() {
    return Container(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
                topRight: Radius.circular(68.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: AppTheme.grey.withOpacity(0.2),
                  offset: Offset(1.1, 1.1),
                  blurRadius: 10.0),
            ],
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 4, bottom: 8, top: 16),
                      child: Text(
                        'Total',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            letterSpacing: -0.1,
                            color: AppTheme.darkText),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 4, bottom: 3),
                              child: Text(
                                '$Total',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 32,
                                  color: AppTheme.nearlyDarkBlue,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8, bottom: 8),
                              child: Text(
                                'kWh',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  letterSpacing: -0.2,
                                  color: AppTheme.nearlyDarkBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  color: AppTheme.grey.withOpacity(0.5),
                                  size: 16,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    'Since ${TotalStartTime.substring(0, 10)}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      letterSpacing: 0.0,
                                      color: AppTheme.grey.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 8, bottom: 8),
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 8, bottom: 16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '$Today kWh',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              letterSpacing: -0.2,
                              color: AppTheme.darkText,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              'Today',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: AppTheme.grey.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '$Yesterday kWh',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  letterSpacing: -0.2,
                                  color: AppTheme.darkText,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  'Yesterday',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: AppTheme.grey.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                '${(Today - Yesterday).toStringAsFixed(3)} kWh',
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  letterSpacing: -0.2,
                                  color: AppTheme.darkText,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  'Change',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: AppTheme.grey.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget Electricity() {
    return Container(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
                topRight: Radius.circular(68.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: AppTheme.grey.withOpacity(0.2),
                  offset: const Offset(1.1, 1.1),
                  blurRadius: 10.0),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 4, bottom: 3),
                                child: Text(
                                  '$Voltage',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 32,
                                    color: AppTheme.nearlyDarkBlue,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 8),
                                child: Text(
                                  'V',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    letterSpacing: -0.2,
                                    color: AppTheme.nearlyDarkBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              top: 4,
                              bottom: 14,
                            ),
                            child: Text(
                              'Voltage, the energy per unit charge in volts.',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                letterSpacing: 0.0,
                                color: AppTheme.darkText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 4, right: 4, top: 8, bottom: 16),
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: AppTheme.background,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Icon(
                                    Icons.access_time,
                                    color: AppTheme.grey.withOpacity(0.5),
                                    size: 16,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    '$Current A',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      letterSpacing: 0.0,
                                      color: AppTheme.grey.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 13, right: 17),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Image.asset('assets/app/bell.png'),
                                  ),
                                  Flexible(
                                    child: Text(
                                      'Current, the rate of flow of electric charge in ampere.',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        letterSpacing: 0.0,
                                        color: HexColor('#F65283'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 34,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.nearlyWhite,
                          shape: BoxShape.circle,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: AppTheme.nearlyDarkBlue.withOpacity(0.4),
                                offset: const Offset(4.0, 4.0),
                                blurRadius: 8.0),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.battery_charging_full,
                            color: AppTheme.nearlyDarkBlue,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 28,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.nearlyWhite,
                          shape: BoxShape.circle,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: AppTheme.nearlyDarkBlue.withOpacity(0.4),
                                offset: const Offset(4.0, 4.0),
                                blurRadius: 8.0),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.battery_full,
                            color: AppTheme.nearlyDarkBlue,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8, top: 16),
                  child: Container(
                    width: 60,
                    height: 160,
                    decoration: BoxDecoration(
                      color: HexColor('#E8EDFE'),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(80.0),
                          bottomLeft: Radius.circular(80.0),
                          bottomRight: Radius.circular(80.0),
                          topRight: Radius.circular(80.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: AppTheme.grey.withOpacity(0.4),
                            offset: const Offset(2, 2),
                            blurRadius: 4),
                      ],
                    ),
                    child: WaveView(
                      percentageValue: (Voltage-216.2) / 36.8 * 100,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
