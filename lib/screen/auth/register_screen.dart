import 'package:flutter/material.dart';
import 'package:golden_ager/core/common_widget/custom_drop_down_form_field.dart';
import 'package:golden_ager/screen/auth/complete_patient_data_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../core/common_widget/custom_text.dart';
import '../../../../core/common_widget/custom_text_form_field.dart';
import '../../../../core/common_widget/custom_wide_buttom.dart';
import '../../../../core/common_widget/loading_widget.dart';
import '../../core/constant/constant.dart';
import '../../provider/auth_provider.dart';
import 'login_screen.dart';

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
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? userType;
  String? gender;
  String? specialty;
  List<String> userTypes = [
    'Autistic',
    'mentor',
    'doctor',
  ];
  List<String> genders = [
    'male',
    'female',
  ];
  List<String> specialties = [
    'Child psychiatrist',
    'Neurologist',
    'Pediatrician',
    'Communication specialist',
    'Psychologist',
    'Special education specialist',
    'Special education specialist',
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
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (_) {
                                  return SizedBox(
                                    height: 120,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Provider.of<AuthProvider>(context,
                                                    listen: false)
                                                .pickImage(
                                                    imageSource:
                                                        ImageSource.camera);
                                            Navigator.pop(context);
                                          },
                                          child: CustomText(
                                            text: 'Camera',
                                            color: Constant.primaryColor,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Provider.of<AuthProvider>(context,
                                                    listen: false)
                                                .pickImage(
                                                    imageSource:
                                                        ImageSource.gallery);
                                            Navigator.pop(context);
                                          },
                                          child: CustomText(
                                            text: 'Gallery',
                                            color: Constant.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: authProvider.image == null
                              ? Container(
                                  width: Constant.width(context) * 0.7,
                                  height: Constant.height(context) * 0.3,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Constant.primaryDarkColor,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.person_outline,
                                      color: Colors.white,
                                      size: 80,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: Constant.width(context) * 0.7,
                                  height: Constant.height(context) * 0.5,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image:
                                              FileImage(authProvider.image!))),
                                ),
                        );
                      },
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
                      width: Constant.width(context) * 0.9,
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
                      width: Constant.width(context) * 0.9,
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
                      width: Constant.width(context) * 0.9,
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
                      width: Constant.width(context) * 0.9,
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
                      width: Constant.width(context) * 0.9,
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
                      width: Constant.width(context) * 0.9,
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
                        if (userType == 'Autistic') {
                          setState(() {
                            userType = 'patient';
                          });
                        }
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
                      iconSize: 25,
                    ),
                    if (userType == 'doctor')
                      Offstage(
                          offstage: userType != 'doctor',
                          child: SizedBox(height: 10)),
                    if (userType == 'doctor')
                      Offstage(
                          offstage: userType != 'doctor',
                          child: CustomDropDownFormField(
                            title: 'Specialty',
                            onChanged: (value) {
                              setState(() {
                                specialty = value;
                              });
                            },
                            items: List.generate(specialties.length, (index) {
                              return DropdownMenuItem(
                                value: specialties[index],
                                child: CustomText(
                                  text: specialties[index],
                                  color: const Color(0xFF0d2137),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              );
                            }),
                            iconSize: 0,
                          )),
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
                      iconSize: 24,
                    ),
                    const SizedBox(height: 40),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return authProvider.isLoadingSignUp == true
                            ? const LoadingWidget()
                            : CustomWideButton(
                                radius: 10.0,
                                height: 40,
                                width: 130,
                                color: Constant.primaryDarkColor,
                                onTap: () async {
                                  if (authProvider.image == null) {
                                    Constant.showToast(
                                      message: 'Please select a profile image',
                                      color: Colors.red,
                                    );
                                    return;
                                  }
                                  if (!formKey.currentState!.validate()) {
                                    return;
                                  } else if (passwordConfirmController.text
                                          .toString() !=
                                      passwordController.text.toString()) {
                                    Constant.showToast(
                                      message: 'password doesn\'t match',
                                      color: Colors.red,
                                    );
                                  } else {
                                    if (userType == 'patient') {
                                      Constant.navigateTo(
                                          routeName: CompletePatientDataScreen(
                                            userType: userType!,
                                            name: nameController.text.trim(),
                                            password:
                                                passwordController.text.trim(),
                                            email: emailController.text.trim(),
                                            age: ageController.text.trim(),
                                            gender: gender!,
                                            phone: phoneController.text.trim(),
                                          ),
                                          context: context);
                                    } else {
                                      authProvider.signUp(
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        age: ageController.text,
                                        desc: '',
                                        gender: gender!,
                                        userType: userType!,
                                        specialty: specialty,
                                        medicalHistory: [],
                                        context: context,
                                      );
                                    }
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
                              Constant.navigateTo(
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
