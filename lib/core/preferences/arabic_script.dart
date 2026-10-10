import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'arabic_script.g.dart';

/// Which script the app renders Arabic text in.
///
/// Each value selects **both the text and the face**: the scripts are
/// different orthographies of the same revelation, not three fonts over one
/// string. `arabicTextForScript` picks the verse text; `arabicTextStyle`
/// picks the typeface that orthography was drawn for. Changing one without
/// the other is the bug this enum shipped with — see `arabic_script_text.dart`.
enum ArabicScript {
  /// The South Asian mushaf orthography: plain alef-lam, dotless final ya,
  /// explicit sukun over long vowels, `ؕ` and friends for the waqf marks.
  /// The spelling printed across India, Pakistan and Bangladesh — for this
  /// app's first market, simply what a Qur'an looks like. The default.
  indoPak,

  /// The Madinah/King Fahd mushaf orthography: alef-wasla, small high marks
  /// over silent letters, superscript alef.
  uthmani,

  /// Contemporary Naskh — the plain modern spelling, for reading rather than
  /// recitation-marking.
  naskh;

  String get label => switch (this) {
    ArabicScript.indoPak => 'Indo-Pak',
    ArabicScript.uthmani => 'Uthmani',
    ArabicScript.naskh => 'Naskh',
  };

  /// Describes the **script**, never the font. The font is an implementation
  /// detail of rendering the script, and naming it here (as this once named
  /// Amiri Quran) told the user the preference picked a typeface — which was
  /// both wrong and the reason the bug went unnoticed.
  String get subtitle => switch (this) {
    ArabicScript.indoPak => 'The South Asian mushaf spelling',
    ArabicScript.uthmani => 'The Madinah mushaf spelling',
    ArabicScript.naskh => 'Plain modern Naskh',
  };

  /// A fragment of 2:142 in this script, for the settings preview.
  ///
  /// The three differ in characters, not only in shape — dotless `ٱلَّتِى`
  /// against dotted `الَّتِیْ` — so the preview shows what the preference
  /// actually does. A single shared sample could only ever show three fonts.
  String get sample => switch (this) {
    ArabicScript.indoPak => 'الَّتِیْ',
    ArabicScript.uthmani => 'ٱلَّتِى',
    ArabicScript.naskh => 'الَّتِي',
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
