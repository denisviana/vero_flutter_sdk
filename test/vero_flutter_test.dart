import 'package:flutter_test/flutter_test.dart';
import 'package:vero_flutter/vero_flutter.dart';
import 'package:vero_flutter/vero_flutter_platform_interface.dart';
import 'package:vero_flutter/vero_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:vero_flutter/vero_transaction_response.dart';

class MockVeroFlutterPlatform
    with MockPlatformInterfaceMixin
    implements VeroFlutterPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<Result?> payCredit(double amount) =>
      Future.value(transactionResultMock);

  @override
  Future<Result?> payDebit(double amount) =>
      Future.value(transactionResultMock);

  @override
  Future<Result?> payPix(double amount) => Future.value(transactionResultMock);

  @override
  Future<Result?> refund(String nsu) => Future.value(transactionResultMock);
}

void main() {
  final VeroFlutterPlatform initialPlatform = VeroFlutterPlatform.instance;

  test('$MethodChannelVeroFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelVeroFlutter>());
  });

  test('getPlatformVersion', () async {
    VeroFlutter veroFlutterPlugin = VeroFlutter();
    MockVeroFlutterPlatform fakePlatform = MockVeroFlutterPlatform();
    VeroFlutterPlatform.instance = fakePlatform;

    expect(await veroFlutterPlugin.getPlatformVersion(), '42');
  });
}

final transactionResultMock = TransactionResult(
  serial: 'serial',
  acquiringCnpj: 'acquiringCnpj',
  flag: 'flag',
  establishmentName: 'establishmentName',
  transaction: 'transaction',
  receipt: 'receipt',
  establishmentCnpj: 'establishmentCnpj',
  nsu: 'nsu',
  value: '100',
  cardNumber: 'cardNumber',
  authorization: 'authorization',
  merchantReceipt: 'merchantReceipt',
  customerReceiptTxt: 'customerReceiptTxt',
  customerReceipt: 'customerReceipt',
  installments: 'installments',
  acquirerName: 'acquirerName',
);
