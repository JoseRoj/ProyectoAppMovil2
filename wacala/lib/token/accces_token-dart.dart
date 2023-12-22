import 'dart:convert';

class AccessToken {
  String accessToken;

  AccessToken({
    required this.accessToken,
  });

  factory AccessToken.fromRawJson(String str) =>
      AccessToken.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AccessToken.fromJson(Map<String, dynamic> json) => AccessToken(
        accessToken: json["accessToken"],
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
      };
}
