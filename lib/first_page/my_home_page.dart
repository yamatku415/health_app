import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_app/second_page/line_graph.dart';
import 'package:health_app/third_page/weight_list.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final todayweightController = TextEditingController();
  late List<TextInputFormatter>? inputFormatters;
  late double nowHeight;
  late double nowWeight;
  late double todayweight;
  var ideal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '身長と体重を記入',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.create),
                hintText: '～cm',
                labelText: '身長',
              ),
              controller: heightController,
            ),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.create),
                hintText: '～kg',
                labelText: '体重',
              ),
              controller: weightController,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                  child: Text('決定'),
                  onPressed: () {
                    //todo フォーカスするためのコード
                    nowHeight = double.parse(heightController.text);
                    nowWeight = double.parse(weightController.text);
                    setState(() {
                      ideal = (nowWeight - (nowWeight * 0.02 * 6))
                          .toStringAsFixed(1);
                    });
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  child: Text('体重リストへ'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WeightList(),
                        ));
                  }),
            ),
            TextButton(
              child: Text('グラフへ'),
              onPressed: () {
                // 押したら反応するコードを書く
                // 画面遷移のコード
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GraphPage(),
                    ));
              },
            ),
            if (ideal != null) Text('あなたの目標体重は$ideal.です'),
          ],
        ),
      ),
    );
  }
}
