import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/line_grahp/weight_data.dart';

class WeightListModel extends ChangeNotifier {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('today').snapshots();
  List<WeightData>? today;
  DateTime dateTime = DateTime.now();

  void fetchWeightList() {
    _usersStream.listen((QuerySnapshot snapshot) {
      final List<WeightData> today =
          snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        final String id = document.id;
        final date = data['date'];
        if (date is Timestamp) {
          this.dateTime = date.toDate();
        }
        final String weight = data['weight'];

        //ここの文はWeightDataにリターンしてるということはWeightDataの方にデータが移っているのか？
        return WeightData(id, dateTime, weight);
      }).toList();
      this.today = today;

      notifyListeners();
    });
  }

  Future delete(WeightData weightData) {
    return FirebaseFirestore.instance
        .collection('today')
        .doc(weightData.id)
        .delete();
  }
}
