/// One table mapping the short timezone names Android and iOS still hand
/// out to the IANA zone they mean.
///
/// There used to be two of these — a small one in `notification_service.dart`
/// and a larger one in `local_event_queue.dart` — which is one table too
/// many: the next abbreviation anybody adds would have landed in whichever
/// file they happened to be editing.
///
/// What the two callers do *not* share is the fallback, and that difference
/// is deliberate rather than an oversight:
///
/// * `NotificationService` falls through to the raw name. The `timezone`
///   package may well recognise it (`Asia/Kolkata` arrives unchanged on
///   plenty of devices), and if it does not, `getLocation` throws and the
///   caller catches and settles for UTC. A wrong guess costs nothing.
/// * The activity queue falls back to `UTC`. The server rejects an
///   abbreviation **permanently** (contract §1.5), so a queued row carrying
///   one can never be accepted however many times it is retried — and the
///   client then deletes it. A slightly wrong zone costs the user nothing,
///   because `timezone` is stored and never validated against `localDay`;
///   a malformed one costs them the event.
///
/// So the lookup is shared and the fallback is the caller's, which is why
/// [ianaForAbbreviation] returns `null` rather than picking one.
library;

/// Abbreviation (upper case) → IANA zone name.
///
/// Where an abbreviation is genuinely ambiguous across regions (`CST` is
/// US Central, China Standard and Cuba Standard) the entry picks the
/// largest population that reports it, because the alternative is dropping
/// the row to UTC — a worse answer for everyone the guess fits.
///
/// `UTC` is absent on purpose: both callers already handle it before they
/// reach here, and the tz database carries it as a location anyway.
///
/// `GMT` maps to `Europe/London` for the notification path, which needs a
/// *location* to schedule against. The queue never reaches this entry —
/// §1.5 accepts `GMT` verbatim, so [normaliseActivityTimezone] returns it
/// before the lookup runs. See that function; the ordering is load-bearing.
const Map<String, String> ianaByAbbreviation = {
  'GMT': 'Europe/London',
  'IST': 'Asia/Kolkata',
  'PKT': 'Asia/Karachi',
  'WIB': 'Asia/Jakarta',
  'WITA': 'Asia/Makassar',
  'WIT': 'Asia/Jayapura',
  'MYT': 'Asia/Kuala_Lumpur',
  'SGT': 'Asia/Singapore',
  'PHT': 'Asia/Manila',
  'ICT': 'Asia/Bangkok',
  'HKT': 'Asia/Hong_Kong',
  'JST': 'Asia/Tokyo',
  'KST': 'Asia/Seoul',
  'CST': 'America/Chicago',
  'CDT': 'America/Chicago',
  'EST': 'America/New_York',
  'EDT': 'America/New_York',
  'MST': 'America/Denver',
  'MDT': 'America/Denver',
  'PST': 'America/Los_Angeles',
  'PDT': 'America/Los_Angeles',
  'AKST': 'America/Anchorage',
  'AKDT': 'America/Anchorage',
  'HST': 'Pacific/Honolulu',
  'BST': 'Europe/London',
  'WET': 'Europe/Lisbon',
  'WEST': 'Europe/Lisbon',
  'CET': 'Europe/Paris',
  'CEST': 'Europe/Paris',
  'EET': 'Europe/Athens',
  'EEST': 'Europe/Athens',
  'MSK': 'Europe/Moscow',
  'TRT': 'Europe/Istanbul',
  'AST': 'Asia/Riyadh',
  'GST': 'Asia/Dubai',
  'SAST': 'Africa/Johannesburg',
  'EAT': 'Africa/Nairobi',
  'WAT': 'Africa/Lagos',
  'CAT': 'Africa/Maputo',
  'AEST': 'Australia/Sydney',
  'AEDT': 'Australia/Sydney',
  'ACST': 'Australia/Adelaide',
  'ACDT': 'Australia/Adelaide',
  'AWST': 'Australia/Perth',
  'NZST': 'Pacific/Auckland',
  'NZDT': 'Pacific/Auckland',
  'BRT': 'America/Sao_Paulo',
  'ART': 'America/Argentina/Buenos_Aires',
  'CLT': 'America/Santiago',
};

/// The IANA name [raw] abbreviates, or `null` if nothing here matches.
///
/// Case-insensitive, and whitespace-tolerant, because the two platforms do
/// not agree on either. Returns `null` — never a guess — so that each
/// caller applies the fallback its own failure mode demands; see the
/// library doc above.
String? ianaForAbbreviation(String? raw) {
  final value = raw?.trim() ?? '';
  if (value.isEmpty) return null;
  return ianaByAbbreviation[value.toUpperCase()];
}

/// Coerces [raw] into something `POST /activity/events` will accept
/// (contract §1.5).
///
/// * `Region/City` (and `Region/Sub/City`) passes through untouched.
/// * `UTC` and `GMT` pass through — §1.5 accepts both verbatim, which
///   matters because an Android device with no region configured reports
///   exactly `UTC` from `TimeZone.getID()`. **This check runs before the
///   abbreviation lookup on purpose:** the shared table maps `GMT` to
///   `Europe/London` for the notification scheduler, and that is the wrong
///   answer here — `GMT` is already a legal value and rewriting it would
///   silently relocate a user to London.
/// * A known abbreviation resolves to its IANA name.
/// * Everything else — a fixed offset (`+05:30`), an empty string, an
///   abbreviation nobody mapped — becomes `UTC`.
///
/// Falling back is the right call because `timezone` is *stored*, not
/// validated against `localDay` (§2.2): a slightly wrong zone costs the
/// user nothing today, while a malformed one costs them the event forever.
String normaliseActivityTimezone(String? raw) {
  final value = raw?.trim() ?? '';
  if (value.isEmpty) return 'UTC';
  if (value.contains('/')) return value;
  final upper = value.toUpperCase();
  if (upper == 'UTC' || upper == 'GMT') return upper;
  return ianaForAbbreviation(upper) ?? 'UTC';
}
