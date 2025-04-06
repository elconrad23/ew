class SignUpModel {
 
  late String phone;
  late String password;
  late String username;

  SignUpModel(
      {required this.phone, required this.password, required this.username});

  SignUpModel.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    password = json['password'];
    username = json["username"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['username'] = this.username;
    data['password'] = this.password;
    return data;
  }
}
