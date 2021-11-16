import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddWeightModel extends ChangeNotifier {
  String? weight;
  String? date;

  Future addWeight() async {
    if (weight == null || weight!.isEmpty) {
      throw '体重を入力してください';
    }
    if (date == null) {
      throw '日付を入力してください';
    }
    //firestoreに追加
    await FirebaseFirestore.instance.collection('today').add({
      'weight': weight,
      'date': date,
    });
  }

  Future inWeight() async {
    if (weight == null || weight!.isEmpty) {
      throw '体重を入力してください';
    }
  }
}
