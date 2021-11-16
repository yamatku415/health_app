import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/line_grahp/weight_data.dart';

class EditWeightModel extends ChangeNotifier {
  WeightData weightData;
  EditWeightModel(this.weightData) {
    weightController.text = weightData.weight;
  }

  final weightController = TextEditingController();

  String? weight;
  String? date;

  void setToWeight(String weight) {
    this.weight = weight;
    notifyListeners();
  }

  void setToDte(String date) {
    this.date = date;
    notifyListeners();
  }

  bool isUpdated() {
    return weight != null || date != null;
  }

  Future update(weight, date) async {
    this.weight = weight;
    this.date = date;

    //firestoreに追加
    await FirebaseFirestore.instance
        .collection('today')
        .doc(weightData.id)
        .update({
      'weight': weight,
      'date': date,
    });
  }
}
