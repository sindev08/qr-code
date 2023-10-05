import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_project/app/constant/color.dart';
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

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: CustomColors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: CustomColors.primary,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: SingleChildScrollView(
              child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: CustomColors.white,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 32, bottom: 135),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: CustomColors.primary,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: CustomColors.white),
                        child: SizedBox(
                          height: 180,
                          width: 180,
                          child: QrImageView(
                            data: product.code,
                            version: QrVersions.auto,
                            size: 180.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: Offset(0, -120),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32.0),
                  constraints: BoxConstraints(minWidth: 320, maxWidth: 400),
                  decoration: BoxDecoration(
                      color: CustomColors.white,
                      border: Border.all(
                          color: CustomColors.grey.shade200, width: 1),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(14, 8, 48, 0.1),
                          offset: Offset(0.0, 10.0), //(x,y)
                          blurRadius: 20.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 30),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ProductSvg(
                              width: 32,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Detail Produk",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 52),
                        TextField(
                          autocorrect: false,
                          controller: codeC,
                          keyboardType: TextInputType.number,
                          readOnly: true,
                          maxLength: 10,
                          style: TextStyle(
                              fontSize: 16, color: CustomColors.grey.shade900),
                          decoration: InputDecoration(
                              labelText: "Kode Produk",
                              labelStyle: TextStyle(
                                fontSize: 14,
                                color: CustomColors.grey.shade600,
                              )),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          autocorrect: false,
                          controller: nameC,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              fontSize: 16, color: CustomColors.grey.shade900),
                          decoration: InputDecoration(
                              labelText: "Nama Produk",
                              labelStyle: TextStyle(
                                fontSize: 14,
                                color: CustomColors.grey.shade600,
                              )),
                        ),
                        const SizedBox(height: 32),
                        TextField(
                          autocorrect: false,
                          controller: qtyC,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontSize: 16, color: CustomColors.grey.shade900),
                          decoration: InputDecoration(
                              labelText: "Quantity",
                              labelStyle: TextStyle(
                                fontSize: 14,
                                color: CustomColors.grey.shade600,
                              )),
                        ),
                        const SizedBox(height: 52),
                        ElevatedButton(
                            onPressed: () async {
                              if (controller.isLoadingUpdate.isFalse) {
                                if (nameC.text.isNotEmpty &&
                                    qtyC.text.isNotEmpty) {
                                  controller.isLoadingUpdate(true);
                                  // proses updaate data
                                  Map<String, dynamic> hasil = await controller
                                      .editProduct({
                                    "id": product.productId,
                                    "name": nameC.text,
                                    "qty": int.tryParse(qtyC.text) ?? 0
                                  });
                                  controller.isLoadingUpdate(false);
                                  Get.back();
                                  Get.snackbar(
                                      hasil["error"] == true
                                          ? "Error"
                                          : "Berhasil",
                                      hasil["message"],
                                      duration: const Duration(seconds: 2));
                                } else {
                                  Get.snackbar(
                                      "Error", "Semua data wajib diisi",
                                      duration: const Duration(seconds: 2));
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              minimumSize: Size(266, 30),
                            ),
                            child: Text(controller.isLoadingUpdate.isFalse
                                ? "Update Product"
                                : "Loading...")),
                        TextButton(
                            onPressed: () {
                              Get.defaultDialog(
                                  title: "Delete Product",
                                  middleText:
                                      "Are you sure to delete this product?",
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
                                          Map<String, dynamic> hasil =
                                              await controller.deleteProduct(
                                                  product.productId);
                                          controller.isLoadingDelete(false);

                                          // Balik ke page all product
                                          Get.back(); // tutup dialog
                                          Get.back(); // Balik ke page all products
                                          Get.snackbar(
                                              hasil["error"] == true
                                                  ? "Error"
                                                  : "Berhasil",
                                              hasil["message"],
                                              duration:
                                                  const Duration(seconds: 2));
                                        },
                                        child: Obx(() =>
                                            controller.isLoadingDelete.isFalse
                                                ? const Text("Delete")
                                                : Container(
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    height: 15,
                                                    width: 15,
                                                    child:
                                                        const CircularProgressIndicator(
                                                            color: Colors.white,
                                                            strokeWidth: 1),
                                                  )))
                                  ]);
                            },
                            child: Text(
                              "Delete Product",
                              style: TextStyle(color: Colors.red.shade900),
                            ))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ))),
    );
  }

  // Widget Positioning(height) {
  //   return Stack(children: [
  //     Positioned(
  //         top: 0,
  //         left: 0,
  //         right: 0,
  //         child: Container(
  //           decoration: BoxDecoration(
  //               color: CustomColors.white,
  //               borderRadius: const BorderRadius.only(
  //                   bottomLeft: Radius.circular(24),
  //                   bottomRight: Radius.circular(24))),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Container(
  //                 margin: EdgeInsets.only(top: 32, bottom: 135),
  //                 padding: const EdgeInsets.all(12.0),
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(12),
  //                   color: CustomColors.primary,
  //                 ),
  //                 child: Container(
  //                   decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(8),
  //                       color: CustomColors.white),
  //                   child: SizedBox(
  //                     height: 180,
  //                     width: 180,
  //                     child: QrImageView(
  //                       data: product.code,
  //                       version: QrVersions.auto,
  //                       size: 180.0,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         )),
  //     Positioned(
  //       top: height,
  //       left: 0,
  //       right: 0,
  //       bottom: 0,
  //       child: SingleChildScrollView(
  //         scrollDirection: Axis.vertical,
  //         child: Container(
  //           margin: const EdgeInsets.symmetric(horizontal: 32.0),
  //           decoration: BoxDecoration(
  //               color: CustomColors.white,
  //               border: Border.all(color: CustomColors.grey.shade200, width: 1),
  //               boxShadow: const [
  //                 BoxShadow(
  //                   color: Color.fromRGBO(14, 8, 48, 0.1),
  //                   offset: Offset(0.0, 10.0), //(x,y)
  //                   blurRadius: 20.0,
  //                 ),
  //               ],
  //               borderRadius: BorderRadius.circular(12)),
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
  //             child: Column(
  //               children: [
  //                 Row(
  //                   children: [
  //                     ProductSvg(
  //                       width: 32,
  //                     ),
  //                     const SizedBox(width: 10),
  //                     const Text(
  //                       "Detail Produk",
  //                       style: TextStyle(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.w700,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 52),
  //                 TextField(
  //                   autocorrect: false,
  //                   controller: codeC,
  //                   keyboardType: TextInputType.number,
  //                   readOnly: true,
  //                   maxLength: 10,
  //                   style: TextStyle(
  //                       fontSize: 16, color: CustomColors.grey.shade900),
  //                   decoration: InputDecoration(
  //                       labelText: "Kode Produk",
  //                       labelStyle: TextStyle(
  //                         fontSize: 14,
  //                         color: CustomColors.grey.shade600,
  //                       )),
  //                 ),
  //                 const SizedBox(height: 12),
  //                 TextField(
  //                   autocorrect: false,
  //                   controller: nameC,
  //                   keyboardType: TextInputType.text,
  //                   style: TextStyle(
  //                       fontSize: 16, color: CustomColors.grey.shade900),
  //                   decoration: InputDecoration(
  //                       labelText: "Nama Produk",
  //                       labelStyle: TextStyle(
  //                         fontSize: 14,
  //                         color: CustomColors.grey.shade600,
  //                       )),
  //                 ),
  //                 const SizedBox(height: 32),
  //                 TextField(
  //                   autocorrect: false,
  //                   controller: qtyC,
  //                   keyboardType: TextInputType.number,
  //                   style: TextStyle(
  //                       fontSize: 16, color: CustomColors.grey.shade900),
  //                   decoration: InputDecoration(
  //                       labelText: "Quantity",
  //                       labelStyle: TextStyle(
  //                         fontSize: 14,
  //                         color: CustomColors.grey.shade600,
  //                       )),
  //                 ),
  //                 const SizedBox(height: 52),
  //                 ElevatedButton(
  //                     onPressed: () async {
  //                       if (controller.isLoadingUpdate.isFalse) {
  //                         if (nameC.text.isNotEmpty && qtyC.text.isNotEmpty) {
  //                           controller.isLoadingUpdate(true);
  //                           // proses updaate data
  //                           Map<String, dynamic> hasil = await controller
  //                               .editProduct({
  //                             "id": product.productId,
  //                             "name": nameC.text,
  //                             "qty": int.tryParse(qtyC.text) ?? 0
  //                           });
  //                           controller.isLoadingUpdate(false);
  //                           Get.back();
  //                           Get.snackbar(
  //                               hasil["error"] == true ? "Error" : "Berhasil",
  //                               hasil["message"],
  //                               duration: const Duration(seconds: 2));
  //                         } else {
  //                           Get.snackbar("Error", "Semua data wajib diisi",
  //                               duration: const Duration(seconds: 2));
  //                         }
  //                       }
  //                     },
  //                     style: ElevatedButton.styleFrom(
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(9),
  //                       ),
  //                       padding: const EdgeInsets.symmetric(vertical: 12),
  //                       minimumSize: Size(266, 30),
  //                     ),
  //                     child: Text(controller.isLoadingUpdate.isFalse
  //                         ? "Update Product"
  //                         : "Loading...")),
  //                 TextButton(
  //                     onPressed: () {
  //                       Get.defaultDialog(
  //                           title: "Delete Product",
  //                           middleText: "Are you sure to delete this product?",
  //                           actions: [
  //                             OutlinedButton(
  //                                 onPressed: () => Get.back(),
  //                                 child: const Text(
  //                                   "Cancel",
  //                                   style: TextStyle(
  //                                       // color: Colors.red.shade900,
  //                                       ),
  //                                 )),
  //                             ElevatedButton(
  //                                 onPressed: () async {
  //                                   controller.isLoadingDelete(true);
  //                                   // await Future.delayed(const Duration(seconds: 2));
  //                                   Map<String, dynamic> hasil =
  //                                       await controller
  //                                           .deleteProduct(product.productId);
  //                                   controller.isLoadingDelete(false);

  //                                   // Balik ke page all product
  //                                   Get.back(); // tutup dialog
  //                                   Get.back(); // Balik ke page all products
  //                                   Get.snackbar(
  //                                       hasil["error"] == true
  //                                           ? "Error"
  //                                           : "Berhasil",
  //                                       hasil["message"],
  //                                       duration: const Duration(seconds: 2));
  //                                 },
  //                                 child: Obx(
  //                                     () => controller.isLoadingDelete.isFalse
  //                                         ? const Text("Delete")
  //                                         : Container(
  //                                             padding: const EdgeInsets.all(2),
  //                                             height: 15,
  //                                             width: 15,
  //                                             child:
  //                                                 const CircularProgressIndicator(
  //                                                     color: Colors.white,
  //                                                     strokeWidth: 1),
  //                                           )))
  //                           ]);
  //                     },
  //                     child: Text(
  //                       "Delete Product",
  //                       style: TextStyle(color: Colors.red.shade900),
  //                     ))
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     )
  //   ]);
  // }
}

class ProductSvg extends StatelessWidget {
  double? width;

  ProductSvg({this.width});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/product.svg',
      semanticsLabel: 'product',
      width: width,
    );
  }
}
