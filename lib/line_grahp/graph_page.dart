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

          return Column(
              children: [Container(height: 240, child: _simpleLine(today))]);
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
  //sharedpreferencesで保存したときにyear変数に１８０日分保存できるのか

  static List<LinearSales> weightIdealGraph() {
    final linearSalesList = <LinearSales>[];
    double a = (Kyouyuu.instance.nowWeight! - Kyouyuu.instance.ideal!) /
        180; //計算式（1日あたりの減らすべき体重）
    double reWeight = Kyouyuu.instance.nowWeight!;

    for (int days = 0; days != 180; days++) {
      // どうすれば計算した値からまた新たに計算して数値を更新し続けられるのか
      ///この計算でメモリアウトしてるかもしれないので計算を確認しなおす。
      ///もしくはdayのように1づつ増えていく処理を書いてみる(多分計算のしかたのミス)

      reWeight -= a;
      linearSalesList.add(LinearSales(days, reWeight));
      if (reWeight <= Kyouyuu.instance.ideal!) {
        break;
      }
    }
    return linearSalesList;
  }
}
