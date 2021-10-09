import 'package:flutter/material.dart';
import 'package:health_app/add_weight/add_weight_page.dart';
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
          title: Center(child: Text('あなたの体重一覧')),
        ),
        body: Center(
          child: Consumer<WeightListModel>(builder: (context, model, child) {
            final List<ToWeightData>? today = model.today;
            if (today == null) {
              return CircularProgressIndicator();
            }

            final List<Widget> widgets = today
                .map(
                  (toWeightData) => ListTile(
                    title: Text(
                      toWeightData.toweight.toString(),
                    ),
                    subtitle: Text(
                      toWeightData.todate.toString(),
                    ),
                  ),
                )
                .toList();
            return ListView(
              children: widgets,
            );
          }),
        ),
        floatingActionButton:
            Consumer<WeightListModel>(builder: (context, model, child) {
          return FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async {
                // 1つ前に戻る
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddWeightPage(),
                  ),
                );
                model.fetchWeightList();
              });
        }),
      ),
    );
  }
}
