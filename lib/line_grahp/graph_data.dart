import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:health_app/line_grahp/weight_data.dart';

class GraphData extends ChangeNotifier {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('today').snapshots();
  List<WeightDataGraph>? today;
  DateTime dateTime = DateTime.now();

  void fetchWeightGraph() {
    _usersStream.listen((QuerySnapshot snapshot) {
      final List<WeightDataGraph> today =
          snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

        final date = data['date'];
        if (date is Timestamp) {
          this.dateTime = date.toDate();
        }
        final String weight = data['weight'];

        //ここの文はWeightDataにリターンしてるということはWeightDataの方にデータが移っているのか？
        return WeightDataGraph(dateTime, weight);
      }).toList();
      this.today = today;

      notifyListeners();
    });
  }
}
