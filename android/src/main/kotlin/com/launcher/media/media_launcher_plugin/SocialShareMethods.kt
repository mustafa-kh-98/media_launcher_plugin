package com.launcher.media.media_launcher_plugin

enum class SocialShareMethods {
    WHATSAPP,
    TELEGRAM,
    X,
    SYSTEM,
    NON;

    companion object {
        fun fromString(name: String): SocialShareMethods {
            return when (name.lowercase()) {
                "whatsapp" -> WHATSAPP
                "telegram" -> TELEGRAM
                "x" -> X
                "system" -> SYSTEM
                else -> NON
            }
        }
    }
}