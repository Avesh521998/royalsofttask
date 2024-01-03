import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:softtask/utility/Utility.dart';

import '../model/firebase_helper.dart';
import '../model/local_database.dart';
import '../model/user.dart';
import '../utility/AppAssets.dart';
import '../utility/AppColors.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isAdmin = false;
  bool isUser = true;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passWordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  bool _termsChecked = false;
  final LocalDatabase _localDatabase = LocalDatabase();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.white,
            size: 17,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.greenColor,
        title: const Text(
          'Register',
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
                      image: DecorationImage(image: AssetImage(AppAssets.logo))),
                ),
                selectionTabView(),
                const SizedBox(
                  height: 10,
                ),
                Utility.customTextField(nameController, "Name", nameFocusNode,
                    keyboardType: TextInputType.text,
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                    ],
                    keyboardAction: TextInputAction.next),
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
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 5,left: 16),
                      border: OutlineInputBorder( borderSide: BorderSide(
                        color: AppColors.greyColor1,
                      ),),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.greenColor,
                        ),),
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
                          color: passWordFocusNode.hasFocus ? Colors.black : AppColors.greyColor3,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: confirmPasswordController,
                    focusNode: confirmPasswordFocusNode,
                    obscureText: !_confirmPasswordVisible,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 5,left: 16),
                      border: OutlineInputBorder( borderSide: BorderSide(
                        color: AppColors.greyColor1,
                      ),),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.greenColor,
                        ),),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.greenColor,
                          )),
                      hintText: "••••••••••",
                      hintStyle: const TextStyle(fontSize: 16),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _confirmPasswordVisible = !_confirmPasswordVisible;
                          });
                        },
                        child: Icon(
                          _confirmPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: passWordFocusNode.hasFocus ? Colors.black : AppColors.greyColor3,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _termsChecked,
                      onChanged: (value) {
                        setState(() {
                          _termsChecked = value ?? false;
                        });
                      },
                    ),
                    const Text('I agree to the terms and conditions'),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Utility.customButton("Register", () async {
                  if(nameController.text.isEmpty){
                    Utility.showToast("Please enter name");
                  }else if(emailController.text.isEmpty){
                    Utility.showToast("Please enter email");
                  }else if(passWordController.text.isEmpty){
                    Utility.showToast("Please enter password");
                  }else if(confirmPasswordController.text.isEmpty){
                    Utility.showToast("Please enter confirm password");
                  }else if(passWordController.text.trim() != confirmPasswordController.text.trim()){
                    Utility.showToast("Please enter a correct confirm password");
                  }else if(!_termsChecked){
                    Utility.showToast("Please select the term and condition");
                  }else{
                    isLoading = true;
                    _notify();
                    await _localDatabase.initializeDatabase();
                    List<UserData> users = await _localDatabase.getUser(emailController.text);
                    print("======>");
                    print(users.length);
                    if (users.isEmpty) {
                      AuthenticationHelper()
                          .signUp(emailController.text, passWordController.text)
                          .then((result) async {
                            print("result is");
                            print(result);
                        if (result != null) {
                          try {
                            isLoading = false;
                            _notify();
                            await _localDatabase.insertUser(
                                name: nameController.text.trim(),
                                email: emailController.text.trim(),
                                role: isAdmin ? "admin" : "user");
                            print('Registration successful!');
                            Utility.showToast('Registration successful!');
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LogInScreen()));
                          } catch (e) {
                            isLoading = false;
                            _notify();
                            print('Error during registration: $e');
                          }
                        } else {
                          isLoading = false;
                          _notify();
                        }
                      });
                    } else {
                      isLoading = false;
                      _notify();
                      Utility.showToast("User has already exist");
                    }
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

  Widget dash() {
    return Expanded(
      child: Container(
        height: 1,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: AppColors.greyColor1),
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
                text: 'Already have account?  ',
                style: TextStyle(
                  color: AppColors.grayColor9,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: 'Sign In',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => const LogInScreen(),
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

  Widget selectionTabView() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.greyColor8)),
      child: Row(
        children: [
          Expanded(
              child: InkWell(
                  onTap: () {
                    if (isUser) {
                      isAdmin = false;
                      _notify();
                    } else {
                      isUser = true;
                    }
                  },
                  child: commonTabView("User", isUser))),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: InkWell(
                  onTap: () {
                    if (isAdmin) {
                      isUser = false;
                      _notify();
                    } else {
                      isAdmin = true;
                    }
                  },
                  child: commonTabView("Admin", isAdmin))),
        ],
      ),
    );
  }

  Widget commonTabView(String name, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: isSelected ? AppColors.greenColor : AppColors.white,
          borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: Text(name,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.white : AppColors.black)),
      ),
    );
  }

  _notify() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    nameController.text = "";
    emailController.text = "";
    passWordController.text = "";
    confirmPasswordController.text = "";
    nameController.dispose();
    emailController.dispose();
    passWordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
