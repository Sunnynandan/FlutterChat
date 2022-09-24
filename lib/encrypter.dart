import 'package:encrypt/encrypt.dart';

class Encrypt {
  static final _key = Key.fromUtf8("my32lengthsupersecretnooneknows1");
  static final _iv = IV.fromLength(16);

  static String encryptAES(String plaintext) {
    final encrypter = Encrypter(AES(_key));
    return encrypter.encrypt(plaintext, iv: _iv).base64;
  }

  static String decryptAES(String encrytedtext) {
    var encryted = Encrypted.from64(encrytedtext);
    final encrypter = Encrypter(AES(_key));
    return encrypter.decrypt(encryted, iv: _iv);
  }
}
