// TokenResponse Class (Model)
class TokenResponse {
  final Token token;

  TokenResponse({required this.token});

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(token: Token.fromJson(json['token']));
  }
}

class Token {
  final String accessToken;
  final TokenDetails token;

  Token({required this.accessToken, required this.token});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json['accessToken'],
      token: TokenDetails.fromJson(json['token']),
    );
  }
}

class TokenDetails {
  final String id;
  final int userId;
  final int clientId;
  final String name;
  final bool revoked;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime expiresAt;

  TokenDetails({
    required this.id,
    required this.userId,
    required this.clientId,
    required this.name,
    required this.revoked,
    required this.createdAt,
    required this.updatedAt,
    required this.expiresAt,
  });

  factory TokenDetails.fromJson(Map<String, dynamic> json) {
    return TokenDetails(
      id: json['id'],
      userId: json['user_id'],
      clientId: json['client_id'],
      name: json['name'],
      revoked: json['revoked'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      expiresAt: DateTime.parse(json['expires_at']),
    );
  }
}
