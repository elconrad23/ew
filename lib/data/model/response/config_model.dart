class ConfigModel {
  late BaseUrls _baseUrls;
  late String _termsAndConditions;
  late String _aboutUs;

  ConfigModel({
    required BaseUrls baseUrls,
    required String aboutUs,
    required String termsAndConditions,
  }) {
    this._baseUrls = baseUrls;
    this._termsAndConditions = termsAndConditions;
    this._aboutUs = aboutUs;
  }

  BaseUrls get baseUrls => _baseUrls;
  String get termsAndConditions => _termsAndConditions;
  String get aboutUs => _aboutUs;

  ConfigModel.fromJson(Map<String, dynamic> json) {
    _baseUrls = (json['base_urls'] != null
        ? new BaseUrls.fromJson(json['base_urls'])
        : null)!;
    _termsAndConditions = json['terms_and_conditions'];
    _aboutUs = json['about_us'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['base_urls'] = this._baseUrls.toJson();
      data['terms_and_conditions'] = this._termsAndConditions;
    data['about_us'] = this._aboutUs;

    return data;
  }
}

class BaseUrls {
  late String _userImageUrl;
  late String _notificationImageUrl;
  late String _reportImageUrl;

  BaseUrls({
    required String userImageUrl,
    required String notificationImageUrl,
    required String reportImageUrl,
  }) {
    this._userImageUrl = userImageUrl;
    this._notificationImageUrl = notificationImageUrl;
     this._reportImageUrl = reportImageUrl;
  }

  String get userImageUrl => _userImageUrl;
  String get notificationImageUrl => _notificationImageUrl;
  String get reportImageUrl => _reportImageUrl;

  BaseUrls.fromJson(Map<String, dynamic> json) {
    _userImageUrl = json['user_image_url'];
    _notificationImageUrl = json['notification_image_url'];
    _reportImageUrl = json['report_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_image_url'] = this._userImageUrl;
    data['notification_image_url'] = this._notificationImageUrl;
    data['report_image_url'] = this._reportImageUrl;
    return data;
  }
}
