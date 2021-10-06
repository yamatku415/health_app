import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/second_page/weight_data.dart';
import 'package:health_app/third_page/weight_data_datastore.dart';

class WeightDataController with ChangeNotifier {
  WeightDataController() {
    _load();
  }

  List<WeightData> today = <WeightData>[];
  bool isLoading = false;

  Future<void> _load() async {
    if (isLoading) {
      return;
    }
    isLoading = true;
    notifyListeners();

    today = await WeightDataDatastore.getAllToday();

    isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    if (isLoading) {
      return;
    }
    isLoading = true;
    notifyListeners();

    today = await WeightDataDatastore.getAllToday();

    isLoading = false;
    notifyListeners();
  }
}
