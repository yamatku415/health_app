///日付と体重を持つクラスを作成
class WeightData {
  WeightData(this.date, this.weight);
  DateTime date;
  double weight;
}

//もしかしたらここが原因で動かないのかも  おそらくbookのこと

class ToWeightData {
  ToWeightData(this.id, this.todate, this.toweight);
  String id;
  String todate;
  String toweight;
}
