// ignore_for_file: deprecated_member_use, file_names, prefer_const_constructors, unused_label, curly_braces_in_flow_control_structures
import 'package:chatinunii/components/toast.dart';
import 'package:chatinunii/constants.dart';
import 'package:chatinunii/core/apis.dart';
import 'package:chatinunii/models/statusmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:translator/translator.dart';

class MakeMeGoldUser extends StatefulWidget {
  const MakeMeGoldUser();

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<MakeMeGoldUser> {
  final translator = GoogleTranslator();
  var short_desc,
      save,
      phone_number,
      error_update,
      pass_updated,
      make_me_gold_user;
  String localmage = '';
  TextEditingController phone = TextEditingController();
  bool showPassword = false;
  String? lang;
  StatusModel? status;
  var data;
  @override
  Future<void> didChangeDependencies() async {
    Locale myLocale = Localizations.localeOf(context);
    setState(() {
      lang = myLocale.toLanguageTag();
    });
    print('my locale ${myLocale.toLanguageTag()}');
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
    translator
        .translate(
            "Want to receive messages from more people? Write your phone number and we`ll help you and get you more messages",
            from: 'en',
            to: '${l.split('_')[0]}')
        .then((value) {
      setState(() {
        short_desc = value;
      });
    });
    translator
        .translate("Phone Number", from: 'en', to: '${l.split('_')[0]}')
        .then((value) {
      setState(() {
        phone_number = value;
      });
    });

    translator
        .translate("Error! while Updating password",
            from: 'en', to: '${l.split('_')[0]}')
        .then((value) {
      setState(() {
        error_update = value;
      });
    });
    translator
        .translate("Password has been Updated",
            from: 'en', to: '${l.split('_')[0]}')
        .then((value) {
      setState(() {
        pass_updated = value;
      });
    });
    translator
        .translate("SAVE", from: 'en', to: '${l.split('_')[0]}')
        .then((value) {
      setState(() {
        save = value;
      });
    });
    translator
        .translate("Make Me Gold User", from: 'en', to: '${l.split('_')[0]}')
        .then((value) {
      setState(() {
        make_me_gold_user = value;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: make_me_gold_user == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: ListView(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'gold_user_desc'.tr,
                    style: TextStyle(fontSize: 16, color: kPrimaryColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 45,
                        ),
                        buildTextField(
                            'phone_number'.tr,
                            Icon(
                              Icons.phone,
                              size: 30,
                              color: kPrimaryColor,
                            ),
                            phone),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 50,
                        child: RaisedButton(
                          onPressed: () {
                            Apis()
                                .sendGoldUserRequest(phoneNumber: phone.text)
                                .then((value) {
                              if (value == 'Bad Request') {
                                showToast('$error_update');
                              } else {
                                showToast('successfully_saved'.tr);
                                phone.clear();
                              }
                            });
                          },
                          color: kPrimaryColor,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            'save'.tr,
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      automaticallyImplyLeading: false,
      backgroundColor: kPrimaryColor,
      title: Text("make_gold_user".tr),
    );
  }

  Widget buildTextField(
      String labelText, Icon icon, TextEditingController ctrl) {
    return Container(
        width: double.infinity,
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
            border: Border.all(color: kPrimaryColor, width: 1),
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            icon,
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                child: TextFormField(
                  controller: ctrl,
                  maxLines: 1,
                  decoration: InputDecoration(
                    label: Text(labelText),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
