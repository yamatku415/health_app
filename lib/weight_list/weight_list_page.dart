import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:health_app/add_weight/add_weight_page.dart';
import 'package:health_app/edit_weight/edit_weight_page.dart';
import 'package:health_app/line_grahp/weight_data.dart';
import 'package:health_app/weight_list/weight_list_model.dart';
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
            final List<WeightData>? today = model.today;
            if (today == null) {
              return CircularProgressIndicator();
            }

            final List<Widget> widgets = today
                .map(
                  (weightData) => Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    child: ListTile(
                      title: Text(
                        weightData.weight.toString(),
                      ),
                      subtitle: Text(
                        weightData.date.toString(),
                      ),
                    ),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                          caption: '編集',
                          color: Colors.black45,
                          icon: Icons.edit,
                          onTap: () async {
                            //編集画面に遷移

                            final bool? added = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditWeightPage(weightData),
                              ),
                            );

                            if (added != null && added) {
                              final snackBar = SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('体重を追加しました'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }

                            model.fetchWeightList();
                          }),
                      IconSlideAction(
                          caption: '削除',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () async {
                            //削除しますかで、「はい」であれば削除
                            await showConfirmDaialog(
                                context, weightData, model);
                          }),
                    ],
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
                // 画面遷移
                final bool? added = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddWeightPage(),
                    fullscreenDialog: true,
                  ),
                );

                if (added != null && added) {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('体重を追加しました'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }

                model.fetchWeightList();
              });
        }),
      ),
    );
  }

  Future showConfirmDaialog(
      BuildContext context, WeightData weightData, WeightListModel model) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text("削除の確認"),
          content: Text("${weightData.date}の体重を削除しますか？"),
          actions: [
            TextButton(
              child: Text("いいえ"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("はい"),
              onPressed: () async {
                //modelで削除
                await model.delete(weightData);
                Navigator.pop(context);
                final snackBar = SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('${weightData.date}の体重を削除しました'),
                );
                model.fetchWeightList();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }
}
