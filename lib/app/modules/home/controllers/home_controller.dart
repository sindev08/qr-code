import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class HomeController extends GetxController {
  void downloadCatalog() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Column(children: [
              pw.Center(
                  child: pw.Text("Catalog Product",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 24,
                      ))),
              pw.SizedBox(height: 20),
              pw.Table(
                  border: pw.TableBorder.all(
                      color: PdfColor.fromHex("#000000"), width: 2),
                  children: [
                    pw.TableRow(children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.all(20),
                        child: pw.Text("No",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(20),
                        child: pw.Text("Product code",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(20),
                        child: pw.Text("Nama Barang",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(20),
                        child: pw.Text("Quantity",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(20),
                        child: pw.Text("QR Code",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      ),
                    ]),
                    // table body
                    ...List.generate(6, (index) {
                      return pw.TableRow(children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(20),
                          child: pw.Text("${index + 1}",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                fontSize: 12,
                              )),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(20),
                          child: pw.Text("${83178 + index}",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                fontSize: 12,
                              )),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(20),
                          child: pw.Text("Barang ${index + 1}",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                fontSize: 12,
                              )),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(20),
                          child: pw.Text("3232${1312 + index}",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                fontSize: 12,
                              )),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(20),
                          child: pw.Text("QR Code",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                fontSize: 12,
                              )),
                        ),
                      ]);
                    })
                  ])
            ]);
          }),
    );

    // simpan
    Uint8List bytes = await pdf.save();

    // Buat file kosong di direktori
    final dir = await getApplicationCacheDirectory();
    final file = File("${dir.path}/mydocument.pdf");

    // memasukkan data bytes -> file kosong
    await file.writeAsBytes(bytes);

    // buka pdf
    await OpenFile.open(file.path);
  }
}
