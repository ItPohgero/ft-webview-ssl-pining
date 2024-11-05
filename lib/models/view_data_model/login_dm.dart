
class LoginDM {
  final String urlCurrent;

  LoginDM({required this.urlCurrent});

  Map<String, dynamic> toJson() => {
    'urlCurrent': urlCurrent,
  };

  factory LoginDM.fromJson(Map<String, dynamic> json) => LoginDM(
    urlCurrent: json['token'] as String,
  );
}