import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("latte") {
            dimension = "flavor-type"
            applicationId = "com.downormal.use_me.latte"
            resValue(type = "string", name = "app_name", value = "Use Me Latte")
        }
        create("macchiato") {
            dimension = "flavor-type"
            applicationId = "com.downormal.use_me.macchiato"
            resValue(type = "string", name = "app_name", value = "Use Me Macchiato")
        }
        create("espresso") {
            dimension = "flavor-type"
            applicationId = "com.downormal.use_me"
            resValue(type = "string", name = "app_name", value = "Use Me")
        }
    }
}