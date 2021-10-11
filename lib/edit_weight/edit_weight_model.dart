import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/line_grahp/weight_data.dart';

class EditWeightModel extends ChangeNotifier {
  final ToWeightData toWeightData;
  EditWeightModel(this.toWeightData) {
    toweightController.text = toWeightData.toweight as String;
    todatetController.text = toWeightData.todate;
  }

  final toweightController = TextEditingController();
  final todatetController = TextEditingController();

  String? toweight;
  String? todate;

  void setToWeight(String toweight) {
    this.toweight = toweight;
    notifyListeners();
  }

  void setToDte(String todate) {
    this.todate = todate;
    notifyListeners();
  }

  bool isUpdated() {
    return toweight != null || todate != null;
  }

  Future update() async {
    this.toweight = toweightController.text;
    this.todate = todatetController.text;

    //firestoreに追加
    await FirebaseFirestore.instance
        .collection('today')
        .doc(toWeightData.id)
        .update({
      'toweight': toweight,
      'todate': todate,
    });
  }
}
