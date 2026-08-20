allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// The Flutter Android plugin turns build paths into process arguments. A path
// with spaces (this machine: C:\Users\MOHMMED AYMAN QUADRI\...) gets
// Unix-escaped to "MOHMMED\ AYMAN\ QUADRI" and compileFlutterBuildDebug fails.
// Keep generated Android/Flutter artifacts on a spaceless drive path.
val newBuildDir = rootProject.objects.directoryProperty().also {
    it.set(java.io.File("C:/oe-flutter-build"))
}
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    project.layout.buildDirectory.value(newBuildDir.dir(project.name))
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
