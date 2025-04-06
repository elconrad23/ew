class UserInfoModel {
  late int id;
  late String email;
  late String photo;
  late String username;
  late String createdAt;
  late String updatedAt;
  late String phone;

  UserInfoModel(
      {required this.id,
      required this.email,
      required this.photo,
      required this.username,
      required this.createdAt,
      required this.updatedAt,
      required this.phone});

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    photo = json['image'];
    username =json['username'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['image'] = this.photo;
    data['username'] = this.username;
     data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['phone'] = this.phone;
    return data;
  }
}
