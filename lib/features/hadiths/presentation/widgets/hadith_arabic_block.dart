import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/arabic_text.dart';

/// Right-aligned Arabic body for hadith narrations.
///
/// Mirrors the typography in `VerseCard` and `DuaArabicBlock` so brand voice
/// stays consistent across surfaces.
class HadithArabicBlock extends ConsumerWidget {
  const HadithArabicBlock({
    super.key,
    required this.text,
    this.fontSize = 24,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final double fontSize;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Text(
        text,
        textAlign: TextAlign.right,
        maxLines: maxLines,
        overflow: overflow,
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
