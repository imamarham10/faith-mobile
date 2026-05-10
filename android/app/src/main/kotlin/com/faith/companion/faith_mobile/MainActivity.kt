package com.faith.companion.faith_mobile

import io.flutter.embedding.android.FlutterFragmentActivity

// Must extend FlutterFragmentActivity (not FlutterActivity) so
// `just_audio_background` can bind its MediaBrowserService for Quran
// recitation playback + lock-screen controls.
class MainActivity : FlutterFragmentActivity()
