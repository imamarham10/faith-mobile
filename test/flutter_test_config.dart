import 'dart:async';

import 'package:google_fonts/google_fonts.dart';

/// Runs before every test file in this directory tree.
///
/// Disables google_fonts' runtime network fetching so tests are
/// deterministic and don't depend on network access: fonts fall back to the
/// platform default instead of hitting fonts.gstatic.com.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  await testMain();
}
