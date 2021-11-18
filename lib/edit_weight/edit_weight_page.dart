import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_app/first_forms/my_home_page.dart';
import 'package:health_app/line_grahp/weight_data.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'edit_weight_model.dart';

class EditWeightPage extends StatefulWidget {
  final WeightData weightData;
  EditWeightPage(this.weightData);

  @override
  _EditWeightPageState createState() => _EditWeightPageState();
}

class _EditWeightPageState extends State<EditWeightPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditWeightModel>(
      create: (_) => EditWeightModel(widget.weightData),
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
                child: Column(children: [
                  TextFormField(
                    controller: model.weightController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.create),
                        hintText: '0.0kg',
                        labelText: '今日の体重'),
                    onChanged: (text) {
                      model.setToWeight(text);
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.all(50.0),
                    child: Column(
                      children: <Widget>[
                        Center(
                            child: Text(
                          'あなたの目標体重は${Kyouyuu.instance.ideal}です',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontStyle: FontStyle.italic),
                        )),
                        Container(
                            padding: const EdgeInsets.all(50.0),
                            child: Column(
                              children: <Widget>[
                                Center(
                                    child: Text(
                                        "${DateFormat('MM/dd/yyyy').format(_date)}")),
                                ElevatedButton(
                                  onPressed: () => _edSelectDate(context),
                                  child: Text('日付選択'),
                                )
                              ],
                            )),
                        ElevatedButton(
                          onPressed: () async {
                            //処理
                            try {
                              String date =
                                  DateFormat('MM/dd/yyyy').format(_date);
                              await model.update(
                                  model.weightController.text, date);
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
                          },
                          child: Text('変更する'),
                        )
                      ],
                    ),
                  )
                ]));
          }),
        ),
      ),
    );
  }

  DateTime _date = DateTime.now();
  Future<Null> _edSelectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2018),
        lastDate: DateTime.now().add(Duration(days: 360)));
    if (picked != null) {
      setState(() => _date = picked);
    }
  }
}
