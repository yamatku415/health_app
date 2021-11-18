import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:health_app/first_forms/my_home_page.dart';
import 'package:health_app/line_grahp/weight_data.dart';
import 'package:provider/provider.dart';

import 'graph_data.dart';

class GraphPage extends StatefulWidget {
  @override
  _GraphPage createState() => _GraphPage();
}

class _GraphPage extends State<GraphPage> {
  double mediaWidth = 80;
  double scaleWidthFactor = 1;

  double minWidth = 40;
  double maxWidth = 160;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GraphData>(
      create: (_) => GraphData()..fetchWeightGraph(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("体重グラフ"),
          leading: FloatingActionButton(
            child: Text('戻る'),
            onPressed: () {
              // 1つ前に戻る
              Navigator.pop(context);
            },
          ),
        ),
        body: Consumer<GraphData>(builder: (context, model, child) {
          final List<WeightDataGraph>? today = model.today;
          if (today == null) {
            return CircularProgressIndicator();
          }

          return Column(children: [
            Container(height: 600, child: _simpleLine(today)),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: double.infinity,
                height: double.infinity,
              ),
              onScaleUpdate: (ScaleUpdateDetails data) {
                if (mediaWidth * data.scale > minWidth &&
                    mediaWidth * data.scale < maxWidth) {
                  scaleWidthFactor = data.scale;
                  setState(() {});
                }
              },
              onScaleEnd: (ScaleEndDetails data) {
                mediaWidth = mediaWidth * scaleWidthFactor;
              },
            ),


          ]);
        }),
      ),
    );
  }

  Widget _simpleLine(List<WeightDataGraph> today) {
    final since = Kyouyuu.instance.firstDay;

    var seriesList = [
      charts.Series<LinearSales, num>(
        id: 'ideal',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFFFFA000)),
        domainFn: (ideal, _) => ideal.year, //180日までの数字を扱うことにする
        measureFn: (ideal, _) => ideal.weight,
        dashPatternFn: (_, __) => [8, 2, 4, 2],
        data: LinearSales.weightIdealGraph(),
      ),

      //FireStoreから持ってきたdatetimeをint.numにして使わなければならない。
      charts.Series<WeightDataGraph, num>(
        id: 'locust',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFF13A331)),
        domainFn: (locust, _) => locust.date.difference(since!).inDays,
        measureFn: (locust, _) => double.parse(locust.weight),
        //dashPatternFn: (_, __) => [8, 2, 4, 2],
        data: today,
      ),
    ];

    return charts.LineChart(seriesList, animate: true);
  }
}

class LinearSales {
  final int year;
  final double weight;
  LinearSales(this.year, this.weight);

  static List<LinearSales> weightIdealGraph() {
    final linearSalesList = <LinearSales>[];
    double a = (Kyouyuu.instance.nowWeight! - Kyouyuu.instance.ideal!) /
        180; //計算式（1日あたりの減らすべき体重）
    double reWeight = Kyouyuu.instance.nowWeight!;

    for (int days = 0; days != 180; days++) {
      reWeight -= a;
      linearSalesList.add(LinearSales(days, reWeight));
      if (reWeight <= Kyouyuu.instance.ideal!) {
        break;
      }
    }
    return linearSalesList;
  }
}
