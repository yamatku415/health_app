import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/first_page/todayweight_.dart';
import 'package:health_app/second_page/weight_data.dart';
import 'package:provider/provider.dart';

class WeightList extends StatelessWidget {
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
      body: Column(
        children: [
          Consumer<WeightModel>(builder: (context, model, child) {
            final List<WeightData>? today = model.today;

            if (today == null) {
              return CircularProgressIndicator();
            }
            final List<Widget> widget = today
                .map(
                  (weightData) => ListTile(
                    title: Text(weightData.date.toString()),
                    subtitle: Text(weightData.weight.toString()),
                  ),
                )
                .toList();
            return ListView();
          }),
        ],
      ),
    );
  }
}
