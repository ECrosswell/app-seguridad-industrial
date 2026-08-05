allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Algunos plugins (permission_handler_android, entre otros) declaran
// compileSdk 37. El instalador automatico del SDK deja esa plataforma en un
// directorio llamado "android-37.0", pero Gradle la busca como "android-37" y
// falla con "Failed to find target with hash string 'android-37'".
//
// Se homogeniza a 36, que es el default de Flutter 3.44 y esta instalado. Al
// subir Flutter conviene revisar si ya se puede quitar este bloque.
subprojects {
    plugins.withId("com.android.library") {
        extensions.configure<com.android.build.gradle.LibraryExtension> {
            compileSdk = 36
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
