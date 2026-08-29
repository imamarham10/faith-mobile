import 'package:flutter/animation.dart';

/// Shared motion language — "snappy and bouncy," not Material's default ease.
class AppMotion {
  const AppMotion._();

  static const screenTransition = Duration(milliseconds: 180);
  static const cardPress = Duration(milliseconds: 100);
  static const cardSpringBack = Duration(milliseconds: 220);
  static const listStagger = Duration(milliseconds: 50);
  static const celebrate = Duration(milliseconds: 600);

  static const pressCurve = Curves.easeOut;
  static const springBackCurve = Curves.elasticOut;
  static const enterCurve = Curves.easeOutCubic;
}
