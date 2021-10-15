import 'package:flutter/material.dart';

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
      body: Column(),
    );
  }
}
