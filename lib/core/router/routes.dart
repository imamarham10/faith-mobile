/// Centralized route paths. Keep this string-stable — feature code refers
/// to these constants, not literal strings.
class Routes {
  const Routes._();

  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';

  static const onboarding = '/onboarding';
  static const faithSelection = '/onboarding/faith';
  static const switchFaith = '/settings/switch-faith';
  static const deleteAccount = '/settings/delete-account';

  static const today = '/today';
  static const quran = '/quran';
  static const hadiths = '/hadiths';
  static const practice = '/practice';
  static const reflect = '/reflect';

  // Hindu equivalents of the Quran/Hadiths tabs. NOT full paths — these are
  // relative sub-route segments nested under `quran`/`hadiths` respectively
  // (go_router's `concatenatePaths` always joins parent+child regardless of
  // a leading `/`, so there is no such thing as an "absolute" nested route;
  // a leading slash here would silently do nothing useful). The tab's
  // landing widget itself is already gated by [FaithTabRouter] on a single
  // shared path — these only exist as a placeholder anchor for the real
  // hindu_scriptures/hindu_stories sub-route trees Tasks C2/C7 will nest
  // here once those modules exist.
  static const hinduScripture = 'hindu-scripture';
  static const hinduStories = 'hindu-stories';
}
