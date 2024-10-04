import 'dart:convert';
import 'dart:typed_data'; // Import Uint8List
import 'package:encrypt/encrypt.dart';
import 'package:convert/convert.dart'; // For hex conversion

class EncryptionService {
  final String secretKey = '21a288673f1daa503e0f540f1d02145c20fe122ec0c8fea359947253654553cd'; // Hex string
  final IV iv = IV.fromUtf8("0000000000000000"); // Initialization vector (16 bytes for AES)

  // Function to convert hex string to bytes
  Uint8List hexToBytes(String hex) {
    if (hex.length % 2 != 0) {
      throw Exception('Invalid hex string length');
    }
    final bytes = Uint8List(hex.length ~/ 2);
    for (int i = 0; i < bytes.length; i++) {
      bytes[i] = int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16);
    }
    return bytes;
  }

  // Function to encrypt text
  String encrypt(String text) {
    final keyBytes = hexToBytes(secretKey);

    if (keyBytes.length != 16 && keyBytes.length != 24 && keyBytes.length != 32) {
      throw Exception('Invalid key length: ${keyBytes.length} bytes');
    }

    final key = Key(keyBytes); // Create a key from the byte list
    final encrypter = Encrypter(AES(key));

    // Encrypt the text
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64; // Return encrypted text as Base64 string
  }

  // Function to decrypt text
  String decrypt(String encryptedText) {
    if (encryptedText.isNotEmpty) {
      final keyBytes = hexToBytes(secretKey);

      if (keyBytes.length != 16 && keyBytes.length != 24 && keyBytes.length != 32) {
        throw Exception('Invalid key length: ${keyBytes.length} bytes');
      }

      final key = Key(keyBytes); // Create a key from the byte list
      final encrypter = Encrypter(AES(key));

      // Decrypt the text
      final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
      return decrypted; // Return the decrypted text
    } else {
      return "";
    }
  }
}
