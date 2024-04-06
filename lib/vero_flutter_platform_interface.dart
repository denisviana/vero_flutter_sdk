import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:vero_flutter/vero_transaction_response.dart';

import 'vero_flutter_method_channel.dart';

abstract class VeroFlutterPlatform extends PlatformInterface {
  /// Constructs a VeroFlutterPlatform.
  VeroFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static VeroFlutterPlatform _instance = MethodChannelVeroFlutter();

  /// The default instance of [VeroFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelVeroFlutter].
  static VeroFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [VeroFlutterPlatform] when
  /// they register themselves.
  static set instance(VeroFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Result?> payCredit(double amount) {
    throw UnimplementedError('payCredit() has not been implemented.');
  }

  Future<Result?> payDebit(double amount) {
    throw UnimplementedError('payDebit() has not been implemented.');
  }

  Future<Result?> payPix(double amount) {
    throw UnimplementedError('payPix() has not been implemented.');
  }

  Future<Result?> refund(String nsu) {
    throw UnimplementedError('refund() has not been implemented.');
  }

  Future<Result?> reprint(String nsu) {
    throw UnimplementedError('reprint() has not been implemented.');
  }
}
