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

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int selectedIndex = 0;
  List<Widget> pageList = [
    MyHomePage(),
    AddWeightPage(),
    WeightListPage(),
    GraphPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'ホーム',
                backgroundColor: Colors.green),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: '今日の体重'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: '体重リスト'),
            BottomNavigationBarItem(
                icon: Icon(Icons.stacked_line_chart), label: '体重グラフ'),
          ],
          currentIndex: selectedIndex,
          onTap: (int index) {
            setState(() {
              selectedIndex = index;
            });
          }),
    );
  }
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
    idealMath();

    SharedValues.instance.firstDay = formatter.parse(fDate!);

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
                            idealMath();

                            SharedValues.instance.firstDay =
                                formatter.parse(fDate!);
                          }
                        },
                        child: Text('決定'),
                      ),
                    ),
                  ),
                  if (SharedValues.instance.ideal != null)
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.green),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'あなたの目標体重は${SharedValues.instance.ideal}kgです',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontStyle: FontStyle.italic,
                                fontSize: 19),
                          )),
                    ),
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
