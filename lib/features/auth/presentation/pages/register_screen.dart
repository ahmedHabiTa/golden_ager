import 'package:flutter/material.dart';
import 'package:golden_ager/core/common_widget/custom_drop_down_form_field.dart';
import 'package:golden_ager/features/auth/presentation/pages/login_screen.dart';
import 'package:provider/provider.dart';

import '../../../../core/common_widget/custom_text.dart';
import '../../../../core/common_widget/custom_text_form_field.dart';
import '../../../../core/common_widget/custom_wide_buttom.dart';
import '../../../../core/common_widget/loading_widget.dart';
import '../../../../core/constant/constants.dart';
import '../provider/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final ageController = TextEditingController();
  final descController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  String? userType;
  String? gender;
  List<String> userTypes = [
    'patient',
    'mentor',
    'doctor',
  ];
  List<String> genders = [
    'male',
    'female',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const CustomText(
                      text: 'Create Account',
                      color: Color(0xFF091249),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 10),
                    CustomFormField(
                      controller: nameController,
                      onChanged: (value) {
                        setState(() {
                          value = nameController.text.trim();
                        });
                      },
                      validation: 'field is required',
                      width: Constants.width(context) * 0.9,
                      height: 50,
                      hintText: 'Name',
                    ),
                    const SizedBox(height: 10),
                    CustomFormField(
                      inputType: TextInputType.number,
                      controller: phoneController,
                      onChanged: (value) {
                        setState(() {
                          value = phoneController.text.trim();
                        });
                      },
                      validation: 'Phone number is required',
                      width: Constants.width(context) * 0.9,
                      height: 50,
                      hintText: 'Phone number',
                    ),
                    const SizedBox(height: 10),
                    CustomFormField(
                      controller: emailController,
                      onChanged: (value) {
                        setState(() {
                          value = emailController.text.trim();
                        });
                      },
                      validation: 'E-mail is required',
                      width: Constants.width(context) * 0.9,
                      height: 50,
                      hintText: 'Email',
                    ),
                    const SizedBox(height: 10),
                    CustomFormField(
                      controller: ageController,
                      onChanged: (value) {
                        setState(() {
                          value = ageController.text.trim();
                        });
                      },
                      validation: 'Age is required',
                      width: Constants.width(context) * 0.9,
                      height: 50,
                      hintText: 'Age',
                    ),
                    const SizedBox(height: 10),
                    CustomFormField(
                      controller: passwordController,
                      onChanged: (value) {
                        setState(() {
                          value = passwordController.text.trim();
                        });
                      },
                      validation: 'password is required',
                      suffixBool: true,
                      width: Constants.width(context) * 0.9,
                      height: 50,
                      hintText: 'Password',
                    ),
                    const SizedBox(height: 10),
                    CustomFormField(
                      controller: passwordConfirmController,
                      onChanged: (value) {
                        setState(() {
                          value = passwordConfirmController.text.trim();
                        });
                      },
                      validation: 'confirm password is required',
                      suffixBool: true,
                      width: Constants.width(context) * 0.9,
                      height: 50,
                      hintText: 'Confirm Password',
                    ),
                    const SizedBox(height: 10),
                    CustomDropDownFormField(
                      title: 'Type',
                      onChanged: (value) {
                        setState(() {
                          userType = value;
                        });
                        print(userType);
                      },
                      items: List.generate(userTypes.length, (index) {
                        return DropdownMenuItem(
                          value: userTypes[index],
                          child: CustomText(
                            text: userTypes[index],
                            color: const Color(0xFF0d2137),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      }),
                      iconSize: 30,
                    ),
                    const SizedBox(height: 10),
                    CustomDropDownFormField(
                      title: 'Gender',
                      onChanged: (value) {
                        setState(() {
                          gender = value;
                        });
                        print(gender);
                      },
                      items: List.generate(genders.length, (index) {
                        return DropdownMenuItem(
                          value: genders[index],
                          child: CustomText(
                            text: genders[index],
                            color: const Color(0xFF0d2137),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      }),
                      iconSize: 30,
                    ),
                    const SizedBox(height: 10),
                    CustomFormField(
                      controller: descController,
                      onChanged: (value) {
                        setState(() {
                          value = descController.text.trim();
                        });
                      },
                      validation: 'description is required',
                      width: Constants.width(context) * 0.9,
                      height: 50,
                      hintText: 'description about you',
                    ),
                    const SizedBox(height: 40),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return isLoading == true
                            ? const LoadingWidget()
                            : CustomWideButton(
                                radius: 10.0,
                                height: 40,
                                width: 130,
                                color: Constants.primaryDarkColor,
                                onTap: () async {
                                  if (!formKey.currentState!.validate()) {
                                    return;
                                  } else if (passwordConfirmController.text
                                          .toString() !=
                                      passwordController.text.toString()) {
                                    Constants.showToast(
                                      message: 'password doesn\'t match',
                                      color: Colors.red,
                                    );
                                  } else {
                                    toggleLoading();
                                    authProvider.signUp(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      age: ageController.text,
                                      desc: descController.text,
                                      gender: gender!,
                                      userType: userType!,
                                      context: context,
                                    );
                                    toggleLoading();
                                  }
                                },
                                child: const Center(
                                  child: CustomText(
                                    text: 'Sign Up',
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                      },
                    ),
                    const SizedBox(height: 25),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const CustomText(
                            text: 'Already have account ?',
                            color: Color(0xFF0d2137),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          GestureDetector(
                            onTap: () {
                              Constants.navigateTo(
                                  routeName: const LoginScreen(),
                                  context: context);
                            },
                            child: const CustomText(
                              text: 'Login',
                              decoration: TextDecoration.underline,
                              color: Color(0xFFbd4b4b),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
