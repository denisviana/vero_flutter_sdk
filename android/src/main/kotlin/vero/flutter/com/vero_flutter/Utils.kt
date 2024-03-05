package vero.flutter.com.vero_flutter

import android.content.Context
import android.database.Cursor
import android.net.Uri
import android.provider.MediaStore
import android.util.Base64
import java.io.File
import java.io.FileOutputStream
import java.io.InputStream

fun convertImageUriToBase64(context: Context, imageUri: String): String? {
    return try {
        val uri = Uri.parse(imageUri)
        val inputStream: InputStream? = context.contentResolver.openInputStream(uri)
        val bytes = inputStream?.readBytes()
        Base64.encodeToString(bytes, Base64.DEFAULT)
    } catch (e: Exception) {
        e.printStackTrace()
        null
    }
}

fun getRealPathFromURI(context: Context, contentUri: Uri): String? {
    return try {
        val file = contentUri.lastPathSegment?.let { File(context.cacheDir, it) }
        file?.outputStream().use {
            if (it != null) {
                copy(context.contentResolver.openInputStream(contentUri)!!, it)
            }
        }
        file?.absolutePath
    } catch (e: Exception) {
        e.printStackTrace()
        null
    }
}

private fun copy(inputStream: InputStream, outputStream: FileOutputStream) {
    val buffer = ByteArray(1024)
    var read = inputStream.read(buffer)
    while (read != -1) {
        outputStream.write(buffer, 0, read)
        read = inputStream.read(buffer)
    }
}