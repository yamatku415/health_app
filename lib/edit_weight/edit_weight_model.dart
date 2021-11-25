import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/first_forms/weight_data.dart';
import 'package:health_app/weight_list/weight_list_model.dart';

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

  void setToDate(String date) {
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
        .collection('users')
        .doc(uid)
        .collection('today')
        .doc(weightData.id)
        .update({
      'weight': weight,
      'date': date,
    });
  }
}
