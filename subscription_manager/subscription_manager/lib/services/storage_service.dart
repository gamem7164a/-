import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/subscription.dart';

// 구독 목록을 기기 로컬에 저장하고 불러오는 서비스
// 서버 없이 SharedPreferences에 JSON 문자열로 저장한다.
class StorageService {
  static const String _storageKey = 'subscriptions_data';

  Future<List<Subscription>> loadSubscriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Subscription.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveSubscriptions(List<Subscription> subscriptions) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(
      subscriptions.map((s) => s.toJson()).toList(),
    );
    await prefs.setString(_storageKey, encoded);
  }
}
