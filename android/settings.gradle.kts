pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.11.1" apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false

    // Firebase. Declared here so the versions live in one place, but
    // `apply false` — `app/build.gradle.kts` applies them only when
    // `android/app/google-services.json` is actually present. The
    // google-services plugin FAILS the build when that file is missing,
    // and the file cannot be committed (it belongs to the owner's Firebase
    // project), so an unconditional `plugins { }` entry here would break
    // the build for every contributor and every fresh clone.
    id("com.google.gms.google-services") version "4.4.3" apply false
    id("com.google.firebase.crashlytics") version "3.0.6" apply false
}

include(":app")
