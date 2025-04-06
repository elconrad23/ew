
class ReportBody {
  // model
  late int _id;
  late String _imagePath;
  late String _resultclass;
  late String _degradation;
  late String _productivity;
  late String _accuracy;
  late String _lon;
  late String _lat;
  late String _place;
  late String _timeOfCapture;

  ReportBody(
      {
       required String imagePath,
      required String resultclass,
      required String degradation,
      required String productivity,
      required String accuracy,
      required String lon,
      required String lat,
      required String place,
      required String timeOfCapture}) {
    this._imagePath = imagePath;
  
    this._resultclass = resultclass;
    this._degradation = degradation;
    this._accuracy = accuracy;
    this._productivity = productivity;
    this._lon = lon;
    this._lat = lat;
    this._place = place;
    this._timeOfCapture = timeOfCapture;
  }

  String get degradation => _degradation;
  String get timeOfCapture => _timeOfCapture;
  String get lon => _lon;
  String get lat => _lat;
  String get place => _place;
  String get productivity => _productivity;
  String get accuracy => _accuracy;
  String get imagePath => _imagePath;
  String get resultclass => _resultclass;

  ReportBody.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _imagePath = json["image_path"];
    _resultclass = json["image_class"];
    _degradation = json["degradation"];
    _productivity = json["productivity"];
    _accuracy = json["accuracy"];
    _lon = json["lon"];
    _lat = json["lat"];
    _place = json["place"];
    _timeOfCapture = json["time_of_capture"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image_class'] = this._resultclass;
    data['degradation'] = this._degradation;
    data['productivity'] = this._productivity;
    data['accuracy'] = this._accuracy;
    data['lon'] = this._lon;
    data['lat'] = this._lat;
    data['location'] = this._place;
    data['time_of_capture'] = this._timeOfCapture;
    return data;
  }
}
