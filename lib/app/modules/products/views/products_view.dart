import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_project/app/data/product_model.dart';
import 'package:qr_project/app/routes/app_pages.dart';

import '../controllers/products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
          centerTitle: true,
        ),
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
              return ListView.builder(
                  itemCount: allProducts.length,
                  padding: const EdgeInsets.all(20),
                  itemBuilder: (context, index) {
                    ProductModel product = allProducts[index];
                    return Card(
                        elevation: 5,
                        margin: const EdgeInsets.only(bottom: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9)),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(9),
                          onTap: () {
                            Get.toNamed(Routes.detailProduct,
                                arguments: product);
                          },
                          child: Container(
                            height: 100,
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.code,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(product.name),
                                      Text("Jumlah : ${product.qty}")
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: QrImageView(
                                    data: '9379739',
                                    version: QrVersions.auto,
                                    size: 200.0,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ));
                  });
            }));
  }
}
