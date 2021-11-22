import 'package:flutter/material.dart';
import 'package:health_app/add_weight/add_weight_page.dart';
import 'package:health_app/line_grahp/graph_page.dart';
import 'package:health_app/login/login_page.dart';
import 'package:health_app/weight_list/weight_list_page.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Kyouyuu {
  //ここの値は変更されずに様々なクラスから参照される。
  Kyouyuu._();
  static final instance = Kyouyuu._();
  double? nowWeight; //sharedpreferences
  double? ideal; //sharedpreferences
  DateTime? firstDay;
  int? year; //sharedpreferences
  double? sales; //sharedpreferences
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
    prefs.setDouble('ideal', Kyouyuu.instance.ideal!);
  }

  Future<void> getDate() async {
    final prefs = await SharedPreferences.getInstance();
    heightController.text = prefs.getString('height') ?? "";
    weightController.text = prefs.getString('weight') ?? "";
    fDate = prefs.getString('date');
    Kyouyuu.instance.ideal = prefs.getDouble('ideal');
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: Kyouyuu.instance._formKey, // 作成したフォームキーを指定
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
                      Text(fDate ?? ""),
                      Center(
                          child: ElevatedButton(
                        onPressed: () {
                          if (fDate == null) {
                            _selectDate(context);
                            fDate = DateFormat('MM/dd/yyyy').format(_date);
                          } else {
                            _selectedDate(context);
                            Kyouyuu.instance.firstDay = formatter.parse(fDate!);
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

                      if (Kyouyuu.instance._formKey.currentState!.validate()) {
                        //todo フォーカスするためのコード

                        nowHeight = double.parse(heightController.text);
                        Kyouyuu.instance.nowWeight =
                            double.parse(weightController.text);
                        setState(() {
                          Kyouyuu.instance.ideal = double.parse(
                              (Kyouyuu.instance.nowWeight! -
                                      (Kyouyuu.instance.nowWeight! * 0.02 * 6))
                                  .toStringAsFixed(1));
                        });
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
                      color: Colors.white,
                      shape: const StadiumBorder(
                        side: BorderSide(color: Colors.green),
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
                      color: Colors.white,
                      shape: const StadiumBorder(
                        side: BorderSide(color: Colors.green),
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
                    color: Colors.white,
                    shape: const StadiumBorder(
                      side: BorderSide(color: Colors.green),
                    ),
                    onPressed: () {
                      ///idealがnullだったらelse文使ってスナックバー表示こっち！！
                      setState(() {
                        Kyouyuu.instance.nowWeight =
                            double.parse(weightController.text);
                        Kyouyuu.instance.ideal = double.parse(
                            (Kyouyuu.instance.nowWeight! -
                                    (Kyouyuu.instance.nowWeight! * 0.02 * 6))
                                .toStringAsFixed(1));

                        Kyouyuu.instance.firstDay = formatter.parse(fDate!);
                      });
                      if (Kyouyuu.instance.ideal != null)
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GraphPage(),
                            ));
                    },
                  ),
                ),
              ]),
              if (Kyouyuu.instance.ideal != null)
                Container(
                    alignment: Alignment.center,
                    child: Text(
                      'あなたの目標体重は${Kyouyuu.instance.ideal}です',
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

  static final formatter = DateFormat("MM/dd/yyyy");
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
}
