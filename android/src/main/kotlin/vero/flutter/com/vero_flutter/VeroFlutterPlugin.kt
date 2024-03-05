package vero.flutter.com.vero_flutter

import android.app.Activity
import android.content.Intent
import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import kotlin.math.PI

/** VeroFlutterPlugin */
class VeroFlutterPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware,
    PluginRegistry.ActivityResultListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var nsu: String? = null
    private var receiptPrinting = false
    private var result: MethodChannel.Result? = null
    private var activity: Activity? = null
    private var resultSent = false

    companion object {
        private val ALLOWED_MODELS = arrayOf("GPOS700", "P2-B", "L3")
        private const val PAYMENT_INTENT = "br.com.execucao.PAGAR"
        private const val REFUND_INTENT = "br.com.execucao.ESTORNAR"
        private const val RECEIPT_PRINTING = "IMPRIMIR_COMPROVANTE"
        private const val PAYMENT_REQUEST = 1
        private const val AUTHORIZATION = "AUTORIZACAO"

        private const val TRANSACTION_AMOUNT = "VALOR"
        private const val TRANSACTION = "TRANSACAO"
        private const val ERROR = "ERRO"
        private const val NSU = "NSU"

        private const val DEBIT_TRANSACTION = "DEBITO"
        private const val PIX_TRANSACTION = "PIX"
        private const val CREDIT_TRANSACTION = "CREDITO_GENERICO"


    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "vero_flutter")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        this.result = result
        resultSent = false
        when (call.method) {
            "getPlatformVersion" -> {
                this.result?.success("Android ${Build.VERSION.RELEASE}")
            }

            "payCredit" -> {
                val amount = call.argument<Int>("amount")
                if (amount != null) {
                    payCredit(amount)
                }
            }

            "payDebit" -> {
                val amount = call.argument<Int>("amount")
                if (amount != null) {
                    payDebit(amount)
                }
            }

            "payPix" -> {
                val amount = call.argument<Int>("amount")
                if (amount != null) {
                    payPix(amount)
                }
            }

            "refund" -> {
                val nsu = call.argument<String>("nsu") ?: ""
                refund(nsu)
            }

            else -> {
                this.result?.notImplemented()
            }
        }
    }

    private fun payCredit(amount: Int) {
        clearContext()
        val intent = Intent(PAYMENT_INTENT)
        intent.putExtra(TRANSACTION_AMOUNT, amount)
        intent.putExtra(TRANSACTION, CREDIT_TRANSACTION)
        callApi(intent)
    }

    private fun payDebit(amount: Int) {
        clearContext()
        val intent = Intent(PAYMENT_INTENT)
        intent.putExtra(TRANSACTION_AMOUNT, amount)
        intent.putExtra(TRANSACTION, DEBIT_TRANSACTION)
        callApi(intent)
    }

    private fun payPix(amount: Int) {
        clearContext()
        val intent = Intent(PAYMENT_INTENT)
        intent.putExtra(TRANSACTION_AMOUNT, amount)
        intent.putExtra(TRANSACTION, PIX_TRANSACTION)
        callApi(intent)
    }

    private fun refund(nsu: String) {
        if (nsu == "") {
            result?.error(activity?.getString(R.string.no_transaciton_to_refund) ?: "", null, null)
        } else {
            val intent = Intent(REFUND_INTENT)
            intent.putExtra(NSU, nsu)
            callApi(intent)
        }
    }

    private fun clearContext() {
        nsu = ""
    }

    private fun callApi(intent: Intent) {
        try {
            if (allowPrinting()) intent.putExtra(RECEIPT_PRINTING, receiptPrinting)
            activity?.startActivityForResult(intent, PAYMENT_REQUEST)
        } catch (e: Exception) {
            result?.error(
                activity?.getString(R.string.no_payment_apps_error) ?: "",
                e.message,
                null
            )
        }
    }

    private fun allowPrinting() = ALLOWED_MODELS.contains(Build.MODEL)

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == PAYMENT_REQUEST) {
            if (resultCode == Activity.RESULT_OK) {
                if (data?.hasExtra(AUTHORIZATION) == true && data.getStringExtra(AUTHORIZATION)!!
                        .isNotEmpty()
                ) {
                    val extras = data.extras
                    if (!resultSent && activity != null) {
                        this.result?.success(extras?.toMap(activity!!))
                        resultSent = true
                    }
                } else if (data?.hasExtra(ERROR) == true) {
                    if (!resultSent) {
                        result?.error(
                            activity?.getString(R.string.transaction_rejected) ?: "",
                            data.getStringExtra(ERROR),
                            null
                        )
                        resultSent = true
                    }
                }
                return true
            }
            return false
        }
        return false
    }

}
