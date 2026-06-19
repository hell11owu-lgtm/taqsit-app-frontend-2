// lib/features/home/presentation/pages/transactions_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:installment/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late Future<List<dynamic>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _transactionsFuture = _fetchTransactions();
  }

  Future<List<dynamic>> _fetchTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/transactions'),

      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'] ?? [];
    } else {
      throw Exception('فشل الاتصال');
    }
  }

  Future<void> _generateAndDownloadPDF(List<dynamic> transactions) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.cairoRegular();

    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(base: font),
        build: (pw.Context context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start, // التصحيح هنا
              children: [
                pw.Center(
                  child: pw.Text(
                    'كشف الحساب',
                    style: const pw.TextStyle(fontSize: 20),
                  ),
                ),
                pw.TableHelper.fromTextArray(
                  context: context,
                  data: [
                    ['العملية', 'المبلغ', 'التاريخ'],
                    ...transactions.map(
                      (tx) => [
                        tx['type'],
                        tx['amount'].toString(),
                        tx['created_at'].toString().substring(0, 10),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('سجل العمليات')),
      body: FutureBuilder<List<dynamic>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          return Column(
            children: [
              ElevatedButton(
                onPressed: () => _generateAndDownloadPDF(snapshot.data!),
                child: const Text('تنزيل PDF'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];
                    return Card(
                      // التصحيح هنا: استخدام EdgeInsets.only بدلاً من bottom
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title: Text(item['type']),
                        subtitle: Text(item['created_at']),
                        trailing: Text('${item['amount']} ر.س'),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
