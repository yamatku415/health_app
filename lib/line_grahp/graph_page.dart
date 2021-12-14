import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:health_app/first_forms/my_home_page.dart';
import 'package:health_app/first_forms/weight_data.dart';
import 'package:provider/provider.dart';

import '../back_ground.dart';
import 'graph_data.dart';

class GraphPage extends StatefulWidget {
  @override
  _GraphPage createState() => _GraphPage();
}

class _GraphPage extends State<GraphPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GraphData>(
      create: (_) => GraphData()..fetchWeightGraph(),
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("体重グラフ"),
          ),
          body: Stack(children: [
            AppBackground(),
            Consumer<GraphData>(builder: (context, model, child) {
              final List<WeightDataGraph>? today = model.today;
              if (SharedValues.instance.ideal == null) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '現在の身長と体重を入力してください',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontStyle: FontStyle.italic,
                            fontSize: 19),
                      )),
                );
              }
              if (today == null) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '今日の体重を入力してください',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontStyle: FontStyle.italic,
                            fontSize: 19),
                      )),
                );
              }

              return InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(20.0),
                minScale: 0.1,
                maxScale: 1.6,
                child: Container(height: 500, child: _simpleLine(today)),
              );
            }),
          ])),
    );
  }

  Widget _simpleLine(List<WeightDataGraph> today) {
    final since = SharedValues.instance.firstDay;

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
    double a =
        (SharedValues.instance.nowWeight! - SharedValues.instance.ideal!) / 360;
    double b = a * 3;

    //計算式（1日あたりの減らすべき体重）

    double reWeight = SharedValues.instance.nowWeight!;

    for (int days = 0; days != 45; days++) {
      reWeight -= a;
      //reWeightではなく違う変数で三段階の計算を出した後に代入すれえば形になるのではないか

      linearSalesList.add(LinearSales(days, reWeight));
      if (reWeight <= SharedValues.instance.ideal!) {
        break;
      }
    }
    for (int days = 46; days != 90; days++) {
      reWeight -= b;
      //reWeightではなく違う変数で三段階の計算を出した後に代入すれえば形になるのではないか

      linearSalesList.add(LinearSales(days, reWeight));
      if (reWeight <= SharedValues.instance.ideal!) {
        break;
      }
    }
    for (int days = 91; days != 135; days++) {
      reWeight -= a;
      //reWeightではなく違う変数で三段階の計算を出した後に代入すれえば形になるのではないか

      linearSalesList.add(LinearSales(days, reWeight));
      if (reWeight <= SharedValues.instance.ideal!) {
        break;
      }
    }
    for (int days = 136; days != 180; days++) {
      reWeight -= b;
      //reWeightではなく違う変数で三段階の計算を出した後に代入すれえば形になるのではないか

      linearSalesList.add(LinearSales(days, reWeight));
      if (reWeight <= SharedValues.instance.ideal!) {
        break;
      }
    }
    return linearSalesList;
  }
}
