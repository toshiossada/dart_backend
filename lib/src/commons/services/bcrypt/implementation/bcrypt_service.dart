import 'package:bcrypt/bcrypt.dart';

import '../bcrypt_service_interface.dart';

class BCryptService implements IBCryptService {
  @override
  String gernerateHase(String text) => BCrypt.hashpw(text, BCrypt.gensalt());

  @override
  bool checkHash(String text, String hash) => BCrypt.checkpw(text, hash);
}
