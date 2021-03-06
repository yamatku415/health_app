import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../back_ground.dart';
import 'add_weight_model.dart';

class AddWeightPage extends StatefulWidget {
  @override
  _AddWeightPage createState() => _AddWeightPage();
}

class _AddWeightPage extends State<AddWeightPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddWeightModel>(
      create: (_) => AddWeightModel(),
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('今日の体重を追加'),
          ),
          body: Stack(children: [
            AppBackground(),
            Center(
              child: Consumer<AddWeightModel>(builder: (context, model, child) {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(','))
                          ],
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              icon: Icon(Icons.create),
                              hintText: '0.0kg',
                              labelText: '今日の体重'),
                          onChanged: (text) {
                            model.weight = text;
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.all(50.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  padding: const EdgeInsets.all(50.0),
                                  child: Column(
                                    children: <Widget>[
                                      Center(
                                          child: Text(
                                              "${DateFormat('yyyy/MM/dd').format(_date)}")),
                                      ElevatedButton(
                                        onPressed: () => _selectDate(context),
                                        child: Text('日付選択'),
                                      )
                                    ],
                                  )),
                              ElevatedButton(
                                onPressed: () async {
                                  //処理
                                  try {
                                    String date =
                                        DateFormat('yyyy/MM/dd').format(_date);
                                    model.date = date;
                                    await model.addWeight();
                                    //todo
                                    final snackBar = SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text('追加しました'),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } catch (e) {
                                    final snackBar = SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(e.toString()),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                child: Text('今日の体重を追加'),
                              )
                            ],
                          ),
                        ),
                      ],
                    ));
              }),
            ),
          ])),
    );
  }

  DateTime _date = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
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
