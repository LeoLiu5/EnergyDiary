import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../app_theme.dart';
class DeviceData {
  final String date;
  final double energyUsage;

  DeviceData({required this.date, required this.energyUsage});
}

class SingleDeviceGraph extends StatefulWidget {
  final String device;

  const SingleDeviceGraph({Key? key, this.device = ""}) : super(key: key);
  @override
  _SingleDeviceGraphState createState() => _SingleDeviceGraphState();
}

class _SingleDeviceGraphState extends State<SingleDeviceGraph> {
  List<DeviceData> _data = [];

  // get device => null;

  Future<void> _fetchData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Date")
        .get();

    List<DeviceData> data = [];
    snapshot.docs.forEach((doc) {
      Map<String, dynamic>? docData = doc.data() as Map<String, dynamic>?;

      if (docData != null && docData.containsKey('${widget.device}')) {

        DateTime date = DateTime.parse(doc.id);

        data.add(DeviceData(
          date: DateFormat.yMd().format(date),
          energyUsage: double.parse(docData['${widget.device}'].toString()),
        ));
        // print(DateFormat.yMd().format(date));
      }

    });

    setState(() {
      _data = data;
    });
  }


  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override

  Widget build(BuildContext context) {


    return _data.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Container(padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),

      child: Container(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),

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
      height: 430,
      // width: 300,
        child: SfCartesianChart(
          series: _createSeries(),
          primaryXAxis: DateTimeAxis(),
          title: ChartTitle(text: 'Monthly Energy Usage for ${widget.device}'),
          legend: Legend(isVisible: true),
          trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            tooltipSettings: InteractiveTooltip(
              enable: true,
              format: 'point.x , point.y kWh',
            ),
            markerSettings: TrackballMarkerSettings(
              borderWidth: 2,
              height: 10,
              width: 10,
              markerVisibility: TrackballVisibilityMode.visible,
              // markerType: TrackballMarkerType.circle,
            ),
          ),
        ),
        ),);
  }

  List<LineSeries<DeviceData, DateTime>> _createSeries() {
    _data.sort((a, b) => a.date.compareTo(b.date));
    return [
      LineSeries<DeviceData, DateTime>(
        dataSource: _data,
        xValueMapper: (DeviceData data, _) => DateFormat('M/d/y').parse(data.date),
        yValueMapper: (DeviceData data, _) => data.energyUsage,
        name: '${widget.device} Energy Usage (kWh)',
        markerSettings: MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
          color: Colors.blue,
          borderWidth: 1,
          width: 6,
          height: 6,
        ),

      ),
    ];
  }



}
