import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoiceData {
  final String price;
  final String quantity;
  final String transportCost;
  final String delivery;
  final String? orderId;

  InvoiceData({
    required this.price,
    required this.quantity,
    required this.transportCost,
    required this.delivery,
    this.orderId,
  });
}

class InvoicePdfHelper {
  static Future<String> generateInvoice(InvoiceData data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Invoice',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Text('Price: ${data.price} MRU'),
                pw.Text('Quantity: ${data.quantity} Kg'),
                pw.Text('Transport cost: ${data.transportCost} MRU'),
                pw.Text('Expected delivery: ${data.delivery} days'),
              ],
            ),
          );
        },
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/invoice_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }
}

class InvoiceRecord {
  final String id;
  final String productImagePath;
  final String unitPrice;
  final String quantity;
  final String totalAmount;
  final String buyerName;
  final String invoiceDate;
  final String statusLabel;
  final Color statusColor;
  final bool isCompleted;
  final String pdfPath;
  final bool isSold;

  final String? deliveredDate;
  final String? paymentDate; // Payment from Buyer
  final String? dispatchedDate;
  final String? paymentFromAdminDate;
  final String? paymentReleaseDate;

  // Localized field
  final Map<String, String> _productNameMap;

  InvoiceRecord({
    required this.id,
    required String productName,
    required this.productImagePath,
    required this.unitPrice,
    required this.quantity,
    required this.totalAmount,
    required this.buyerName,
    required this.invoiceDate,
    required this.statusLabel,
    required this.statusColor,
    required this.isCompleted,
    required this.pdfPath,
    this.isSold = false,
    this.deliveredDate,
    this.paymentDate,
    this.dispatchedDate,
    this.paymentFromAdminDate,
    this.paymentReleaseDate,
    Map<String, String>? productNameMap,
  }) : _productNameMap = productNameMap ?? {'en': productName};

  String get productName {
    final lang = Get.locale?.languageCode ?? 'en';
    return _productNameMap[lang] ??
        _productNameMap['en'] ??
        _productNameMap.values.firstWhere(
          (v) => v.isNotEmpty,
          orElse: () => 'Product',
        );
  }
}
