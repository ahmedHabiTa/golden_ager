import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../core/common_widget/custom_text.dart';
import '../../../../core/common_widget/custom_text_form_field.dart';
import '../../../../core/common_widget/custom_wide_buttom.dart';
import '../../core/constant/constant.dart';
import '../../provider/auth_provider.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool checkValue = true;

  toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Container(
                  height: 70,
                  width: 70,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/logo.png'),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const CustomText(
                  text: ' Welcome To \n Golden Ager',
                  color: Color(0xFF0d2137),
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                ),
                const SizedBox(height: 25),
                CustomFormField(
                  prefix: const Icon(
                    Icons.email_outlined,
                    color: Colors.black87,
                    size: 30,
                  ),
                  controller: emailController,
                  onChanged: (value) {
                    setState(() {
                      value = emailController.text.trim();
                    });
                  },
                  validation: 'E-mail is required',
                  width: width * 0.9,
                  height: 50,
                  hintText: 'Email',
                ),
                const SizedBox(height: 20),
                CustomFormField(
                  prefix: const Icon(
                    Icons.lock_outline,
                    color: Colors.black87,
                    size: 30,
                  ),
                  controller: passwordController,
                  onChanged: (value) {
                    setState(() {
                      value = passwordController.text.trim();
                    });
                  },
                  validation: 'Password is required',
                  suffixBool: true,
                  width: width * 0.9,
                  height: 50,
                  hintText: 'Password',
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 200,
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: const Color(0xFF091249),
                      title: const CustomText(
                        text: 'Remember Me',
                        color: Color(0xFF0d2137),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      value: checkValue,
                      onChanged: (value) {
                        setState(() {
                          checkValue = !checkValue;
                        });
                      },
                    ),
                  ),
                ),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return isLoading == true
                        ? CircularProgressIndicator(
                            color: Constant.primaryDarkColor,
                          )
                        : CustomWideButton(
                            height: Constant.height(context) * 0.1,
                            width: Constant.width(context) * 0.8,
                            radius: 20.0,
                            color: const Color(0xFF003473),
                            onTap: () async {
                              if (!formKey.currentState!.validate()) {
                                return;
                              } else {
                                toggleLoading();
                                await authProvider.login(
                                  context: context,
                                  email: emailController.text.toString().trim(),
                                  password:
                                      passwordController.text.toString().trim(),
                                );
                                toggleLoading();
                              }
                            },
                            child: const Center(
                              child: CustomText(
                                text: 'Sign in',
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                  },
                ),
                const SizedBox(height: 25),
                const CustomText(
                  text: 'Forgot password?',
                  color: Color(0xFF0d2137),
                  decoration: TextDecoration.underline,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(height: 40),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const CustomText(
                        text: 'Don’t have account?',
                        color: Color(0xFF0d2137),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      GestureDetector(
                        onTap: () {
                          Constant.navigateTo(
                              routeName: const RegisterScreen(),
                              context: context);
                        },
                        child: const CustomText(
                          text: 'Register',
                          decoration: TextDecoration.underline,
                          color: Color(0xFFbd4b4b),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
