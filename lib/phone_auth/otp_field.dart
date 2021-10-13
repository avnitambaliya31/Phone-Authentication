import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OtpVerification extends StatefulWidget {
  String? phoneNumber, countrycode;
  OtpVerification({this.phoneNumber, this.countrycode});

  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  GlobalKey<FormState> _otpKey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    phoneAuthentificationData();
  }

  String smsCode = "";

  phoneAuthentificationData() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "${widget.countrycode}${widget.phoneNumber!}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithPhoneNumber(widget.phoneNumber!);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);

        // Sign the user in (or link) with the credential
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  validateToHomePage() {
    if (_otpKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: "Otp get successfully");
    } else {
      Fluttertoast.showToast(msg: "Otp is required ");
    }
  }

  bool isCounterStart = false;
  int counter = 10;
  Timer? _timer;

  timerCounter() {
    phoneAuthentificationData();
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (counter > 0) {
          counter--;
        } else {
          _timer!.cancel();
        }
      });
      if (counter == 0) {
        isCounterStart = false;
      }
    });
    if (counter == 0) {
      setState(() {
        counter = 10;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Otp Verification"),
      ),
      body: SingleChildScrollView(
        child: Form(
          autovalidate: true,
          key: _otpKey,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "Otp send to your register mobile number \n ${widget.countrycode}${widget.phoneNumber} ",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 80,
                width: size.width * 0.85,
                child: TextFormField(
                  autovalidate: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return " OTP is required *";
                    } else if (value.length < 6 || value.length > 6) {
                      return " OTP shound be a 6 digit";
                    }
                  },
                  controller: otpController,
                  keyboardType: TextInputType.number,
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
                    hintText: "Enter your OTP here ",
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
                height: 10,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 40.0),
                  child: isCounterStart == true
                      ? Text(
                          "Resend OTP in ${counter}",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.w500),
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              isCounterStart = true;
                              timerCounter();
                            });
                          },
                          child: Text(
                            "Resend OTP ",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  validateToHomePage();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                      height: 60,
                      width: size.width * 0.85,
                      color: Colors.blue,
                      child: Center(
                        child: Text(
                          "Validate OTP",
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
    );
  }
}
