import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:health_app/first_forms/weight_data.dart';
import 'package:health_app/weight_list/weight_list_model.dart';
import 'package:intl/intl.dart';

class GraphData extends ChangeNotifier {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('today')
      .snapshots();
  List<WeightDataGraph>? today;
  DateTime dateTime = DateTime.now();
  static final _dateFormatter = DateFormat("yyyy/MM/dd");

  void fetchWeightGraph() {
    _usersStream.listen((QuerySnapshot snapshot) {
      final List<WeightDataGraph> today =
          snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

        final date = data['date'];
        if (date is String) {
          this.dateTime = _dateFormatter.parseStrict(date);
        }
        final String weight = data['weight'];

        //ここの文はWeightDataにリターンしてるということはWeightDataの方にデータが移っているのか？
        return WeightDataGraph(dateTime, weight);
      }).toList();
      today.sort((a, b) => a.date.compareTo(b.date));
      this.today = today;

      notifyListeners();
    });
  }
}
