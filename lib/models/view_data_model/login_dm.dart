
class LoginDM {
  final String urlCurrent;

  LoginDM({required this.urlCurrent});

  Map<String, dynamic> toJson() => {
    'urlCurrent': urlCurrent,
  };
}