import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:softtask/model/local_database.dart';
import 'package:softtask/model/user.dart';
import 'package:softtask/screens/dashboard_screen.dart';
import 'package:softtask/screens/register_screen.dart';

import '../model/firebase_helper.dart';
import '../utility/AppAssets.dart';
import '../utility/AppColors.dart';
import '../utility/PreferenceUtils.dart';
import '../utility/Utility.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passWordFocusNode = FocusNode();
  final LocalDatabase _localDatabase = LocalDatabase();
  bool isLoading = false;
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.greenColor,
        leading: Container(),
        title: const Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: isLoading
          ? Utility.progress(context, isLoading)
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image:
                          DecorationImage(image: AssetImage(AppAssets.logo))),
                ),
                const SizedBox(
                  height: 10,
                ),
                Utility.customTextField(
                    emailController, "Email", emailFocusNode,
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp('[a-z0-9@.]')),
                    ],
                    keyboardAction: TextInputAction.next),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: passWordController,
                    focusNode: passWordFocusNode,
                    obscureText: !_passwordVisible,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 5, left: 16),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.greyColor1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.greenColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: AppColors.greenColor,
                      )),
                      hintText: "••••••••••",
                      hintStyle: const TextStyle(fontSize: 16),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                        child: Icon(
                          _passwordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: passWordFocusNode.hasFocus
                              ? Colors.black
                              : AppColors.greyColor3,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                Utility.customButton("Sign in", () {
                  if (emailController.text.isEmpty) {
                    Utility.showToast("Please enter email");
                  } else if (passWordController.text.isEmpty) {
                    Utility.showToast("Please enter password");
                  } else {
                    isLoading = true;
                    _notify();
                    AuthenticationHelper()
                        .signIn(emailController.text, passWordController.text)
                        .then((result) async {
                      if (result != null) {
                        print(result);
                        try {
                          await _localDatabase.initializeDatabase();
                          List<UserData> users = await _localDatabase
                              .getUser(emailController.text);
                          isLoading = false;
                          _notify();
                          if (users.isNotEmpty) {
                            for (int i = 0; i < users.length; i++) {
                              print(users[i].name);
                              print(users[i].email);
                              print(users[i].role);
                              await PreferenceUtils.setString(
                                "UserData",
                                jsonEncode(users[i]),
                              );
                            }
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const DashBoardScreen(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          } else {
                            isLoading = false;
                            _notify();
                            Utility.showToast("Please register your account");
                          }
                        } catch (e) {
                          isLoading = false;
                          _notify();
                          Utility.showToast(result.toString());
                        }
                      }
                    });
                  }
                }),
                const SizedBox(
                  height: 10,
                ),
                alreadyAccountWidget()
              ],
            ),
    );
  }

  Widget alreadyAccountWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        dash(),
        const SizedBox(width: 16),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "I don't have an account?  ",
                style: TextStyle(
                  color: AppColors.grayColor9,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: 'Sign Up',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const RegisterScreen(),
                      ),
                    );
                  },
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        dash(),
      ],
    );
  }

  Widget dash() {
    return Expanded(
      child: Container(
        height: 1,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: AppColors.greyColor1),
      ),
    );
  }

  _notify() {
    if (mounted) {
      setState(() {});
    }
  }
}
