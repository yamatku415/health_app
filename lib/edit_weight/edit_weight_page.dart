import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_app/first_forms/weight_data.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../back_ground.dart';
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
            title: Text('体重と日付の変更'),
          ),
          body: Stack(children: [
            AppBackground(),
            Center(
              child:
                  Consumer<EditWeightModel>(builder: (context, model, child) {
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
                            Container(
                                padding: const EdgeInsets.all(50.0),
                                child: Column(
                                  children: <Widget>[
                                    Center(
                                        child: Text(
                                            "${DateFormat('yyyy/MM/dd').format(DateTime.parse(model.date!.replaceAll('/', '-')))}")),
                                    ElevatedButton(
                                      onPressed: () async {
                                        DateTime _date = DateTime.parse(
                                            model.date!.replaceAll('/', '-'));

                                        final DateTime? picked =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: _date,
                                                firstDate: DateTime(2018),
                                                lastDate: DateTime.now()
                                                    .add(Duration(days: 360)));
                                        if (picked != null) {
                                          setState(() => model.date =
                                              DateFormat('yyyy/MM/dd')
                                                  .format(picked));
                                        }
                                      },
                                      child: Text('日付選択'),
                                    )
                                  ],
                                )),
                            ElevatedButton(
                              onPressed: () async {
                                //処理
                                try {
                                  String date = DateFormat('yyyy/MM/dd').format(
                                      DateTime.parse(
                                          model.date!.replaceAll('/', '-')));
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
          ])),
    );
  }
}
