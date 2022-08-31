import 'dart:async';
import 'dart:convert';

import 'package:chatinunii/authScreens/login.dart';
import 'package:chatinunii/components/toast.dart';
import 'package:chatinunii/constants.dart';
import 'package:chatinunii/core/apis.dart';
import 'package:chatinunii/models/statusmodel.dart';
import 'package:chatinunii/screens/splashscreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

Apis apis = Apis();

TextEditingController usernamecontroller = TextEditingController();
TextEditingController emailcontroller = TextEditingController();
TextEditingController passwordcontroller = TextEditingController();
TextEditingController confirmpasswordcontroller = TextEditingController();
StatusModel? status;
String? statusid;
int range = 0;
Locale? getlang;

class _SignupState extends State<Signup> {
  late bool _passwordVisible;
  final formKey = GlobalKey<FormState>();
  final translator = GoogleTranslator();
  var name,
      pass,
      login,
      forgetpass,
      clickhere,
      iHaveAcc,
      signUp,
      loginas,
      email,
      selectStatus,
      select,
      statuslist,
      notReg,
      success,
      policy,
      acceptPolicy;
  Future getFcm() async {
    return await FirebaseMessaging.instance.getToken();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var l = Get.deviceLocale.toString();
    if (l.contains("uk") || l.contains("ru")) {
      setState(() {
        l = "uk_UA";
      });
    } else if (l.contains("tr")) {
      setState(() {
        l = "tr_Tr";
      });
    } else {
      setState(() {
        l = "en_US";
      });
    }
    print("lang: ${l.toString()}");
    Future.delayed(Duration.zero, () {
      setState(() {
        getlang = Localizations.localeOf(context);
      });

      translator
          .translate(
              "Please, accept our privacy policy and terms and conditions, thanks",
              from: 'en',
              to: '${l.split('_')[0]}')
          .then((value) {
        setState(() {
          acceptPolicy = value;
        });
      });
      translator
          .translate("User registered Successfully",
              from: 'en', to: '${l.split('_')[0]}')
          .then((value) {
        setState(() {
          success = value;
        });
      });
      translator
          .translate("Please, Select status",
              from: 'en', to: '${l.split('_')[0]}')
          .then((value) {
        setState(() {
          selectStatus = value;
        });
      });
      translator
          .translate(
              "By registering to the site, you accept our privacy\n policy and terms and contitions",
              from: 'en',
              to: '${l.split('_')[0]}')
          .then((value) {
        setState(() {
          policy = value;
        });
      });

      translator
          .translate("Select Status", from: 'en', to: '${l.split('_')[0]}')
          .then((value) {
        setState(() {
          select = value;
        });
      });

      translator
          .translate("you logged in as", from: 'en', to: '${l.split('_')[0]}')
          .then((value) {
        setState(() {
          loginas = value;
        });
      });
      translator
          .translate("SignUp", from: 'en', to: '${l.split('_')[0]}')
          .then((value) {
        setState(() {
          login = value;
        });
      });
      translator
          .translate("UserName", from: 'en', to: '${l.split('_')[0]}')
          .then((value) {
        setState(() {
          name = value;
        });
      });
      translator
          .translate("Email", from: 'en', to: '${l.split('_')[0]}')
          .then((value) {
        setState(() {
          email = value;
        });
      });
      translator
          .translate("Password", from: 'en', to: '${l.split('_')[0]}')
          .then((value) {
        setState(() {
          pass = value;
        });
      });

      translator
          .translate("Oops! Not registered Successfully",
              from: 'en', to: '${l.split('_')[0]}')
          .then((value) {
        setState(() {
          notReg = value;
        });
      });
      translator
          .translate("Already have an account?",
              from: 'en', to: '${l.split('_')[0]}')
          .then((value) {
        setState(() {
          iHaveAcc = value;
        });
      });
      translator
          .translate("Login", from: 'en', to: '${l.split('_')[0]}')
          .then((value) {
        setState(() {
          signUp = value;
        });
      });

      apis.getStatus('${l.split('_')[0]}-${l.split('_')[1]}').then((value) {
        setState(() {
          status = value;
        });
        // print(value.isSuccess);
        if (value.isSuccess == false) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Unable to get Status')));
        }
        // print(status!.response.statuses.length);
      }).whenComplete(() {
        range = status!.response.statuses.length;
        if (statuses.isEmpty) {
          for (var i = 0; i < range; i++) {
            statuses.add((status!.response.statuses[i].statusName).toString());
          }
        }
      });
    });
    _passwordVisible = false;
  }

  bool? value = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    value = false;
    _mySelection = null;
  }

  final Uri _urlEnglish = Uri.parse('https://chatinuni.com/en/pricacy-policy');
  final Uri _urlTurkish = Uri.parse('https://chatinuni.com/tr/pricacy-policy');
  final Uri _urlOther = Uri.parse('https://chatinuni.com/ua/pricacy-policy');

  Future<void> _launchUrl() async {
    if (getlang == "en_US") {
      if (!await launchUrl(_urlEnglish)) {
        throw 'Could not launch $_urlEnglish';
      }
    } else if (getlang == "tr_TR") {
      if (!await launchUrl(_urlTurkish)) {
        throw 'Could not launch $_urlTurkish';
      }
    } else {
      if (!await launchUrl(_urlOther)) {
        throw 'Could not launch $_urlOther';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (status == null || login == null)
          ? const Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            )
          : Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    // Colors.purple,
                    kPrimaryColor,
                    kContentColorLightTheme,
                  ])),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 100),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Text(
                      'ChatInUni',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50))),
                        margin: const EdgeInsets.only(top: 60),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    Container(
                                      // color: Colors.red,
                                      alignment: Alignment.topLeft,
                                      margin: const EdgeInsets.only(
                                          left: 22, bottom: 20),
                                      child: Text(
                                        "sign_up".tr,
                                        style: TextStyle(
                                            fontSize: 35,
                                            color: Colors.black87,
                                            letterSpacing: 2,
                                            fontFamily: "Lobster"),
                                      ),
                                    ),
                                    Container(
                                        width: double.infinity,
                                        height: 70,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 20),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: kPrimaryColor, width: 1),
                                            color: Colors.white,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Icon(Icons
                                                .supervised_user_circle_outlined),
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10),
                                                child: TextFormField(
                                                    maxLines: 1,
                                                    controller:
                                                        usernamecontroller,
                                                    decoration: InputDecoration(
                                                      hintText: "user_name".tr,
                                                      border: InputBorder.none,
                                                    ),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Enter user name';
                                                      }
                                                      return null;
                                                    }),
                                              ),
                                            ),
                                          ],
                                        )),
                                    Container(
                                        width: double.infinity,
                                        height: 70,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 20),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: kPrimaryColor, width: 1),
                                            color: Colors.white,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.email_outlined),
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10),
                                                child: TextFormField(
                                                  controller: emailcontroller,
                                                  maxLines: 1,
                                                  decoration: InputDecoration(
                                                    hintText: "email".tr,
                                                    border: InputBorder.none,
                                                  ),
                                                  validator: (email) {
                                                    if (email == null ||
                                                        email.isEmpty) {
                                                      return 'Email can\'t be empty!';
                                                    } else if (!(email
                                                        .contains('@'))) {
                                                      return 'Please enter a valid email!';
                                                    } else if (!(email
                                                        .contains('.com'))) {
                                                      return 'Please enter a valid email!';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                        width: double.infinity,
                                        height: 70,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 20),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: kPrimaryColor, width: 1),
                                            color: Colors.white,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.password_outlined),
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10),
                                                child: TextFormField(
                                                  obscureText:
                                                      !_passwordVisible,
                                                  controller:
                                                      passwordcontroller,
                                                  maxLines: 1,
                                                  decoration: InputDecoration(
                                                    hintText: "password".tr,
                                                    border: InputBorder.none,
                                                  ),
                                                  validator: (value) {
                                                    if (value!.isEmpty ||
                                                        value.length < 8) {
                                                      return "Password must be 8 character long";
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                _passwordVisible
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: kPrimaryColor,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _passwordVisible =
                                                      !_passwordVisible;
                                                });
                                              },
                                            ),
                                          ],
                                        )),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    statusList(),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Checkbox(
                                                checkColor: Colors.white,
                                                // fillColor: kPrimaryColor,
                                                activeColor: kPrimaryColor,
                                                value: this.value,
                                                onChanged: (v) {
                                                  setState(() {
                                                    this.value = v;
                                                  });
                                                }),
                                          ),
                                          Flexible(
                                            child: InkWell(
                                                onTap: () {
                                                  _launchUrl();
                                                },
                                                child: Text(
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: kPrimaryColor),
                                                    "by_registring_accept_terms"
                                                        .tr)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        if (_mySelection != null) {
                                          if (value == true) {
                                            apis
                                                .signUp(
                                                    usernamecontroller.text
                                                        .trim(),
                                                    emailcontroller.text.trim(),
                                                    passwordcontroller.text
                                                        .trim(),
                                                    statusid!,
                                                    getlang!.toLanguageTag())
                                                .then((value) {
                                              print(value);
                                              if (jsonDecode(
                                                      value)['IsSuccess'] ==
                                                  false) {
                                                showToast(jsonDecode(
                                                    value)['ErrorMessage']);
                                              } else {
                                                socket.emit('UpdateSocketId', {
                                                  'Token': jsonDecode(value)[
                                                      'Response']['Token'],
                                                  'FirebaseToken': fcm
                                                });
                                                showToast("$success");
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Login(),
                                                  ),
                                                );
                                                setState(() {
                                                  usernamecontroller.clear();
                                                  emailcontroller.clear();
                                                  passwordcontroller.clear();
                                                });
                                              }
                                            });
                                          } else {
                                            showDialog(
                                                context: (context),
                                                builder: (context) =>
                                                    AlertDialog(
                                                      title:
                                                          Text("$acceptPolicy"),
                                                    ));
                                          }
                                        } else {
                                          showDialog(
                                              context: (context),
                                              builder: (context) => AlertDialog(
                                                    title:
                                                        Text("$selectStatus"),
                                                  ));
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        onPrimary: kPrimaryColor,
                                        elevation: 5,
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                              colors: [
                                                kPrimaryColor,
                                                kPrimaryColor
                                              ]),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Container(
                                        width: 200,
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'sign_up'.tr,
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 70,
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "$iHaveAcc ",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 15),
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Login()));
                                            },
                                            child: Text(
                                              'login'.tr,
                                              style: TextStyle(
                                                  color: kPrimaryColor,
                                                  fontSize: 15),
                                            ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                  )
                ],
              ),
            ),
    );
  }

  List statuses = [];
  String? _mySelection;
  Widget statusList() {
    return Container(
      height: 65,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        // color: kPrimaryColor,
        border: Border.all(color: kPrimaryColor),
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.width * 0.05),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(
              Icons.bubble_chart,
              color: kPrimaryColor,
            ),
            DropdownButton<String>(
                hint: _mySelection == null
                    ? Text('status'.tr,
                        style: TextStyle(color: kPrimaryColor, fontSize: 16))
                    : Text(_mySelection!,
                        style: const TextStyle(
                            color: kPrimaryColor, fontSize: 16)),
                style: const TextStyle(color: kPrimaryColor, fontSize: 16),
                // dropdownColor: kPrimaryColor,
                items: statuses.map(
                  (val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val),
                    );
                  },
                ).toList(),
                onChanged: (val) {
                  setState(
                    () {
                      _mySelection = val!;
                    },
                  );
                  for (var i = 0; i < range; i++) {
                    if (status!.response.statuses[i].statusName ==
                        _mySelection) {
                      setState(() {
                        statusid = status!.response.statuses[i].statusId;
                        print(statusid);
                      });
                      break;
                    }
                  }
                }),
          ],
        ),
      ),
    );
  }
}
