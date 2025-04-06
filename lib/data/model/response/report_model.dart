
// send report model

class RepoModel {
  late List<ReportsModel> reports;

  RepoModel({required this.reports});

  RepoModel.fromJson(Map<String, dynamic> json) {
    if (json['reports'] != null) {
      reports = [];
      json['reports'].forEach((v) {
        reports.add(ReportsModel.fromJson(v));
      });
    }
  }
}



// reports modal
class ReportsModel {
  late int id;
  late String reportcomment;
  late String createdAt;
  late String updatedAt;
  late Details details;
  late User user;
  ReportsModel({
    required this.id,
    required this.reportcomment,
    required this.createdAt,
    required this.updatedAt,
    required this.details,
    required this.user,
  });

  ReportsModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    reportcomment = json["report_comment"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    details = Details.fromJson(json["details"]);
    user = User.fromJson(json["user"]);
  }
}

class Details {
  Details({
    required this.id,
    required this.imagePath,
    required this.resultclass,
    required this.degradation,
    required this.productivity,
    required this.accuracy,
    required this.lon,
    required this.lat,
    required this.place,
    required this.timeOfCapture,
    required this.createdAt,
    required this.updatedAt,
  });

  late int id;
  late String imagePath;
  late String resultclass;
  late String degradation;
  late String productivity;
  late String accuracy;
  late String lon;
  late String lat;
  late String place;
  late String timeOfCapture;
  late DateTime createdAt;
  late DateTime updatedAt;

  Details.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    imagePath = json["image_path"];
    resultclass = json["image_class"];
    degradation = json["degradation"];
    productivity = json["productivity"];
    accuracy = json["accuracy"];
    lon = json["lon"];
    lat = json["lat"];
    place = json["place"];
    timeOfCapture = json["time_of_capture"];
    createdAt = DateTime.parse(json["created_at"]);
    updatedAt = DateTime.parse(json["updated_at"]);
  }
}

class User {
  late int id;
  late String image;
  late String username;
  late String phone;
  late int reportCount;

  User(
      {required this.id,
      
      required this.image,
      required this.phone,
      
     
      required this.reportCount,
      required this.username});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    
    image = json['image'];
    phone = json['phone'];
    reportCount = json['report_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
   
    data['username'] = this.username;
    data['image'] = this.image;
    data['phone'] = this.phone;
    data['report_count'] = this.reportCount;
    return data;
  }
}
