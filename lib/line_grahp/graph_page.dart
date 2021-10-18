import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:health_app/line_grahp/weight_data.dart';

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
      body: Stack(children: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('体重グラフ'),
              Container(
                height: 500,
                //グラフ表示部分
                child: charts.TimeSeriesChart(
                  _createWeightData(nowWeighList),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('体重グラフ'),
              Container(
                height: 500,
                //グラフ表示部分
                child: charts.TimeSeriesChart(
                  _anCreateWeightData(anWeightList),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

//WeightDataのリストを作成。好きな日付と体重入れよう
  //z ここをmain.dartから引っ張ってきた数字を代入して表示
  final nowWeighList = <NowWeightData>[
    NowWeightData(DateTime(2021, 10, 1), 80),
    NowWeightData(DateTime(2021, 10, 7), 77),
    NowWeightData(DateTime(2021, 10, 14), 73),
    NowWeightData(DateTime(2021, 10, 21), 69),
    NowWeightData(DateTime(2021, 10, 28), 66),
    NowWeightData(DateTime(2021, 11, 7), 65),
  ];

  final anWeightList = <AnWeightData>[
    AnWeightData(DateTime(2021, 10, 1), 70),
    AnWeightData(DateTime(2021, 10, 7), 67),
    AnWeightData(DateTime(2021, 10, 14), 63),
    AnWeightData(DateTime(2021, 10, 21), 59),
    AnWeightData(DateTime(2021, 10, 28), 56),
    AnWeightData(DateTime(2021, 11, 7), 55),
  ];

//上のリストからグラフに表示させるデータを生成
  List<charts.Series<NowWeightData, DateTime>> _createWeightData(
      List<NowWeightData> weightList) {
    return [
      charts.Series<NowWeightData, DateTime>(
        id: 'Muscles',
        data: weightList,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (NowWeightData nowWeightData, _) =>
            nowWeightData.nowDate ?? DateTime(2021, 10, 1),
        measureFn: (NowWeightData nowWeightData, _) => nowWeightData.nowWeight,
      )
    ];
  }

  List<charts.Series<AnWeightData, DateTime>> _anCreateWeightData(
      List<AnWeightData> anWeightList) {
    return [
      charts.Series<AnWeightData, DateTime>(
        id: 'AnMuscles',
        data: anWeightList,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (AnWeightData anWeightData, _) =>
            anWeightData.anData ?? DateTime(2021, 10, 1),
        measureFn: (AnWeightData anWeightData, _) => anWeightData.anWeight,
      )
    ];
  }
}
