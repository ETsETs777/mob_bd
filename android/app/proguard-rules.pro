# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Reflection / annotations (Room, Gson, Startup)
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# AndroidX Startup (WorkManagerInitializer runs at process start)
-keep class androidx.startup.** { *; }
-keep class * implements androidx.startup.Initializer { *; }

# WorkManager + Room (R8 strips WorkDatabase_Impl no-arg ctor without these)
-keep class * extends androidx.work.Worker
-keep class * extends androidx.work.InputMerger
-keep class * extends androidx.work.ListenableWorker {
    public <init>(android.content.Context, androidx.work.WorkerParameters);
}
-keep class androidx.work.WorkerParameters { *; }
-keep class androidx.work.impl.** { *; }
-keep class * extends androidx.room.RoomDatabase {
    public <init>();
}
-keep class **_Impl { *; }
-keep @androidx.room.Entity class *
-keep @androidx.room.Dao interface *
-keepclassmembers class * extends androidx.room.RoomDatabase {
    public static ** getInstance(...);
}
-dontwarn androidx.work.**

# workmanager plugin
-keep class dev.fluttercommunity.workmanager.** { *; }

# flutter_local_notifications
-keep class com.dexterous.** { *; }
-dontwarn com.dexterous.**

# home_widget
-keep class es.antonborri.home_widget.** { *; }

# local_auth / biometric
-keep class androidx.biometric.** { *; }

# share_plus
-keep class dev.fluttercommunity.plus.share.** { *; }
