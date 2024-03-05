import 'package:equatable/equatable.dart';

abstract class Result extends Equatable {}

class VeroTransactionResponse extends Equatable {
  final Status status;
  final Result result;

  const VeroTransactionResponse({
    required this.status,
    required this.result,
  });

  @override
  List<Object?> get props => [status, result];
}

class TransactionResult extends Result {
  final String serial;
  final String acquiringCnpj;
  final String flag;
  final String establishmentName;
  final String transaction;
  final String receipt;
  final String establishmentCnpj;
  final String nsu;
  final String value;
  final String cardNumber;
  final String authorization;
  final String merchantReceipt;
  final String customerReceiptTxt;
  final String customerReceipt;
  final String installments;
  final String acquirerName;

  TransactionResult({
    required this.serial,
    required this.acquiringCnpj,
    required this.flag,
    required this.establishmentName,
    required this.transaction,
    required this.receipt,
    required this.establishmentCnpj,
    required this.nsu,
    required this.value,
    required this.cardNumber,
    required this.authorization,
    required this.merchantReceipt,
    required this.customerReceiptTxt,
    required this.customerReceipt,
    required this.installments,
    required this.acquirerName,
  });

  @override
  List<Object?> get props => [
        serial,
        acquiringCnpj,
        flag,
        establishmentName,
        transaction,
        receipt,
        establishmentCnpj,
        nsu,
        value,
        cardNumber,
        authorization,
        merchantReceipt,
        customerReceiptTxt,
        customerReceipt,
        installments,
        acquirerName,
      ];
}

class Error extends Result {
  final String message;
  final String code;

  Error({
    required this.message,
    required this.code,
  });

  @override
  List<Object?> get props => [message, code];
}


enum Status { success, failed }
