import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:vero_flutter/vero_flutter.dart';
import 'package:vero_flutter/vero_transaction_response.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _veroFlutterPlugin = VeroFlutter();

  String _nsu = "";
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _veroFlutterPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text('Running on: $_platformVersion\n'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final result = await _veroFlutterPlugin.payCredit(10.00);
                    if (result is TransactionResult) {
                      _nsu = result.nsu;
                      _showReceiptImageDialog(
                        File(result.customerReceipt),
                      );
                    } else if (result is Error) {
                      _scaffoldMessengerKey.currentState!.showSnackBar(
                        SnackBar(
                          content: Text(
                            result.message,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Pagamento Crédito'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final result = await _veroFlutterPlugin.payDebit(10.00);
                    if (result is TransactionResult) {
                      _nsu = result.nsu;
                      _showReceiptImageDialog(
                        File(result.customerReceipt),
                      );
                    } else if (result is Error) {
                      _scaffoldMessengerKey.currentState!.showSnackBar(
                        SnackBar(
                          content: Text(
                            result.message,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Pagamento Débito'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final result = await _veroFlutterPlugin.payPix(10.00);
                    if (result is TransactionResult) {
                      _nsu = result.nsu;
                      _showReceiptImageDialog(
                        File(result.customerReceipt),
                      );
                    } else if (result is Error) {
                      _scaffoldMessengerKey.currentState!.showSnackBar(
                        SnackBar(
                          content: Text(
                            result.message,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Pagamento PIX'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final result = await _veroFlutterPlugin.refund(_nsu);
                    if (result is TransactionResult) {
                      _nsu = "";
                      _scaffoldMessengerKey.currentState!.showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Estorno realizado com sucesso',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    } else if (result is Error) {
                      _scaffoldMessengerKey.currentState!.showSnackBar(
                        SnackBar(
                          content: Text(
                            result.message,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Estornar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showReceiptImageDialog(File receiptImageFile) {
    showDialog(
      context: _scaffoldMessengerKey.currentState!.context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image.file(receiptImageFile),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
