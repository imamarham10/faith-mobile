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

  static const today = '/today';
  static const quran = '/quran';
  static const hadiths = '/hadiths';
  static const practice = '/practice';
  static const reflect = '/reflect';
}
