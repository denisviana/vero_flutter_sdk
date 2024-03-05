import 'package:vero_flutter/vero_transaction_response.dart';

import 'vero_flutter_platform_interface.dart';

class VeroFlutter {
  Future<String?> getPlatformVersion() {
    return VeroFlutterPlatform.instance.getPlatformVersion();
  }

  Future<Result?> payCredit(double amount) {
    return VeroFlutterPlatform.instance.payCredit(amount);
  }

  Future<Result?> payDebit(double amount) {
    return VeroFlutterPlatform.instance.payDebit(amount);
  }

  Future<Result?> payPix(double amount) {
    return VeroFlutterPlatform.instance.payPix(amount);
  }

  Future<Result?> refund(String nsu) {
    return VeroFlutterPlatform.instance.refund(nsu);
  }

}
