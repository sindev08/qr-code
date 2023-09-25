import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:qr_project/app/constant/color.dart';
import 'package:qr_project/app/controllers/auth_controller.dart';
import 'package:qr_project/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailC = TextEditingController(
    text: "admin@gmail.com",
  );
  final TextEditingController passC = TextEditingController(
    text: "admin123",
  );

  final AuthController authC = Get.find<AuthController>();
  final LoginController loginController =
      Get.find<LoginController>(); // Tambahkan LoginController

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                      children: [
                        LoginSvg(
                          width: 250,
                        ),
                        SizedBox(height: 135)
                      ],
                    )),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.3,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        // vertical: MediaQuery.of(context).size.width * 0.09,
                        // horizontal: MediaQuery.of(context).size.width * 0.09,
                        vertical: 32,
                        horizontal: 32),
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
                              RocketSvg(
                                width: 32,
                              ),
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
                                fontSize: 16,
                                color: CustomColors.grey.shade900),
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
                                obscureText: loginController.isHidden.value,
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
                                          loginController.isHidden.toggle();
                                        },
                                        child: Icon(
                                          loginController.isHidden.isFalse
                                              ? Icons.remove_red_eye
                                              : Icons.remove_red_eye_outlined,
                                          color: Colors.black,
                                        ))),
                              )),
                          const SizedBox(height: 32),
                          ElevatedButton(
                              onPressed: () async {
                                if (loginController.isLoading.isFalse) {
                                  if (emailC.text.isNotEmpty &&
                                      passC.text.isNotEmpty) {
                                    loginController.isLoading(true);
                                    Map<String, dynamic> hasil = await authC
                                        .login(emailC.text, passC.text);
                                    loginController.isLoading(false);
                                    if (hasil["error"] == true) {
                                      Get.snackbar("Error", hasil['message']);
                                    } else {
                                      Get.offAllNamed(Routes.home);
                                    }
                                  } else {
                                    Get.snackbar("Error",
                                        "Email dan password wajib diisi");
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  minimumSize: Size(266, 30)),
                              child: Text(
                                loginController.isLoading.isFalse
                                    ? "Login"
                                    : "Loading...",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }
}

class RocketSvg extends StatelessWidget {
  double? width;
  RocketSvg({this.width});
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/rocket.svg',
      semanticsLabel: 'login',
      width: width,
    );
  }
}

class LoginSvg extends StatelessWidget {
  double? width;

  LoginSvg({this.width});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/login.svg',
      semanticsLabel: 'login',
      width: width,
    );
  }
}
