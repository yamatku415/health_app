class WeightData {
  WeightData(this.id, this.date, this.weight);
  String? id;
  DateTime date;
  String weight;
}




//グラフを動かすために仮で作った
class NowWeightData {
  NowWeightData(this.nowDate, this.nowWeight);

  DateTime nowDate;
  double nowWeight;
}

//理想体重のデータ
class AnWeightData {
  AnWeightData(this.anData, this.anWeight);
  DateTime anData;
  double anWeight;
}
