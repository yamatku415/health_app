import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

void main() {
  runApp(LineGraph());
}

class LineGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GraphPage(),
    );
  }
}

///日付と体重を持つクラスを作成
class WeightData {
  final DateTime date;
  final double weight;

  WeightData(this.date, this.weight);
}

///表示するページ
class GraphPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('折れ線グラフだお'),
            Container(
              height: 500,
              //グラフ表示部分
              child: charts.TimeSeriesChart(
                _createWeightData(weightList),
              ),
            ),
          ],
        ),
      ),
    );
  }

//WeightDataのリストを作成。好きな日付と体重入れよう
  final weightList = <WeightData>[
    WeightData(DateTime(2020, 10, 2), 50),
    WeightData(DateTime(2020, 10, 3), 53),
    WeightData(DateTime(2020, 10, 4), 40)
  ];

//上のリストからグラフに表示させるデータを生成
  List<charts.Series<WeightData, DateTime>> _createWeightData(
      List<WeightData> weightList) {
    return [
      charts.Series<WeightData, DateTime>(
        id: 'Muscles',
        data: weightList,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (WeightData weightData, _) => weightData.date,
        measureFn: (WeightData weightData, _) => weightData.weight,
      )
    ];
  }
}
