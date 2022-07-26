abstract class IJwtService {
  String generateToken(Map claims, String audiance);
  void verifyToken(String token, String audiance);
  Map getPayload(String token);
}
