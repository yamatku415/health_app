import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

void main() {
  runApp(LineGraph());
}

class LineGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp();
  }
}

///日付と体重を持つクラスを作成
class WeightData {
  GraphPage graphPage = GraphPage as GraphPage;
  late double weight;
  final DateTime date;
  WeightData(this.date, this.weight);
}

///表示するページ
class GraphPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: FloatingActionButton(
          child: Text('戻る'),
          onPressed: () {
            // 1つ前に戻る
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('体重グラフ'),
            Container(
              height: 500,
              //グラフ表示部分
              child: charts.TimeSeriesChart(
                _createWeightData(
                  weightList,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//WeightDataのリストを作成。好きな日付と体重入れよう
  //z ここをmain.dartから引っ張ってきた数字を代入して表示
  final weightList = <WeightData>[
    WeightData(DateTime(2020, 10, 2), 80),
    WeightData(DateTime(2020, 10, 3), 77),
    WeightData(DateTime(2020, 10, 4), 73),
    WeightData(DateTime(2020, 10, 5), 69),
    WeightData(DateTime(2020, 10, 6), 66),
    WeightData(DateTime(2020, 10, 7), 65),
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
