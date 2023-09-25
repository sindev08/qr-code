import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:qr_project/app/constant/color.dart';
import 'package:qr_project/app/controllers/auth_controller.dart';
import 'package:qr_project/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final AuthController authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.grey.shade100,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Stack(children: [
            Positioned(
                top: 32,
                child: Container(
                  decoration: BoxDecoration(
                    color: CustomColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(14, 8, 48, 0.1),
                        offset: Offset(0.0, 10.0), //(x,y)
                        blurRadius: 20.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    child: Row(
                      children: [
                        ProfileSvg(width: 48),
                        const SizedBox(width: 20),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Admin@gmail.com",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Admin",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        // LogoutSvg(width: 36)
                        IconButton(
                            onPressed: () async {
                              Map<String, dynamic> hasil = await authC.logout();
                              if (hasil['error'] == false) {
                                Get.offAllNamed(Routes.login);
                              } else {
                                Get.snackbar("Error", hasil["error"]);
                              }
                            },
                            icon: LogoutSvg(width: 32))
                      ],
                    ),
                  ),
                )),
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Column(
                    children: [
                      Text(
                        "Selamat datang",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 24),
                      ),
                      Text(
                        "Projek QR Code digunakan untuk pendataan barang secara realtime",
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  GridView.builder(
                    itemCount: 4,
                    shrinkWrap:
                        true, // Agar GridView dapat digunakan dalam SingleChildScrollView
                    physics:
                        const NeverScrollableScrollPhysics(), // Agar GridView tidak melakukan scrolling
                    padding: const EdgeInsets.all(20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                    ),
                    itemBuilder: (context, index) {
                      late String title;
                      late Widget icon;
                      late VoidCallback onTap;

                      switch (index) {
                        case 0:
                          title = "Tambah";
                          icon = CreateSvg(width: 68);
                          onTap = () => Get.toNamed(Routes.addProduct);
                          break;
                        case 1:
                          title = "Produk";
                          icon = ProductSvg(width: 68);
                          onTap = () => Get.toNamed(Routes.products);
                          break;
                        case 2:
                          title = "Scan";
                          icon = ScanSvg(width: 68);
                          onTap = () async {
                            String barcode =
                                await FlutterBarcodeScanner.scanBarcode(
                              "#000000",
                              "Cancel",
                              true,
                              ScanMode.QR,
                            );
                            // Get data dari firebase, search by product id
                            Map<String, dynamic> hasil =
                                await controller.getProductById(barcode);

                            if (hasil["error"] == false) {
                              Get.toNamed(Routes.detailProduct,
                                  arguments: hasil["data"]);
                            } else {
                              Get.snackbar(
                                "Error",
                                hasil["message"],
                                duration: const Duration(seconds: 2),
                              );
                            }
                          };
                          break;
                        case 3:
                          title = "Print";
                          icon = PrintSvg(width: 68);
                          onTap = () {
                            controller.downloadCatalog();
                          };
                          break;
                      }
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: CustomColors.grey.shade200, width: 1),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(14, 8, 48, 0.1),
                                offset: Offset(0.0, 10.0), //(x,y)
                                blurRadius: 20.0,
                              ),
                            ]),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: onTap,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                icon,
                                // Icon(icon, size: 50),
                                const SizedBox(height: 10),
                                Text(
                                  title,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
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

class ScanSvg extends StatelessWidget {
  double? width;

  ScanSvg({this.width});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/scan.svg',
      semanticsLabel: 'scan',
      width: width,
    );
  }
}

class PrintSvg extends StatelessWidget {
  double? width;

  PrintSvg({this.width});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/print.svg',
      semanticsLabel: 'print',
      width: width,
    );
  }
}

class ProfileSvg extends StatelessWidget {
  double? width;

  ProfileSvg({this.width});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/profile.svg',
      semanticsLabel: 'profile',
      width: width,
    );
  }
}

class LogoutSvg extends StatelessWidget {
  double? width;

  LogoutSvg({this.width});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/logout.svg',
      semanticsLabel: 'logout',
      width: width,
    );
  }
}
