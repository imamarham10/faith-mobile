import 'package:faith_mobile/core/time/timezone_names.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('normaliseActivityTimezone', () {
    test('passes an IANA name through untouched', () {
      expect(normaliseActivityTimezone('Asia/Kolkata'), 'Asia/Kolkata');
      expect(
        normaliseActivityTimezone('America/Argentina/Buenos_Aires'),
        'America/Argentina/Buenos_Aires',
      );
    });

    test('accepts UTC and GMT verbatim', () {
      // An Android device with no region set reports exactly "UTC" from
      // TimeZone.getID(), and §1.5 accepts it.
      expect(normaliseActivityTimezone('UTC'), 'UTC');
      expect(normaliseActivityTimezone('GMT'), 'GMT');
    });

    test('GMT survives the shared table, which maps it to Europe/London', () {
      // The one place the two callers genuinely want different answers, and
      // the regression a careless unification would introduce. The shared
      // table carries GMT -> Europe/London for the notification scheduler,
      // which needs a location; here GMT is already a legal wire value, and
      // rewriting it would silently relocate a user to London. The early
      // return in normaliseActivityTimezone is what keeps them apart.
      expect(ianaForAbbreviation('GMT'), 'Europe/London');
      expect(normaliseActivityTimezone('GMT'), 'GMT');
      expect(normaliseActivityTimezone('gmt'), 'GMT');
    });

    test('resolves abbreviations the server rejects permanently', () {
      expect(normaliseActivityTimezone('IST'), 'Asia/Kolkata');
      expect(normaliseActivityTimezone('EST'), 'America/New_York');
      expect(normaliseActivityTimezone('AEDT'), 'Australia/Sydney');
      // These used to be the gap in notification_service.dart's smaller
      // table. Sharing one table closes it in both directions.
      expect(normaliseActivityTimezone('WIB'), 'Asia/Jakarta');
      expect(normaliseActivityTimezone('SAST'), 'Africa/Johannesburg');
    });

    test('falls back to UTC for anything it cannot resolve', () {
      // A queueable-but-unacceptable value costs the user the event
      // permanently; a slightly wrong zone costs them nothing, because the
      // server stores it rather than validating localDay against it (§2.2).
      expect(normaliseActivityTimezone('+05:30'), 'UTC');
      expect(normaliseActivityTimezone('ZZZ'), 'UTC');
      expect(normaliseActivityTimezone(''), 'UTC');
      expect(normaliseActivityTimezone('   '), 'UTC');
      expect(normaliseActivityTimezone(null), 'UTC');
    });

    test('never emits something the server rejects for shape', () {
      // §1.5: a fixed offset or a bare abbreviation is rejected
      // permanently. Whatever goes in, what comes out is UTC, GMT, or
      // something containing a slash.
      const inputs = [
        'IST',
        'ZZZ',
        '+05:30',
        '-08:00',
        'UTC',
        'GMT',
        '',
        'Asia/Kolkata',
        'Europe/Isle_of_Man',
      ];
      for (final raw in inputs) {
        final out = normaliseActivityTimezone(raw);
        expect(
          out == 'UTC' || out == 'GMT' || out.contains('/'),
          isTrue,
          reason: '"$raw" normalised to "$out", which §1.5 rejects',
        );
      }
    });
  });

  group('ianaForAbbreviation', () {
    test('returns null rather than guessing, so callers pick a fallback', () {
      // The whole reason the table is shared but the fallback is not: the
      // notification path wants the raw name back (timezone package may
      // accept it, and throws harmlessly if not), the queue wants UTC.
      expect(ianaForAbbreviation('ZZZ'), isNull);
      expect(ianaForAbbreviation(''), isNull);
      expect(ianaForAbbreviation(null), isNull);
      expect(ianaForAbbreviation('Asia/Kolkata'), isNull);
    });

    test('is case- and whitespace-insensitive', () {
      expect(ianaForAbbreviation('ist'), 'Asia/Kolkata');
      expect(ianaForAbbreviation('  PDT '), 'America/Los_Angeles');
    });

    test('still answers everything the notification table used to', () {
      // The old switch in notification_service.dart, entry for entry. If
      // the shared table ever loses one of these, prayer reminders go out
      // against the wrong zone.
      const previous = {
        'IST': 'Asia/Kolkata',
        'PST': 'America/Los_Angeles',
        'PDT': 'America/Los_Angeles',
        'EST': 'America/New_York',
        'EDT': 'America/New_York',
        'CST': 'America/Chicago',
        'CDT': 'America/Chicago',
        'MST': 'America/Denver',
        'MDT': 'America/Denver',
        'GMT': 'Europe/London',
        'BST': 'Europe/London',
        'CET': 'Europe/Paris',
        'CEST': 'Europe/Paris',
        'JST': 'Asia/Tokyo',
        'AEST': 'Australia/Sydney',
        'AEDT': 'Australia/Sydney',
      };
      previous.forEach((abbreviation, iana) {
        expect(
          ianaForAbbreviation(abbreviation),
          iana,
          reason: '$abbreviation regressed from the notification table',
        );
      });
    });

    test('every mapped value is a Region/City name', () {
      ianaByAbbreviation.forEach((abbreviation, iana) {
        expect(
          iana,
          contains('/'),
          reason: '$abbreviation maps to "$iana", which is not a zone name',
        );
      });
    });
  });
}
