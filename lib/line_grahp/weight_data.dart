import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

///日付と体重を持つクラスを作成
class WeightData {
  DateTime? date;
  Double? weight;

  WeightData(DateTime date, Double weight) {
    this.date = date;
    this.weight = weight;
  }

  WeightData.fromMap(Map<String, dynamic> map) {
    final date = map["date"];
    if (date is Timestamp) {
      this.date = date.toDate();
    }

    this.weight = map["weight"];
  }

  Map<String, dynamic> toMap() {
    return {
      "date": this.date,
      "weight": this.weight,
    };
  }
}
