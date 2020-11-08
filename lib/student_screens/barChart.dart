import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class barChart extends StatefulWidget {
  final average;
  final individual;

  const barChart({Key key, this.average, this.individual}) : super(key: key);
  @override
  _barChartState createState() => _barChartState();
}

class _barChartState extends State<barChart> {
  List<MeanData> data = [];
  @override
  Widget build(BuildContext context) {
    data = [
      MeanData(name: 'Average Score', count: widget.average),
      MeanData(name: 'Your Score', count: widget.individual)
    ];
    List<charts.Series<MeanData, String>> series = [
      charts.Series(
        
          id: 'graph',
          data: data,
          domainFn: (MeanData series, _) => series.name,
          measureFn: (MeanData series, _) => series.count,
        
          colorFn: (MeanData segment, _) =>
              charts.MaterialPalette.purple.makeShades(2).elementAt(1),
          labelAccessorFn: (MeanData series, _) => '${series.count.toString()}')
    ];

    return charts.BarChart(
      series,
      vertical: true,
      animate: true,
      animationDuration: Duration(milliseconds: 700),

      primaryMeasureAxis: new charts.NumericAxisSpec(
          tickProviderSpec:
              new charts.BasicNumericTickProviderSpec(desiredTickCount: 5)),
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis: new charts.OrdinalAxisSpec(),
    );
  }
}

class MeanData {
  String name;
  int count;
  MeanData({this.count, this.name});
}
