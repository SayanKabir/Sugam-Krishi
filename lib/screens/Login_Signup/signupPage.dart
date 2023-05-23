import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sugam_krishi/resources/auth_methods.dart';
import 'package:sugam_krishi/screens/HomePage.dart';
import 'package:sugam_krishi/screens/Login_Signup/loginPage.dart';
import 'package:sugam_krishi/screens/Login_Signup/selectCropsPage.dart';
import 'package:sugam_krishi/screens/Login_Signup/signupHandler.dart';

import '../../myCropsHandler.dart';
import '../../utils/utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _email = '';
  String _password = '';
  String _username = '';
  String _contact = '';
  TextEditingController phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  RegExp regex = RegExp(r'^(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$');
  double screenHeight = 0;
  double screenWidth = 0;
  double bottom = 0;
  String countryDial = "+91";
  bool isLoading = false;
  String? mtoken = "";
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Uint8List? _image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermissions();
    getToken();
    initInfo();
  }

  void requestPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("User declined or has not accepted permission");
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print("My token is $mtoken");
      });
      // saveToken(token);
    });
  }

  void initInfo() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneController.dispose();
    // isLoading.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bottom = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.zero,
                  // color: Colors.yellow,
                  height: MediaQuery.of(context).size.width * 0.7,
                  child: ClipPath(
                    clipper: OvalBottomBorderClipper(),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            'assets/signup_illustration.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Add other widgets as necessary
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth / 12,
                    right: screenWidth / 12,
                    top: screenHeight / 12,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your username';
                          }
                          if (value.length < 3) {
                            showToastText(
                                'Username should be atleast 3 characters long');
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _username = value!;
                          SignupHandler.username = value!;
                        },
                        decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Enter your username',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            showToastText('Please enter a valid email');
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value!;
                          SignupHandler.email = value!;
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (!regex.hasMatch(value)) {
                            showToastText(
                                'Password should be atleast 6 characters long and should contain atleast one special character and one number');
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value!;
                          SignupHandler.password = value!;
                        },
                        obscureText: true,
                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon: Icon(FontAwesomeIcons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      IntlPhoneField(
                        controller: phoneController,
                        validator: (value) {
                          if (phoneController.text.isEmpty) {
                            showToastText('Please enter your phone number');
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _contact = value!.completeNumber;
                          SignupHandler.contact = value!.completeNumber;
                        },
                        showCountryFlag: false,
                        showDropdownIcon: false,
                        initialValue: countryDial,
                        onCountryChanged: (country) {
                          setState(() {
                            countryDial = "+" + country.dialCode;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Phone number',
                          hintText: 'Enter your phone number',
                          prefixIcon: Icon(FontAwesomeIcons.mobile),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: ((context) => SelectCropsPage()),
                              ),
                            );
                          }
                        },
                        child: Container(
                          height: 50,
                          width: screenWidth,
                          // margin: EdgeInsets.only(bottom: screenHeight / 12),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: isLoading
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    "SIGNUP",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                      fontSize: 18,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              minimumSize: MaterialStateProperty.all(
                                  Size(screenWidth, 50)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            },
                            child: Text("Already have an account? Login")),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
