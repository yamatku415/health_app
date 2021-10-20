import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class GraphPage extends StatelessWidget {
  const GraphPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("chart")),
      body: Column(children: [Container(height: 240, child: _simpleLine())]),
    );
  }

  Widget _simpleLine() {
    var random = Random();

    //0のところうを日にち、ランダムの所を体重　　　date１を理想体重
    var data1 = [
      LinearSales(0, random.nextInt(100)),
      LinearSales(1, random.nextInt(100)),
      LinearSales(2, random.nextInt(100)),
      LinearSales(3, random.nextInt(100)),
    ];
    //date2を今日の体重で追加していく
    var data2 = [
      LinearSales(0, random.nextInt(100)),
      LinearSales(1, random.nextInt(100)),
    ];

    var seriesList = [
      charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFF6300A1)),
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        //dashPatternFn: (_, __) => [8, 2, 4, 2],
        data: data1,
      ),
      charts.Series<LinearSales, int>(
        id: 'Use',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFF13A331)),
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
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
