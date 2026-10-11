package com.faith.companion.faith_mobile

import com.ryanheise.audioservice.AudioServiceFragmentActivity

// Must extend `AudioServiceFragmentActivity` (audio_service), not a plain
// Flutter activity: it hands `AudioService` a cached FlutterEngine, which is
// what lets the service and the UI share one Dart isolate. Without it,
// `AudioService.init()` has no engine to attach to and the notification's
// "click starts activity" lands in a second, stateless engine.
//
// The *Fragment* flavour (rather than `AudioServiceActivity`) preserves the
// previous `FlutterFragmentActivity` base class — it extends it directly, so
// any plugin that requires a FragmentActivity keeps working.
class MainActivity : AudioServiceFragmentActivity()
