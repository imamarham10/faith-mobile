import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing config is loaded from android/key.properties (gitignored).
// File must define: storeFile, storePassword, keyAlias, keyPassword.
// If the file is absent we fall back to the debug keystore so anyone can
// still build a sideloadable APK locally without the real signing material.
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
val hasReleaseKeystore = keystorePropertiesFile.exists()

android {
    namespace = "com.faith.companion.faith_mobile"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // Required by flutter_local_notifications (uses java.time on pre-26 devices).
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.faith.companion.faith_mobile"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseKeystore) {
            create("release") {
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                // Play Store recommends v3 for Android 9+ (enables future
                // key rotation); v2 is the floor for any modern install.
                enableV1Signing = false
                enableV2Signing = true
                enableV3Signing = true
                enableV4Signing = true
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseKeystore) {
                signingConfigs.getByName("release")
            } else {
                // Fallback: lets contributors build a sideloadable APK
                // without ever seeing the real upload key. Play Store
                // uploads must use the real key.
                signingConfigs.getByName("debug")
            }
            // R8 is on by default for Flutter release builds; without these
            // rules it strips Gson's generic-signature metadata and the
            // flutter_local_notifications receiver crashes the process when
            // an alarm fires.
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

// An APK may fall back to the debug key — contributors sideload those, and a
// debug-signed APK is a working APK. An App Bundle may not: the only reason
// to build one is to upload it to Play, where a debug-signed bundle is at
// best rejected and at worst accepted under the wrong signing identity. The
// fallback above would make that failure *silent* — a green build producing
// an unusable artefact — so turn it into a build error instead.
//
// `key.properties` is gitignored, which means it does not exist in a fresh
// clone OR in a `git worktree`. That is exactly how a release gets
// debug-signed by accident.
gradle.taskGraph.whenReady {
    val buildingBundle = allTasks.any {
        it.name.contains("bundleRelease", ignoreCase = true) ||
            it.name.contains("ReleaseBundle", ignoreCase = true)
    }
    if (buildingBundle && !hasReleaseKeystore) {
        throw GradleException(
            "Refusing to build a debug-signed App Bundle.\n" +
                "android/key.properties is missing, so the release signing " +
                "config fell back to the debug keystore. An AAB only ever " +
                "goes to Play, where that artefact is useless.\n" +
                "Create android/key.properties with storeFile, " +
                "storePassword, keyAlias and keyPassword pointing at the " +
                "Siraat upload key, then rebuild.",
        )
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
