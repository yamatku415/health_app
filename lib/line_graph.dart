import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:health_app/weight_data.dart';
import 'package:health_app/wight_data.dart';

class GraphPage extends StatefulWidget {
  GraphPage();

  @override
  _GraphPageState createState() => _GraphPageState();
}

///表示するページ
class _GraphPageState extends State<GraphPage> {
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
    WeightData(DateTime(2021, 10, 1), 80),
    WeightData(DateTime(2021, 10, 7), 77),
    WeightData(DateTime(2021, 10, 14), 73),
    WeightData(DateTime(2021, 10, 21), 69),
    WeightData(DateTime(2021, 10, 28), 66),
    WeightData(DateTime(2021, 11, 7), 65),
  ];

//上のリストからグラフに表示させるデータを生成
  List<charts.Series<WeightData, DateTime>> _createWeightData(
      List<WeightData> weightList) {
    return [
      charts.Series<WeightData, DateTime>(
        id: 'Muscles',
        data: weightList,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (WeightData weightData, _) =>
            weightData.date ?? DateTime(2021, 10, 1),
        measureFn: (WeightData weightData, _) => weightData.weight,
      )
    ];
  }
}
