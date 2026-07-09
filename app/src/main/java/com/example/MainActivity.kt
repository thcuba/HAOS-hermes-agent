// app/build.gradle.kts

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // ... altri plugin ...
}

android {
    namespace = "com.aistudio.haos-hermes-agent"
    compileSdk = 34 // O la tua versione corrente

    defaultConfig {
        applicationId = "com.aistudio.haos-hermes-agent"
        minSdk = 24 // O la tua versione corrente
        targetSdk = 34 // O la tua versione corrente
        // ... altre configurazioni ...

        // === INIZIO MODIFICA ===
        // Il versionCode DEVE essere un numero intero e incrementato ad ogni nuova release
        // In precedenza era 42, ora lo incrementiamo a 43.
        versionCode = 43 
        
        // Il versionName è una stringa leggibile dall'utente e spesso segue il versioning semantico.
        // Anche questo andrebbe aggiornato per riflettere la nuova versione del software.
        versionName = "1.0.1" // Esempio: incrementato da "1.0.0" a "1.0.1" o "1.1.0"
        // === FINE MODIFICA ===

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        vectorDrawables {
            useSupportLibrary = true
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        debug {
            isMinifyEnabled = false
            // ... altre configurazioni per debug ...
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
    kotlinOptions {
        jvmTarget = "1.8"
    }
    buildFeatures {
        compose = true
    }
    composeOptions {
        kotlinCompilerExtensionVersion = "1.5.1" // O la tua versione corrente
    }
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
    // ... altre configurazioni ...
}

dependencies {
    // ... le tue dipendenze ...
}