import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/arabic_text.dart';
import '../../domain/share_card_theme.dart';
import '../../domain/shareable_content.dart';

/// 1080×1080 square share card. Fixed-size header and footer; the middle
/// (Arabic + translation) is wrapped in a [FittedBox.scaleDown] inside an
/// [Expanded], so long verses shrink uniformly to fit instead of pushing
/// the wordmark off the bottom.
///
/// Capture flow: caller wraps in a [RepaintBoundary] keyed to a [GlobalKey]
/// and calls `boundary.toImage(pixelRatio: 1.0)` for an exact 1080² PNG.
class ShareCard extends ConsumerWidget {
  const ShareCard({
    super.key,
    required this.content,
    required this.theme,
    this.size = 1080,
  });

  final ShareableContent content;
  final ShareCardTheme theme;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final padding = size * 0.085;
    // Width the inner content lays out at before any scale-down kicks in.
    // The FittedBox below will shrink uniformly if the natural height
    // overflows the middle slot.
    final contentWidth = size - padding * 2;

    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [theme.gradientStart, theme.gradientEnd],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              _Header(content: content, theme: theme, size: size),
              Expanded(
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SizedBox(
                      width: contentWidth,
                      child: _Body(
                        content: content,
                        theme: theme,
                        size: size,
                        ref: ref,
                      ),
                    ),
                  ),
                ),
              ),
              _Footer(content: content, theme: theme, size: size),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.content,
    required this.theme,
    required this.size,
  });

  final ShareableContent content;
  final ShareCardTheme theme;
  final double size;

  @override
  Widget build(BuildContext context) {
    final hasEyebrow = (content.eyebrow ?? '').isNotEmpty;
    final hasTitle = (content.title ?? '').isNotEmpty;
    if (!hasEyebrow && !hasTitle) return SizedBox(height: size * 0.03);
    return Padding(
      padding: EdgeInsets.only(bottom: size * 0.04),
      child: Column(
        children: [
          if (hasEyebrow)
            Text(
              content.eyebrow!.toUpperCase(),
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: theme.textSecondary,
                fontSize: size * 0.022,
                letterSpacing: 4,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (hasEyebrow && hasTitle) SizedBox(height: size * 0.012),
          if (hasTitle)
            Text(
              content.title!,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.fraunces(
                color: theme.textPrimary,
                fontSize: size * 0.034,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.content,
    required this.theme,
    required this.size,
    required this.ref,
  });

  final ShareableContent content;
  final ShareCardTheme theme;
  final double size;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final hasArabic = (content.arabic ?? '').isNotEmpty;
    final hasTranslation = (content.translation ?? '').isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasArabic)
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              content.arabic!,
              textAlign: TextAlign.center,
              style: arabicTextStyleOf(
                ref,
                fontSize: size * 0.060,
                height: 2.0,
                color: theme.textPrimary,
              ),
            ),
          ),
        if (hasArabic && hasTranslation) ...[
          SizedBox(height: size * 0.04),
          Container(
            width: size * 0.06,
            height: 1,
            color: theme.accent.withValues(alpha: 0.65),
          ),
          SizedBox(height: size * 0.035),
        ],
        if (hasTranslation)
          Text(
            content.translation!,
            textAlign: TextAlign.center,
            style: GoogleFonts.fraunces(
              color: theme.textPrimary,
              fontSize: size * 0.030,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.content,
    required this.theme,
    required this.size,
  });

  final ShareableContent content;
  final ShareCardTheme theme;
  final double size;

  @override
  Widget build(BuildContext context) {
    final hasAttribution = (content.attribution ?? '').isNotEmpty;
    return Padding(
      padding: EdgeInsets.only(top: size * 0.035),
      child: Column(
        children: [
          if (hasAttribution)
            Text(
              content.attribution!,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: theme.textSecondary,
                fontSize: size * 0.022,
                letterSpacing: 1.2,
              ),
            ),
          SizedBox(height: size * 0.022),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/brand/siraat_logo.png',
                width: size * 0.046,
                height: size * 0.046,
              ),
              SizedBox(width: size * 0.014),
              Text(
                'Siraat',
                style: GoogleFonts.fraunces(
                  color: theme.textSecondary,
                  fontSize: size * 0.024,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
