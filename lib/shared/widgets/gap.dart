import 'package:flutter/widgets.dart';

/// A const-friendly, axis-agnostic spacer.
///
/// Cheaper than `SizedBox` because it skips the unused dimension entirely.
class Gap extends StatelessWidget {
  const Gap(this.size, {super.key, this.axis = Axis.vertical});

  /// Convenience for horizontal gaps.
  const Gap.h(double size, {Key? key})
    : this(size, key: key, axis: Axis.horizontal);

  final double size;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: axis == Axis.horizontal ? size : 0,
      height: axis == Axis.vertical ? size : 0,
    );
  }
}
