import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/second_page/weight_data.dart';

class WeightModel extends ChangeNotifier {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('today').snapshots();

  List<WeightData>? today;

  void todayWeightList() {
    _usersStream.listen((QuerySnapshot snapshot) {
      final List<WeightData> today =
          snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        final double weight = data['weight'];
        final DateTime date = data['date'];

        return WeightData(date, weight);
      }).toList();
      this.today = today;
      notifyListeners();
    });
  }
}
