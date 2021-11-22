import 'package:flutter/cupertino.dart';

class WeightData extends ChangeNotifier {
  WeightData(this.id, this.date, this.weight);
  String? id;
  String date;
  String weight;
}

class WeightDataGraph extends ChangeNotifier {
  WeightDataGraph(this.date, this.weight);

  DateTime date;
  String weight;
}
