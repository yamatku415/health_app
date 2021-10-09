import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_app/add_weight/add_weight_page.dart';
import 'package:health_app/second_page/line_graph.dart';
import 'package:health_app/third_page/weight_list_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
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
        child: Form(
          key: _formKey, // 作成したフォームキーを指定
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: heightController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.create),
                    hintText: '0.0cm',
                    labelText: '身長'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return '入力してください';
                  }
                },
              ),
              TextFormField(
                controller: weightController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.create),
                  hintText: '0.0kg',
                  labelText: '体重',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return '入力してください';
                  }
                },
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    // 送信ボタンクリック時の処理
                    onPressed: () {
                      // バリデーションチェック
                      if (_formKey.currentState!.validate()) {
                        //todo フォーカスするためのコード
                        nowHeight = double.parse(heightController.text);
                        nowWeight = double.parse(weightController.text);
                        setState(() {
                          ideal = (nowWeight - (nowWeight * 0.02 * 6))
                              .toStringAsFixed(1);
                        });
                      }
                    },
                    child: Text('決定'),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                      child: Text('今日の体重記入'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddWeightPage(),
                            ));
                      }),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                      child: Text('体重リスト'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WeightListPage(),
                            ));
                      }),
                ),
              ),
              Center(
                child: TextButton(
                  child: Text('グラフ'),
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
              ),
              if (ideal != null) Center(child: Text('あなたの目標体重は$ideal.です')),
            ],
          ),
        ),
      ),
    );
  }
}
