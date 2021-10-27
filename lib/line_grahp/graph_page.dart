import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:health_app/line_grahp/weight_data.dart';
import 'package:health_app/weight_list/weight_list_model.dart';
import 'package:provider/provider.dart';

import 'graph_data.dart';

class GraphPage extends StatelessWidget {
  const GraphPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GraphData>(
      create: (_) => GraphData()..fetchWeightGraph(),
      child: Scaffold(
        appBar: AppBar(title: Text("体重グラフ")),
        body: Consumer<WeightListModel>(builder: (context, model, child) {
          final today = model.today;
          if (today == null) {
            return CircularProgressIndicator();
          }

          Column(children: [Container(height: 240, child: _simpleLine())]);
        }),
      ),
    );
  }

  Widget _simpleLine() {
    //0のところうを日にち、ランダムの所を体重　　　date１を理想体重  for文

    var data1 = [
      LinearSales(0, 80),
      LinearSales(1, 75),
      LinearSales(2, 70),
      LinearSales(3, 67),
    ];
    //date2を今日の体重で追加していく
    var data2 = [
      WeightDataGraph(DateTime(date), weight),
    ];

    var seriesList = [
      charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFFFFA000)),
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        dashPatternFn: (_, __) => [8, 2, 4, 2],
        data: data1,
      ),
      charts.Series<WeightDataGraph, int>(
        id: 'Use',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFF13A331)),
        domainFn: (WeightDataGraph sales, _) => int.parse(sales.date),
        measureFn: (WeightDataGraph sales, _) => int.parse(sales.weight),
        //dashPatternFn: (_, __) => [8, 2, 4, 2],
        data: data2,
      ),
    ];

    return charts.LineChart(seriesList, animate: true);
  }
}

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
