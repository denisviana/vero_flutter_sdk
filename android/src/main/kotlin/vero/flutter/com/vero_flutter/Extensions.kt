package vero.flutter.com.vero_flutter

import android.content.Context
import android.net.Uri
import android.os.Bundle
import java.net.URI

fun Bundle.toMap(context: Context): Map<String, Any?> {
    val map: MutableMap<String, Any?> = mutableMapOf()
    for (key in this.keySet()) {
        val value = this.get(key)
        map[key] = if (value is Uri) getRealPathFromURI(context, value) else value
    }
    return map
}