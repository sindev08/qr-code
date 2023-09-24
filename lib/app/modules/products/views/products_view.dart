import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_project/app/constant/color.dart';
import 'package:qr_project/app/data/product_model.dart';
import 'package:qr_project/app/routes/app_pages.dart';

import '../controllers/products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: CustomColors.grey.shade100,
          // appBar: AppBar(
          //   title: const Text('Products'),
          //   centerTitle: true,
          // ),
          body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: controller.streamProducts(),
              builder: (context, snapProducts) {
                if (snapProducts.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapProducts.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No Product"),
                  );
                }
                List<ProductModel> allProducts = [];
                for (var element in snapProducts.data?.docs ?? []) {
                  allProducts.add(ProductModel.fromJson(element.data()));
                }
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: 32,
                        top: 32,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ProductSvg(width: 32),
                          SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "List Produk",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: allProducts.length,
                          padding: const EdgeInsets.all(32),
                          itemBuilder: (context, index) {
                            ProductModel product = allProducts[index];
                            return Container(
                                margin: const EdgeInsets.only(bottom: 32),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    Get.toNamed(Routes.detailProduct,
                                        arguments: product);
                                  },
                                  child: Container(
                                    height: 104,
                                    width: 326,
                                    decoration: BoxDecoration(
                                        color: CustomColors.white,
                                        border: Border.all(
                                            color: CustomColors.grey.shade200,
                                            width: 1),
                                        boxShadow: const [
                                          BoxShadow(
                                            color:
                                                Color.fromRGBO(14, 8, 48, 0.1),
                                            offset: Offset(0.0, 10.0), //(x,y)
                                            blurRadius: 20.0,
                                          ),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          bottom: 0,
                                          child: Container(
                                            width: 10,
                                            height: double.infinity,
                                            decoration: const BoxDecoration(
                                                color: CustomColors.primary,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(12),
                                                    bottomLeft: Radius.circular(
                                                        12)) // Color of the bar
                                                ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          left: 10,
                                          bottom: 0,
                                          width: 296,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  height: 80,
                                                  width: 80,
                                                  child: QrImageView(
                                                    data: product.code,
                                                    version: QrVersions.auto,
                                                    size: 200.0,
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          "Kode : ",
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                        Text(
                                                          product.code,
                                                          style: const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        )
                                                      ],
                                                    ),
                                                    // const SizedBox(
                                                    //   height: 8,
                                                    // ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          "Nama : ",
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                        Text(
                                                          product.name,
                                                          style: const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        )
                                                      ],
                                                    ),
                                                    // const SizedBox(
                                                    //   height: 8,
                                                    // ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          'Jumlah :',
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                        Text(
                                                          ' ${product.qty}',
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                ArrowRightSvg(
                                                  width: 32,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                          }),
                    ),
                  ],
                );
              })),
    );
  }
}

class ArrowRightSvg extends StatelessWidget {
  double? width;

  ArrowRightSvg({this.width});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/arrowRight.svg',
      semanticsLabel: 'Arrow Right',
      width: width,
    );
  }
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
