import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddWeightModel extends ChangeNotifier {
  String? toweight;
  String? todate;

  Future addWeight() async {
    if (toweight == null || toweight!.isEmpty) {
      throw '体重を入力してください';
    }
    if (todate == null || todate!.isEmpty) {
      throw '日付を入力してください';
    }
    //firestoreに追加
    await FirebaseFirestore.instance.collection('today').add({
      'toweight': toweight,
      'todate': todate,
    });
  }

  Future inWeight() async {
    if (toweight == null || toweight!.isEmpty) {
      throw '体重を入力してください';
    }
  }
}
