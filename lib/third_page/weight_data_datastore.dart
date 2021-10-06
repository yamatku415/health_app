import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_app/second_page/weight_data.dart';

class WeightDataDatastore {
  static String getCollectionPath() {
    return "today";
  }

  static Future<List<WeightData>> getAllToday() async {
    final snapshot = await FirebaseFirestore.instance
        .collection(getCollectionPath())
        .orderBy("date", descending: true)
        .get();
    List<QueryDocumentSnapshot> documents = snapshot.docs;
    List<WeightData> today = [];
    documents.forEach((s) {
      if (s.exists) {
        final todayData = WeightData.fromMap(s.data() as Map<String, dynamic>);
        today.add(todayData);
      }
    });
    return today;
  }
}
