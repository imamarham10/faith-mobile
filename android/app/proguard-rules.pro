# Keep generic-signature metadata so Gson's TypeToken<...> resolution works
# in release builds. Required by flutter_local_notifications.
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# Gson — preserve internals + the TypeToken capture pattern.
-keep class com.google.gson.** { *; }
-keep class * extends com.google.gson.TypeAdapter
-keep class * extends com.google.gson.TypeAdapterFactory
-keep class * extends com.google.gson.JsonSerializer
-keep class * extends com.google.gson.JsonDeserializer
-keepclassmembers,allowobfuscation class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# flutter_local_notifications uses Gson on the receiver path; keep its DTOs
# and the receiver classes so deserialization survives shrinking.
-keep class com.dexterous.** { *; }

# Tink (used transitively by flutter_secure_storage on some Android paths).
-keep class com.google.crypto.tink.** { *; }

# Crashlytics: keep the source file and line numbers in the obfuscated
# build so an uploaded mapping file can turn a trace back into something a
# human can read. Without these, R8 strips the line table entirely and no
# amount of mapping recovers it.
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
