class LoginRequest {
  final String url;

  LoginRequest({
    required this.url,
  });

  Map<String, dynamic> toJson() {
    return {
      "url": url,
    };
  }
}
