// Shared loader: all v1 apps read API keys from admin_app/android/secrets.properties.
import java.util.Properties

val adminSecretsFile = rootProject.file("../../admin_app/android/secrets.properties")
val ksaAdminSecrets = Properties()
if (adminSecretsFile.exists()) {
    ksaAdminSecrets.load(adminSecretsFile.inputStream())
}

extra["ksaAdminSecrets"] = ksaAdminSecrets
