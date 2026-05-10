import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'arabic_script.g.dart';

/// Which script the app renders Arabic text in. Controls the font choice;
/// the underlying Unicode is unchanged across selections.
enum ArabicScript {
  /// South Asian Mushaf feel — traditional Naskh shaping (Scheherazade New).
  indoPak,

  /// Saudi Mushaf — Amiri Quran (Uthmani-style ligatures).
  uthmani,

  /// Modern Naskh — Noto Naskh Arabic.
  naskh;

  String get label => switch (this) {
    ArabicScript.indoPak => 'Indo-Pak',
    ArabicScript.uthmani => 'Uthmani',
    ArabicScript.naskh => 'Naskh',
  };

  String get subtitle => switch (this) {
    ArabicScript.indoPak => 'South Asian Mushaf style',
    ArabicScript.uthmani => 'Saudi Mushaf (Amiri Quran)',
    ArabicScript.naskh => 'Modern Naskh',
  };
}

/// Persists the user's Arabic script preference via shared_preferences.
/// Default is Indo-Pak.
@Riverpod(keepAlive: true)
class ArabicScriptController extends _$ArabicScriptController {
  static const _key = 'arabic_script';

  @override
  Future<ArabicScript> build() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return ArabicScript.indoPak;
    return ArabicScript.values.firstWhere(
      (s) => s.name == raw,
      orElse: () => ArabicScript.indoPak,
    );
  }

  Future<void> set(ArabicScript script) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, script.name);
    state = AsyncValue.data(script);
  }
}
