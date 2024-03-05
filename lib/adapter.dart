import 'package:vero_flutter/vero_transaction_response.dart';

extension MapToResponseExtension on Map<dynamic, dynamic> {
  VeroTransactionResponse get toResponse => VeroTransactionResponse(
        status: this['status'] == 'success' ? Status.success : Status.failed,
        result: Map<String, dynamic>.from(this['result']).toResult,
      );
}

extension MapToResultExtension on Map<dynamic, dynamic> {
  Result get toResult => TransactionResult(
        serial: this['SERIAL'],
        acquiringCnpj: this['CNPJ_ADQUIRENTE'],
        flag: this['BANDEIRA'],
        establishmentName: this['NOME_ESTABELECIMENTO'],
        transaction: this['TRANSACAO'],
        receipt: this['COMPROVANTE'],
        establishmentCnpj: this['CNPJ_ESTABELECIMENTO'],
        nsu: this['NSU'],
        value: this['VALOR'],
        cardNumber: this['NUMCARTAO'],
        authorization: this['AUTORIZACAO'],
        merchantReceipt: this['COMPROVANTE_LOJISTA'],
        customerReceiptTxt: this['COMPROVANTE_CLIENTE_TXT'],
        customerReceipt: this['COMPROVANTE_CLIENTE'],
        installments: this['PARCELAS'],
        acquirerName: this['NOME_ADQUIRENTE'],
      );
}
