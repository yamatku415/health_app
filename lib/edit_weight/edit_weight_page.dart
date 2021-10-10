import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_app/line_grahp/weight_data.dart';
import 'package:provider/provider.dart';

import 'edit_weight_model.dart';

class EditWeightPage extends StatelessWidget {
  final ToWeightData toWeightData;
  EditWeightPage(this.toWeightData);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditWeightModel>(
      create: (_) => EditWeightModel(toWeightData),
      child: Scaffold(
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
          child: Consumer<EditWeightModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: model.toweightController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.create),
                        hintText: '0.0kg',
                        labelText: '今日の体重'),
                    onChanged: (text) {
                      model.setToWeight(text);
                    },
                  ),
                  TextFormField(
                    controller: model.todatetController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.create),
                        hintText: '0000(00月00日)',
                        labelText: '今日の日付'),
                    onChanged: (text) {
                      model.setToDte(text);
                    },
                  ),
                  ElevatedButton(
                    onPressed: model.isUpdated()
                        ? () async {
                            //処理
                            try {
                              await model.update();
                              final snackBar = SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('変更しました'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } catch (e) {
                              final snackBar = SnackBar(
                                content: Text(e.toString()),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                        : null,
                    child: Text('変更する'),
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
