import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:health_app/first_forms/my_home_page.dart';
import 'package:health_app/line_grahp/weight_data.dart';
import 'package:provider/provider.dart';

import 'graph_data.dart';

class GraphPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GraphData>(
      create: (_) => GraphData()..fetchWeightGraph(),
      child: Scaffold(
        appBar: AppBar(title: Text("体重グラフ")),
        body: Consumer<GraphData>(builder: (context, model, child) {
          final List<WeightDataGraph>? today = model.today;
          if (today == null) {
            return CircularProgressIndicator();
          }

          return Column(
              children: [Container(height: 240, child: _simpleLine(today))]);
        }),
      ),
    );
  }

  Widget _simpleLine(List<WeightDataGraph> today) {
    //0のところうを日にち、ランダムの所を体重　　　date１を理想体重  for文

    final since = DateTime(2021, 10, 11);
    final data1 = [
      LinearSales(DateTime(2021, 10, 12), '74.1'),
      LinearSales(DateTime(2021, 10, 13), '74.6'),
      LinearSales(DateTime(2021, 10, 14), '72.9'),
      LinearSales(DateTime(2021, 10, 15), '69.1'),
      LinearSales(DateTime(2021, 10, 16), '60.1'),
    ];

    //date2を今日の体重で追加していく
    ///firestoreから数値を持ってる方法を考える。

    //sinceの所でDateTime(2021, 11, 1)から最後の日の差分の数値が取れ、横軸にintで与えられる。
    var seriesList = [
      charts.Series<LinearSales, num>(
        id: 'ideal',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFFFFA000)),
        domainFn: (ideal, _) => ideal.year.difference(since).inDays,
        measureFn: (ideal, _) => double.parse(ideal.sales),
        dashPatternFn: (_, __) => [8, 2, 4, 2],
        data: data1,
      ),

      //FireStoreから持ってきたdatetimeをint.numにして使わなければならない。
      charts.Series<WeightDataGraph, num>(
        id: 'locust',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFF13A331)),
        domainFn: (locust, _) => locust.date.difference(since).inDays,
        measureFn: (locust, _) => double.parse(locust.weight),
        //dashPatternFn: (_, __) => [8, 2, 4, 2],
        data: today,
      ),
    ];

    return charts.LineChart(seriesList, animate: true);
  }

  void weightIdealGraph() {
    for (num W = Kyouyuu.instance.nowWeight!;
        W <= Kyouyuu.instance.ideal!;
        Kyouyuu.instance.nowWeight! - Kyouyuu.instance.ideal! / 180) {
//ここの値をdate１に入れたい

    }
    //終わりの値は使わない
  }
}
//一時べた書き用のクラス

class LinearSales {
  final DateTime year;
  final String sales;

  LinearSales(this.year, this.sales);
}
