import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:qr_project/app/constant/color.dart';
import 'package:qr_project/app/controllers/auth_controller.dart';
import 'package:qr_project/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);

  final TextEditingController emailC = TextEditingController(
    text: "admin@gmail.com",
  );
  final TextEditingController passC = TextEditingController(
    text: "admin123",
  );

  final AuthController authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.grey.shade100,
        // appBar: AppBar(
        //   // iconTheme: const IconThemeData(, color: CustomColors.primary),
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   actions: [
        //     Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        //       IconButton(
        //           onPressed: () {}, icon: const Icon(Icons.arrow_back_ios))
        //     ])
        //   ],
        // ),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [LoginSvg(), SizedBox(height: 135)],
                  )),
            ),
            Positioned(
              top: 277,
              left: 0,
              right: 0,
              bottom: 50,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
                decoration: BoxDecoration(
                    color: CustomColors.white,
                    border:
                        Border.all(color: CustomColors.grey.shade200, width: 1),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(14, 8, 48, 0.1),
                        offset: Offset(0.0, 10.0), //(x,y)
                        blurRadius: 20.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          RocketSvg(),
                          const SizedBox(width: 10),
                          const Text(
                            "Login",
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
                        controller: emailC,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                            fontSize: 16, color: CustomColors.grey.shade900),
                        decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(
                              fontSize: 14,
                              color: CustomColors.grey.shade600,
                            )
                            // border:
                            //     OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                            ),
                      ),
                      const SizedBox(height: 32),
                      Obx(() => TextField(
                            autocorrect: false,
                            controller: passC,
                            keyboardType: TextInputType.text,
                            obscureText: controller.isHidden.value,
                            style: TextStyle(
                                fontSize: 16,
                                color: CustomColors.grey.shade900),
                            decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: TextStyle(
                                  fontSize: 14,
                                  color: CustomColors.grey.shade600,
                                ),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      controller.isHidden.toggle();
                                    },
                                    child: Icon(
                                      controller.isHidden.isFalse
                                          ? Icons.remove_red_eye
                                          : Icons.remove_red_eye_outlined,
                                      color: Colors.black,
                                    ))),
                          )),
                      const SizedBox(height: 52),
                      ElevatedButton(
                          onPressed: () async {
                            if (controller.isLoading.isFalse) {
                              if (emailC.text.isNotEmpty &&
                                  passC.text.isNotEmpty) {
                                controller.isLoading(true);
                                Map<String, dynamic> hasil =
                                    await authC.login(emailC.text, passC.text);
                                controller.isLoading(false);
                                if (hasil["error"] == true) {
                                  Get.snackbar("Error", hasil['message']);
                                } else {
                                  Get.offAllNamed(Routes.home);
                                }
                              } else {
                                Get.snackbar(
                                    "Error", "Email dan password wajib diisi");
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              minimumSize: Size(266, 40)),
                          child: Text(
                            controller.isLoading.isFalse
                                ? "Login"
                                : "Loading...",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ))
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}

class RocketSvg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/rocket.svg',
      semanticsLabel: 'login',
      width: 32,
    );
  }
}

class LoginSvg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/login.svg',
      semanticsLabel: 'login',
      width: 250,
    );
  }
}
