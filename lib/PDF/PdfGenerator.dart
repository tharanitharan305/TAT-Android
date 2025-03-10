import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'PDF.dart';

class PdfGenerator extends StatelessWidget {
  PdfGenerator({super.key, required this.pdf});
  PDF pdf;
  Future<pw.Image> getImageFromAsset(String assetName) async {
    final ByteData data = await rootBundle.load(assetName);
    final Uint8List bytes = data.buffer.asUint8List();
    return pw.Image(pw.MemoryImage(bytes), width: 70, height: 70);
  }

  double dis = 0;

  Future<void> generatePdf() async {
    final image =
        await getImageFromAsset('images/tatlogo.png'); // Change the asset path
    final pdf1 = pw.Document();
    pdf1.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Column(children: [
              pw.Row(
                children: [
                  image,
                  pw.SizedBox(width: 50),
                  pw.Text("THARANI A TRADERS",
                      style: pw.TextStyle(
                          fontSize: 30, fontWeight: pw.FontWeight.bold))
                ],
              ),
              pw.SizedBox(
                height: 20,
              ),
              pw.Row(children: [
                pw.Text("Shopname:${pdf.Shopname}"),
                pw.Spacer(),
                pw.Text("Date:${pdf.Date}")
              ]),
              pw.SizedBox(
                height: 20,
              ),
              pw.Table(
                  border: pw.TableBorder(
                      horizontalInside:
                          pw.BorderSide(width: 0.4, color: PdfColors.grey)),
                  children: [
                    pw.TableRow(children: [
                      pw.Text("Products"),
                      pw.Text("Quantity"),
                      pw.Text("Free"),
                      pw.Text("MRP"),
                      pw.Text("SellingPrice"),
                      pw.Text("Total")
                    ]),
                    ...pdf.items.map((e) {
                      print(e.product.mrp.toString() + " " + e.free.toString());
                      return pw.TableRow(children: [
                        pw.Text(e.product.productName),
                        pw.Text(e.qty.toString()),
                        pw.Text(e.free.toString()),
                        pw.Text(e.product.mrp.toString()),
                        pw.Text(e.product.sPrice.toString()),
                        pw.Text((e.qty * e.product.sPrice).toString())
                      ]);
                    }).toList()
                  ]),
              pw.SizedBox(
                height: 20,
              ),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                pw.Text("Discound:$dis%"),
                pw.Text(
                    "Total:${dis > 0 ? (double.parse(pdf.total) * (dis / 100)) : pdf.total}")
              ]),
            ]),
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/${pdf.Shopname}.pdf');
    await file.writeAsBytes(await pdf1.save());
    await OpenFile.open(file.path);
  }

  Future<void> _openPdf() async {
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/${pdf.Shopname + " " + pdf.Date}.pdf');
    OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
