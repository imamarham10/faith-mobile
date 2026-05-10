import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/arabic_text.dart';

/// Right-aligned Arabic body for duas with elevated typography.
///
/// Mirrors the styling in the Today screen's `VerseCard` so the brand voice
/// stays consistent across surfaces.
class DuaArabicBlock extends ConsumerWidget {
  const DuaArabicBlock({super.key, required this.text, this.fontSize = 26});

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: arabicTextStyleOf(
          ref,
          fontSize: fontSize,
          height: 2.0,
          color: cs.onSurface,
        ),
      ),
    );
  }
}
