import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/second_page/weight_data.dart';

class WeightListModel extends ChangeNotifier {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('today').snapshots();
  List<ToWeightData>? today;

  void fetchWeightList() {
    _usersStream.listen((QuerySnapshot snapshot) {
      final List<ToWeightData> today =
          snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

        final String todate = data['todate'];
        final String toweight = data['toweight'];
        return ToWeightData(todate, toweight);
      }).toList();
      this.today = today;

      notifyListeners();
    });
  }
}
