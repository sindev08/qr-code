import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_project/app/constant/color.dart';
import '../controllers/add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  AddProductView({Key? key}) : super(key: key);
  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: CustomColors.grey.shade100,
      body: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                    color: CustomColors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24))),
                child: Column(children: [
                  AddProductSvg(width: 250),
                  SizedBox(height: 135)
                ]),
              )),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32.0),
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
                            CreateSvg(
                              width: 32,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Tambah",
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
                              if (controller.isLoading.isFalse) {
                                if (codeC.text.isNotEmpty &&
                                    nameC.text.isNotEmpty &&
                                    qtyC.text.isNotEmpty) {
                                  controller.isLoading(true);
                                  Map<String, dynamic> hasil =
                                      await controller.addProduct({
                                    "code": codeC.text,
                                    "name": nameC.text,
                                    "qty": int.tryParse(qtyC.text) ?? 0,
                                  });
                                  controller.isLoading(false);
                                  Get.back();
                                  Get.snackbar(
                                      hasil["error"] == true
                                          ? "Error"
                                          : "Success",
                                      hasil["error"] == true
                                          ? "Semua data wajib diisi"
                                          : hasil["message"]);
                                } else {
                                  Get.snackbar(
                                      "Error", "Semua data wajib diisi");
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                minimumSize: Size(266, 30)),
                            child: Text(controller.isLoading.isFalse
                                ? "Add Product"
                                : "Loading..."))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ));
    // return Scaffold(
    //     appBar: AppBar(
    //       title: const Text('Add Product'),
    //       centerTitle: true,
    //     ),
    //     body: ListView(
    //       padding: const EdgeInsets.all(20),
    //       children: [
    //         TextField(
    //           autocorrect: false,
    //           controller: codeC,
    //           keyboardType: TextInputType.number,
    //           maxLength: 10,
    //           decoration: InputDecoration(
    //             labelText: "Product Code",
    //             border:
    //                 OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
    //           ),
    //         ),
    //         const SizedBox(height: 20),
    //         TextField(
    //           autocorrect: false,
    //           controller: nameC,
    //           keyboardType: TextInputType.text,
    //           decoration: InputDecoration(
    //             labelText: "Product Name",
    //             border:
    //                 OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
    //           ),
    //         ),
    //         const SizedBox(height: 20),
    //         TextField(
    //           autocorrect: false,
    //           controller: qtyC,
    //           keyboardType: TextInputType.number,
    //           decoration: InputDecoration(
    //             labelText: "Quantity",
    //             border:
    //                 OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
    //           ),
    //         ),
    //         const SizedBox(height: 20),
    //         ElevatedButton(
    //             onPressed: () async {
    //               if (controller.isLoading.isFalse) {
    //                 if (codeC.text.isNotEmpty &&
    //                     nameC.text.isNotEmpty &&
    //                     qtyC.text.isNotEmpty) {
    //                   controller.isLoading(true);
    //                   Map<String, dynamic> hasil = await controller.addProduct({
    //                     "code": codeC.text,
    //                     "name": nameC.text,
    //                     "qty": int.tryParse(qtyC.text) ?? 0,
    //                   });
    //                   controller.isLoading(false);
    //                   Get.back();
    //                   Get.snackbar(hasil["error"] == true ? "Error" : "Success",
    //                       "Semua data wajib diisi");
    //                 } else {
    //                   Get.snackbar("Error", "Semua data wajib diisi");
    //                 }
    //               }
    //             },
    //             style: ElevatedButton.styleFrom(
    //                 shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(9),
    //                 ),
    //                 padding: const EdgeInsets.symmetric(vertical: 20)),
    //             child: Text(controller.isLoading.isFalse
    //                 ? "Add Product"
    //                 : "Loading..."))
    //       ],
    //     ));
  }
}

class CreateSvg extends StatelessWidget {
  double? width;

  CreateSvg({this.width});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/add.svg',
      semanticsLabel: 'add',
      width: width,
    );
  }
}

class AddProductSvg extends StatelessWidget {
  double? width;

  AddProductSvg({this.width});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/addProduct.svg',
      semanticsLabel: 'addProduct',
      width: width,
    );
  }
}
