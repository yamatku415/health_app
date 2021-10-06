import 'package:flutter/material.dart';
import 'package:health_app/second_page/weight_data.dart';
import 'package:health_app/third_page/weight_data_controller.dart';
import 'package:provider/provider.dart';

class WeightListPage extends StatefulWidget {
  @override
  _WeightListPageState createState() => _WeightListPageState();
}

class _WeightListPageState extends State<WeightListPage> {
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
      body: _buildBody(context),
    );
  }

  Stack _buildBody(BuildContext context) {
    final WeightDataController controller = Provider.of(context);
    return Stack(
      children: <Widget>[
        if (controller.today.isEmpty && !controller.isLoading)
          Scrollbar(
              child: RefreshIndicator(
                  onRefresh: () => controller.refresh(),
                  child: ListView(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("データがありません"),
                        ],
                      )
                    ],
                  ))),
        if (controller.today.isNotEmpty)
          Scrollbar(
            child: RefreshIndicator(
              onRefresh: () => controller.refresh(),
              child: ListView.separated(
                itemBuilder: (_, int index) {
                  WeightData today = controller.today[index];
                  return ListTile(
                    title: Text(
                      today.date.toString(),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    subtitle: Text(
                      today.weight.toString(),
                    ),
                  );
                },
                separatorBuilder: (_, __) {
                  return Divider(
                    height: 1,
                    indent: 15,
                    endIndent: 15,
                  );
                },
                itemCount: controller.today.length,
              ),
            ),
          ),
        if (controller.today.isEmpty && controller.isLoading)
          Center(
            child: CircularProgressIndicator(),
          )
      ],
    );
  }
}
