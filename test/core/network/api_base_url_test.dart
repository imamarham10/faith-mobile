import 'package:faith_mobile/core/network/dio_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('assertApiBaseUrlIsProductionSafe', () {
    test('localhost default is rejected in release mode', () {
      expect(
        () => assertApiBaseUrlIsProductionSafe(
          url: 'http://localhost:3000',
          isReleaseBuild: true,
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('localhost is fine in debug', () {
      expect(
        () => assertApiBaseUrlIsProductionSafe(
          url: 'http://localhost:3000',
          isReleaseBuild: false,
        ),
        returnsNormally,
      );
    });

    test('a real host passes in release', () {
      expect(
        () => assertApiBaseUrlIsProductionSafe(
          url: 'https://unified-faith-service.vercel.app',
          isReleaseBuild: true,
        ),
        returnsNormally,
      );
    });

    // The four quadrants of (scheme x host). Only https + a real host is a
    // shippable combination: cleartext is permitted to these hosts in debug
    // builds only (android/app/src/debug/res/xml/network_security_config.xml)
    // and iOS ATS blocks it outright, so plain http can never work in release
    // regardless of host.
    test('plain http to a real host is rejected in release', () {
      expect(
        () => assertApiBaseUrlIsProductionSafe(
          url: 'http://192.168.0.4:3000',
          isReleaseBuild: true,
        ),
        throwsA(
          isA<StateError>().having((e) => e.message, 'message', contains('https')),
        ),
      );
    });

    test('https to loopback is still rejected in release', () {
      expect(
        () => assertApiBaseUrlIsProductionSafe(
          url: 'https://localhost:3000',
          isReleaseBuild: true,
        ),
        throwsA(
          isA<StateError>()
              .having((e) => e.message, 'message', contains('loopback')),
        ),
      );
    });

    test('plain http to a real host is fine in debug', () {
      expect(
        () => assertApiBaseUrlIsProductionSafe(
          url: 'http://192.168.0.4:3000',
          isReleaseBuild: false,
        ),
        returnsNormally,
      );
    });

    test('the emulator loopback alias is rejected in release', () {
      expect(
        () => assertApiBaseUrlIsProductionSafe(
          url: 'http://10.0.2.2:3000',
          isReleaseBuild: true,
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('127.0.0.1 is rejected in release', () {
      expect(
        () => assertApiBaseUrlIsProductionSafe(
          url: 'https://127.0.0.1:3000',
          isReleaseBuild: true,
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('a hostless string is rejected in release', () {
      expect(
        () => assertApiBaseUrlIsProductionSafe(
          url: 'localhost:3000',
          isReleaseBuild: true,
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('the error names the dart-define that fixes it', () {
      expect(
        () => assertApiBaseUrlIsProductionSafe(
          url: 'http://localhost:3000',
          isReleaseBuild: true,
        ),
        throwsA(
          isA<StateError>()
              .having((e) => e.message, 'message', contains('API_BASE_URL')),
        ),
      );
    });

    test('the compiled-in kApiBaseUrl is itself checked', () {
      // `flutter test` always runs in debug, so this is a no-op assertion in
      // CI — it exists so the production call site is exercised at all.
      expect(
        () => assertApiBaseUrlIsProductionSafe(
          url: kApiBaseUrl,
          isReleaseBuild: false,
        ),
        returnsNormally,
      );
    });
  });
}
