import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'line_graph.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  late List<TextInputFormatter>? inputFormatters;
  late double height;
  late double weight;
  var showBmiDialog;
  @override
  void initState() {
    super.initState();
    //myController.addListener(_Value);
  }

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
                    height = double.parse(heightController.text);
                    weight = double.parse(weightController.text);
                    showBmiDialog =
                        (weight - (weight * 0.02 * 6)).toStringAsFixed(1);
                  }),
            ),
            Container(
              width: 200,
              // 縦幅
              height: 50,
              child: Text(showBmiDialog),
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
