class ErrorResponse {
  final List<Errors> errors;

  ErrorResponse({required this.errors});

  factory ErrorResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null || json['errors'] == null) {
      print("....................");
      print(json);
      print("....................");
      return ErrorResponse(errors: [
        Errors(
            code: 'unknown', message: 'Something went wrong. Please try again.')
      ]);
    }

    List<Errors> errorList = [];
    for (var v in json['errors']) {
      errorList.add(Errors.fromJson(v));
    }

    return ErrorResponse(errors: errorList);
  }

  Map<String, dynamic> toJson() {
    return {
      'errors': errors.map((e) => e.toJson()).toList(),
    };
  }
}

class Errors {
  final String code;
  final String message;

  Errors({required this.code, required this.message});

  factory Errors.fromJson(Map<String, dynamic> json) {
    return Errors(
      code: json['code'] ?? 'unknown',
      message: json['message'] ?? 'An unknown error occurred.',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
    };
  }
}
