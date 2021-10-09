import 'package:flutter/material.dart';
import 'package:health_app/second_page/weight_data.dart';
import 'package:health_app/third_page/weight_list_model.dart';
import 'package:provider/provider.dart';

class WeightListPage extends StatefulWidget {
  @override
  _WeightListPageState createState() => _WeightListPageState();
}

class _WeightListPageState extends State<WeightListPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WeightListModel>(
      create: (_) => WeightListModel()..fetchWeightList(),
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
          child: Consumer<WeightListModel>(builder: (context, model, child) {
            final List<WeightData>? today = model.today;
            if (today == null) {
              return CircularProgressIndicator();
            }

            final List<Widget> widgets = today
                .map(
                  (weightData) => ListTile(
                    title: Text(
                      weightData.weight.toString(),
                    ),
                    subtitle: Text(
                      weightData.date.toString(),
                    ),
                  ),
                )
                .toList();
            return ListView(
              children: widgets,
            );
          }),
        ),
      ),
    );
  }
}
