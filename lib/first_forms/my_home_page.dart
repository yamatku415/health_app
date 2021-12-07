import 'package:flutter/material.dart';
import 'package:health_app/add_weight/add_weight_page.dart';
import 'package:health_app/line_grahp/graph_page.dart';
import 'package:health_app/login/login_page.dart';
import 'package:health_app/weight_list/weight_list_page.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../back_ground.dart';

class SharedValues {
  //ここの値は変更されずに様々なクラスから参照される。
  SharedValues._();
  static final instance = SharedValues._();
  double? nowWeight;
  double? ideal;
  DateTime? firstDay;
  String? edDay;
  DateTime? edDate;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  double? nowHeight;
  String? fDate;

  Future<void> setData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('height', heightController.text);
    prefs.setString('weight', weightController.text);
    prefs.setString('date', fDate!);
    prefs.setDouble('ideal', SharedValues.instance.ideal!);
  }

  Future<void> getDate() async {
    final prefs = await SharedPreferences.getInstance();
    heightController.text = prefs.getString('height') ?? "";
    weightController.text = prefs.getString('weight') ?? "";
    fDate = prefs.getString('date');
    SharedValues.instance.ideal = prefs.getDouble('ideal');
    setState(() {});
  }

  Future<void> delDate() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.remove('date');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // 1つ前に戻る
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ));
            },
          ),
          title: Text(
            '身長と体重を記入',
          ),
        ),
        body: Stack(children: [
          AppBackground(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: SharedValues.instance._formKey, // 作成したフォームキーを指定
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: heightController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.create),
                        hintText: '0.0cm',
                        labelText: '身長'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '身長を入力してください';
                      }
                    },
                  ),
                  TextFormField(
                    controller: weightController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.create),
                      hintText: '0.0kg',
                      labelText: '体重',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '体重を入力してください';
                      }
                    },
                  ),
                  Container(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: <Widget>[
                          Text(fDate ?? DateFormat('yyyy/MM/dd').format(_date)),
                          Center(
                              child: ElevatedButton(
                            onPressed: () {
                              if (fDate == null) {
                                _selectDate(context);
                              } else {
                                _selectedDate(context);
                                SharedValues.instance.firstDay =
                                    formatter.parse(fDate!);
                              }
                            },
                            child: Text('日付選択'),
                          )),
                        ],
                      )),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ElevatedButton(
                        // 送信ボタンクリック時の処理
                        onPressed: () {
                          // バリデーションチェック
                          setData();

                          if (SharedValues.instance._formKey.currentState!
                              .validate()) {
                            idealMath();
                            fDate = DateFormat('yyyy/MM/dd').format(_date);
                          }
                        },
                        child: Text('決定'),
                      ),
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                          child: Text('今日の体重記入'),
                          color: Color(0xFFDAE5D2),
                          shape: const StadiumBorder(
                            side: BorderSide(color: Color(0xFF468B08)),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddWeightPage(),
                                ));
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                          child: Text('体重リスト'),
                          color: Color(0xFFDAE5D2),
                          shape: const StadiumBorder(
                            side: BorderSide(color: Color(0xFF254E00)),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WeightListPage(),
                                ));
                          }),
                    ),

                    ///値が入っていない場合は何かしらでページ遷移できないようにする
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        child: Text('グラフ'),
                        color: Color(0xFFDAE5D2),
                        shape: const StadiumBorder(
                          side: BorderSide(color: Color(0xFF254E00)),
                        ),
                        onPressed: () {
                          ///idealがnullだったらelse文使ってスナックバー表示こっち！！
                          idealMath();

                          SharedValues.instance.firstDay =
                              formatter.parse(fDate!);

                          if (SharedValues.instance.ideal != null)
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GraphPage(),
                                ));
                        },
                      ),
                    ),
                  ]),
                  if (SharedValues.instance.ideal != null)
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.green),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'あなたの目標体重は${SharedValues.instance.ideal}kgです',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontStyle: FontStyle.italic),
                        )),
                ],
              ),
            ),
          ),
        ]));
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

  static final formatter = DateFormat("yyyy/MM/dd");
  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: formatter.parse(fDate!),
        firstDate: DateTime(2018),
        lastDate: DateTime.now().add(Duration(days: 360)));
    if (picked != null) {
      setState(() => formatter.parse(fDate!) != picked);
    }
  }

  Future idealMath() async {
    nowHeight = double.parse(heightController.text);
    SharedValues.instance.nowWeight = double.parse(weightController.text);
    setState(() {
      SharedValues.instance.ideal = double.parse(
          (SharedValues.instance.nowWeight! -
                  (SharedValues.instance.nowWeight! * 0.02 * 6))
              .toStringAsFixed(1));
    });
  }
}
