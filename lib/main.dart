import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class MyHomePage extends StatelessWidget {
  final myController = TextEditingController();
  late List<TextInputFormatter>? inputFormatters;

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
              controller: myController,
              onChanged: (text) {
                // TODO: ここで取得したheightを使う
                print("$text");
              },
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
              onChanged: (weight) {
                // TODO: ここで取得したweightを使う
                print("体重$weight");
              },
            ),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.create),
                hintText: '～kg',
                labelText: '目標体重',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                  child: Text('決定'),
                  onPressed: () {
                    //todo フォーカスするためのコード
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
