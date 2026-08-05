plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.tesnal.seguridad_industrial"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17

        // flutter_local_notifications usa APIs de java.time, que no existen
        // antes de API 26. El desugaring las reescribe para que funcionen en
        // los equipos viejos que todavia hay en caseta.
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        applicationId = "com.tesnal.seguridad_industrial"

        // El default de Flutter 3.44 es API 24, por encima del 21 que exigen
        // ML Kit y camera. No hace falta subirlo.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Los modelos de ML Kit mas el motor de Flutter pasan del limite de
        // 64 K metodos de un solo DEX.
        multiDexEnabled = true
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
