import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:vero_flutter/adapter.dart';
import 'package:vero_flutter/vero_transaction_response.dart';

import 'vero_flutter_platform_interface.dart';

/// An implementation of [VeroFlutterPlatform] that uses method channels.
class MethodChannelVeroFlutter extends VeroFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('vero_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<Result?> payCredit(double amount) async {
    try {
      final response = await methodChannel.invokeMethod<Map<dynamic, dynamic>>(
          'payCredit', {'amount': _doubleAmountToInt(amount)});
      final result = response?.toResult;
      return result;
    } on PlatformException catch (e) {
      return Error(
        code: e.code,
        message: e.message ?? '',
      );
    }
  }

  @override
  Future<Result?> payDebit(double amount) async {
    try {
      final response = await methodChannel.invokeMethod<Map<dynamic, dynamic>>(
          'payDebit', {'amount': _doubleAmountToInt(amount)});
      final result = response?.toResult;
      return result;
    } on PlatformException catch (e) {
      return Error(
        code: e.code,
        message: e.message ?? '',
      );
    }
  }

  @override
  Future<Result?> payPix(double amount) async {
    try {
      final response = await methodChannel.invokeMethod<Map<dynamic, dynamic>>(
          'payPix', {'amount': _doubleAmountToInt(amount)});
      final result = response?.toResult;
      return result;
    } on PlatformException catch (e) {
      return Error(
        code: e.code,
        message: e.message ?? '',
      );
    }
  }

  @override
  Future<Result?> refund(String nsu) async {
    try {
      final response = await methodChannel
          .invokeMethod<Map<dynamic, dynamic>>('refund', {'nsu': nsu});
      final result = response?.toResult;
      return result;
    } on PlatformException catch (e) {
      return Error(
        code: e.code,
        message: e.message ?? '',
      );
    }
  }

  @override
  Future<Result?> reprint(String nsu) async {
    try {
      final response = await methodChannel
          .invokeMethod<Map<dynamic, dynamic>>('reprint', {'nsu': nsu});
      final result = response?.toResult;
      return result;
    } on PlatformException catch (e) {
      return Error(
        code: e.code,
        message: e.message ?? '',
      );
    }
  }

  int _doubleAmountToInt(double amount) => (amount * pow(10, 2)).toInt();
}
