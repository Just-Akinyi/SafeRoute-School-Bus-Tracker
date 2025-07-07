plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
     // ✅ Add this line for Firebase:
    id("com.google.gms.google-services")
}

android {
    namespace = "com.techtalktechnologies.saferoute"
    compileSdk = flutter.compileSdkVersion
    // ndkVersion = flutter.ndkVersion
    ndkVersion = "27.0.12077973" // ✅ Override here

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
        languageVersion = "2.0"
        apiVersion = "2.0"
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.techtalktechnologies.saferoute"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true// ✅ This must use '=' in Kotlin!

    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
dependencies {

    // ✅ Import the Firebase BoM
    
    implementation(platform("com.google.firebase:firebase-bom:33.16.0"))

    // ✅ Firebase Analytics (example, remove or replace with others as needed)
    
    implementation("com.google.firebase:firebase-analytics")
    // 🔁 Add other Firebase SDKs here as needed:
    // e.g., implementation("com.google.firebase:firebase-auth")
    //       implementation("com.google.firebase:firebase-firestore")

    // Core Firebase services
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")

    // Optional: analytics, messaging, etc.
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.android.gms:play-services-auth:20.7.0") // ✅ REQUIRED for Google Sign-In
}