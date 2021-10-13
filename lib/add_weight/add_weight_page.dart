import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'add_weight_model.dart';

class AddWeightPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddWeightModel>(
      create: (_) => AddWeightModel(),
      child: Scaffold(
        appBar: AppBar(
          leading: FloatingActionButton(
            child: Text('戻る'),
            onPressed: () {
              // 1つ前に戻る
              Navigator.pop(context);
            },
          ),
          title: Center(child: Text('今日の体重を追加')),
        ),
        body: Center(
          child: Consumer<AddWeightModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.create),
                        hintText: '0.0kg',
                        labelText: '今日の体重'),
                    onChanged: (text) {
                      model.weight = text;
                    },
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.create),
                        hintText: '0000(00月00日)',
                        labelText: '今日の日付'),
                    onChanged: (text) {
                      model.date = text;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      //処理
                      try {
                        await model.addWeight();
                        //todo
                        final snackBar = SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('追加しました'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } catch (e) {
                        final snackBar = SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(e.toString()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Text('今日の体重を追加'),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
