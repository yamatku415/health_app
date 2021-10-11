import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/line_grahp/weight_data.dart';

class WeightListModel extends ChangeNotifier {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('today').snapshots();
  List<ToWeightData>? today;

  void fetchWeightList() {
    _usersStream.listen((QuerySnapshot snapshot) {
      final List<ToWeightData> today =
          snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        final String id = document.id;
        final String todate = data['todate'];
        final num toweight = data['toweight'];
        return ToWeightData(id, todate, toweight);
      }).toList();
      this.today = today;

      notifyListeners();
    });
  }

  Future delete(ToWeightData toWeightData) {
    return FirebaseFirestore.instance
        .collection('today')
        .doc(toWeightData.id)
        .delete();
  }
}
