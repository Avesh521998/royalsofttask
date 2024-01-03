import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../model/user.dart';
import 'AppColors.dart';
import 'PreferenceUtils.dart';

class Utility {
  static showToast(String msg) {
    if (msg.isNotEmpty) {
      Fluttertoast.showToast(
        msg: msg,
      );
    }
  }

  static UserData? getUser() {
    if (PreferenceUtils.getString("UserData") == "") {
      return null;
    }
    try {
      return UserData.fromJson(
        jsonDecode(PreferenceUtils.getString("UserData")),
      );
    } catch (e) {
      print(e);
    }
  }

  static bool isSpecialCharacter(String name) {
    return RegExp(r"[!@#$%^&*()_+\-=\[\]{};':\\|,.<>\/?]").hasMatch(name);
  }


  static String email(String email) {
    String newValue = '';
    for (int i = 0; i < email.length; i++) {
      if (i > 0 && i < email.indexOf("@")) {
        newValue += "*";
      } else {
        newValue += email[i];
      }
    }
    return newValue.split("y").first;
  }

  static bool isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static Widget progress(BuildContext context, bool isLoading) {
    return Visibility(
      visible: isLoading,
      child: Container(
        color: Colors.white,
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget customButton(String text, Function onTap,{Color? backGroundColor,double? radius,Color? textColor,double? fontWeight,double? buttonHeight}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: SizedBox(
        height: buttonHeight ?? 50,
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 13),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: backGroundColor ?? AppColors.greenColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius ?? 5)),
            shadows: const [
              BoxShadow(
                color: Color(0x3F457E02),
                blurRadius: 12,
                offset: Offset(0, 5),
                spreadRadius: 0,
              )
            ],
          ),
          child: Text(
            text,
            style: TextStyle(
              color: textColor ??  Colors.white,
              fontSize: fontWeight ?? 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  static Widget customTextField(
      TextEditingController controller, String hint, FocusNode fn,
      {String? prefixIcon,
      Widget? suffixIcon,
      TextInputType? keyboardType,
      List<TextInputFormatter>? inputFormatter,
      TextInputAction? keyboardAction,
      bool? isEnable,
      Function(String)? onChange}) {
    return SizedBox(
      height: 50,
      child: TextField(
        focusNode: fn,
        controller: controller,
        textInputAction: keyboardAction ?? TextInputAction.next,
        enabled: isEnable ?? true,
        onChanged: (value) {
          if (onChange != null) {
            onChange(value);
          }
        },
        decoration: InputDecoration(
          contentPadding: suffixIcon != null
              ? const EdgeInsets.only(
                  left: 16,
                  right: 16,
                )
              : prefixIcon == null
                  ? const EdgeInsets.only(
                      top: 8,
                      left: 16,
                      right: 16,
                    )
                  : EdgeInsets.zero,
          hintText: hint,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.greyColor1,
            ),
          ),
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: SvgPicture.asset(
                    prefixIcon,
                    color: fn.hasFocus ? Colors.black : AppColors.greyColor3,
                    height: 15,
                    width: 15,
                  ),
                )
              : null,
          suffix: suffixIcon != null
              ? SizedBox(height: 15, width: 15, child: Center(child: suffixIcon))
              : null,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.greenColor,
            ),
          ),
        ),
        inputFormatters: inputFormatter,
        keyboardType: keyboardType,
      ),
    );
  }
}

