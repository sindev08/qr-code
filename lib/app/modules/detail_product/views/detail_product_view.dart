import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_project/app/data/product_model.dart';

import '../controllers/detail_product_controller.dart';

class DetailProductView extends GetView<DetailProductController> {
  DetailProductView({Key? key}) : super(key: key);

  final ProductModel product = Get.arguments;

  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    codeC.text = product.code;
    nameC.text = product.name;
    qtyC.text = "${product.qty}";

    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Product'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  // color: Colors.grey,
                  child: QrImageView(
                    data: '9379739',
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              autocorrect: false,
              controller: codeC,
              keyboardType: TextInputType.number,
              readOnly: true,
              maxLength: 10,
              decoration: InputDecoration(
                labelText: "Product Code",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              autocorrect: false,
              controller: nameC,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Product Name",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              autocorrect: false,
              controller: qtyC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Quantity",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  if (controller.isLoadingUpdate.isFalse) {
                    if (nameC.text.isNotEmpty && qtyC.text.isNotEmpty) {
                      controller.isLoadingUpdate(true);
                      // proses updaate data
                      Map<String, dynamic> hasil = await controller
                          .editProduct({
                        "id": product.productId,
                        "name": nameC.text,
                        "qty": int.tryParse(qtyC.text) ?? 0
                      });
                      controller.isLoadingUpdate(false);
                      Get.snackbar(
                          hasil["error"] == true ? "Error" : "Berhasil",
                          hasil["message"],
                          duration: const Duration(seconds: 2));
                    } else {
                      Get.snackbar("Error", "Semua data wajib diisi",
                          duration: const Duration(seconds: 2));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20)),
                child: Text(controller.isLoadingUpdate.isFalse
                    ? "Update Product"
                    : "Loading...")),
            TextButton(
                onPressed: () {
                  Get.defaultDialog(
                      title: "Delete Product",
                      middleText: "Are you sure to delete this product?",
                      actions: [
                        OutlinedButton(
                            onPressed: () => Get.back(),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                  // color: Colors.red.shade900,
                                  ),
                            )),
                        ElevatedButton(
                            onPressed: () async {
                              controller.isLoadingDelete(true);
                              // await Future.delayed(const Duration(seconds: 2));
                              Map<String, dynamic> hasil = await controller
                                  .deleteProduct(product.productId);
                              controller.isLoadingDelete(false);

                              // Balik ke page all product
                              Get.back(); // tutup dialog
                              Get.back(); // Balik ke page all products
                              Get.snackbar(
                                  hasil["error"] == true ? "Error" : "Berhasil",
                                  hasil["message"],
                                  duration: const Duration(seconds: 2));
                            },
                            child: Obx(() => controller.isLoadingDelete.isFalse
                                ? const Text("Delete")
                                : Container(
                                    padding: const EdgeInsets.all(2),
                                    height: 15,
                                    width: 15,
                                    child: const CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 1),
                                  )))
                      ]);
                },
                child: Text(
                  "Delete Product",
                  style: TextStyle(color: Colors.red.shade900),
                ))
          ],
        ));
  }
}
