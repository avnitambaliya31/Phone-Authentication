import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phone_authentification/phone_auth/otp_field.dart';

class PhoneEditAuth extends StatefulWidget {
  PhoneEditAuth({Key? key}) : super(key: key);

  @override
  _PhoneEditAuthState createState() => _PhoneEditAuthState();
}

class _PhoneEditAuthState extends State<PhoneEditAuth> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  String? contrycode;

  Future validateAndNavigat() async {
    final form = _globalKey.currentState!;
    if (form.validate()) {
      form.save();

      Fluttertoast.showToast(
          msg: "Otp sent successfully to your register mobile number");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => OtpVerification(
                phoneNumber: phoneController.text,
                countrycode: contrycode,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Phone Authentification"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          autovalidate: true,
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                    child: const Text(
                      "Login using phone",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: SvgPicture.asset(
                    "images/phone.svg",
                    height: 70,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 80,
                  width: size.width * 0.85,
                  child: TextFormField(
                    autovalidate: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return " Name is required *";
                      }
                    },
                    controller: nameController,
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1,
                          )),
                      focusColor: Colors.black,
                      hintText: "Enter your name ",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1,
                          )),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  height: 80,
                  width: size.width * 0.85,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return " Password is required *";
                      } else if (value.length < 6) {
                        return " legth is should be 6 or more";
                      }
                    },
                    controller: passwordController,
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1,
                          )),
                      focusColor: Colors.black,
                      hintText: "Enter your password ",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1,
                          )),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  height: 80,
                  width: size.width * 0.85,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return " Please, Enter the phone number";
                      } else if (value.length < 10 || value.length > 10) {
                        return " Phone number should be 10 digit";
                      }
                    },
                    controller: phoneController,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1,
                          )),
                      focusColor: Colors.black,
                      hintText: "Enter your Phone number ",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1,
                          )),
                      prefixIcon: CountryCodePicker(
                          onChanged: (code) {
                            contrycode = code.dialCode;
                          },
                          initialSelection: 'IN',
                          favorite: ['+91', 'IN'],
                          showFlagDialog: true,
                          comparator: (a, b) => b.name!.compareTo(a.name!),
                          onInit: (code) => {
                                contrycode = code!.dialCode,
                              }),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    validateAndNavigat();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                        height: 60,
                        width: size.width * 0.85,
                        color: Colors.blue,
                        child: Center(
                          child: Text(
                            "Sign Up With OTP",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
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
