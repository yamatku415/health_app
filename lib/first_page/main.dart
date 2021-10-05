import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_app/first_page/todayweight_.dart';
import 'package:health_app/third_page/weight_list.dart';
import 'package:provider/provider.dart';

import '../second_page/line_graph.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WeightModel>(
      create: (_) => WeightModel()..todayWeightList(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final todayWeightController = TextEditingController();
  late List<TextInputFormatter>? inputFormatters;
  late double nowHeight;
  late double nowWeight;
  var ideal;

  // void _Value() {
  //   print("入力状況: ${myController.text}");
  // }

  // void _handleText(String e) {
  //   setState(() {
  //     height = e;
  //   });
  // }

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
                    ideal =
                        (nowWeight - (nowWeight * 0.02 * 6)).toStringAsFixed(1);
                    print(ideal);
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
          ],
        ),
      ),
    );
  }
}
