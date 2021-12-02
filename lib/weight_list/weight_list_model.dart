import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/first_forms/weight_data.dart';

class WeightListModel extends ChangeNotifier {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('today')
      .snapshots();
  List<WeightData>? today;

  void fetchWeightList() {
    _usersStream.listen((QuerySnapshot snapshot) {
      final List<WeightData> today =
          snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        final String id = document.id;
        final date = data['date'];
        final String weight = data['weight'];

        //ここの文はWeightDataにリターンしてるということはWeightDataの方にデータが移っているのか？
        return WeightData(id, date, weight);
      }).toList();
      today.sort((a, b) => -a.date.compareTo(b.date));
      this.today = today;

      notifyListeners();
    });
  }

  Future delete(WeightData weightData) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('today')
        .doc(weightData.id)
        .delete();
  }
}

String get uid => FirebaseAuth.instance.currentUser!.uid;
