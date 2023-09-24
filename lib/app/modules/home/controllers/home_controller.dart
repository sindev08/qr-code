import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_project/app/data/product_model.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var authChange =
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
    print('Ini data user : ${user}');
  });

  RxList<ProductModel> allProducts = List<ProductModel>.empty().obs;

  void downloadCatalog() async {
    final pdf = pw.Document();

    // reset all products => untuk mengatasi duplikat
    allProducts([]);

    // Isi daata all product dari database
    var getData = await firestore.collection("products").get();
    for (var element in getData.docs) {
      allProducts.add(ProductModel.fromJson(element.data()));
    }

    pdf.addPage(
      pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            List<pw.TableRow> allData =
                List.generate(allProducts.length, (index) {
              ProductModel product = allProducts[index];
              return pw.TableRow(children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(20),
                  child: pw.Text("${index + 1}",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 10,
                      )),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(20),
                  child: pw.Text(product.code,
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 10,
                      )),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(20),
                  child: pw.Text(product.name,
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 10,
                      )),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(20),
                  child: pw.Text("${product.qty}",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 10,
                      )),
                ),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(20),
                    child: pw.BarcodeWidget(
                        color: PdfColor.fromHex("#000000"),
                        barcode: pw.Barcode.qrCode(),
                        width: 50,
                        height: 50,
                        data: product.code)),
              ]);
            });

            return [
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
                                fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(20),
                        child: pw.Text("Product code",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(20),
                        child: pw.Text("Nama Barang",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(20),
                        child: pw.Text("Quantity",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(20),
                        child: pw.Text("QR Code",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      ),
                    ]),
                    // table body
                    ...allData
                  ])
            ];
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

  Future getProductById(String codeBarang) async {
    try {
      // get from firebase

      var hasil = await firestore
          .collection("products")
          .where("code", isEqualTo: codeBarang)
          .get();

      if (hasil.docs.isEmpty) {
        return {
          "error": true,
          "message": "Tidak ada product ini di database ${codeBarang}",
        };
      }

      Map<String, dynamic> data = hasil.docs.first.data();

      return {
        "error": false,
        "message": "Berhasil mendapatkan detail product",
        "data": ProductModel.fromJson(data)
      };
    } catch (e) {
      return {
        "error": true,
        "message": "Tidak mendapatkan detail product dari code ini",
      };
    }
  }
}
