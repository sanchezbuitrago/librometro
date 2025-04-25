// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum SecureStorageKey { library }

class SecureStorage {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> save(SecureStorageKey key, Map<String, dynamic> data) async {
    await storage.write(key: key.name, value: jsonEncode(data));
  }

  Future<Map<String, dynamic>?> get(SecureStorageKey key) async {
    String? data = await storage.read(key: key.name);
    return jsonDecode(data ?? "{}");
  }

  Future<void> delete(SecureStorageKey key) async {
    await storage.delete(key: key.name);
  }
}
