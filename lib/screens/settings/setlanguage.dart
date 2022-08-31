// ignore_for_file: deprecated_member_use, file_names, prefer_const_constructors, unused_label, curly_braces_in_flow_control_structures
import 'dart:convert';
import 'dart:developer';

import 'package:chatinunii/components/toast.dart';
import 'package:chatinunii/constants.dart';
import 'package:chatinunii/core/apis.dart';
import 'package:chatinunii/models/statusmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

import '../../authScreens/login.dart';
import '../splashscreen.dart';

class SetLanguage extends StatefulWidget {
  const SetLanguage();

  @override
  _SetLanguageState createState() => _SetLanguageState();
}

class _SetLanguageState extends State<SetLanguage> {
  var data, langList, chatLanguage, selectLng, currenLng;
  final translator = GoogleTranslator();
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
        .translate("Current Chat Language: ",
            from: 'en', to: '${l.split('_')[0]}')
        .then((value) {
      setState(() {
        currenLng = value;
      });
    });

    translator
        .translate("Select Language", from: 'en', to: '${l.split('_')[0]}')
        .then((value) {
      setState(() {
        selectLng = value;
      });
    });

    setLang();
    Apis().GetPublicLanguageList().then((value) {
      if (value == 'Bad Request') {
        showToast('Error in getting messages');
      } else {
        setState(() {
          data = jsonDecode(value);
          print("huzaifa");
          // print(jsonDecode(value));
          langList = data['Response']['Records'].length;
          print(data['Response']['Records'].length);

          print(data['Response']['Records']);
          // for(var i in data){
          //   print(i['Response']['Records']);
          // }
        });
      }
    });
  }

  setLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    chatLanguage = prefs.getString('chatLanguage');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: selectLng == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        child: Row(
                          children: [
                            Text("$currenLng: "),
                            chatLanguage == null
                                ? Text(lang!)
                                : Text(chatLanguage)
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: kPrimaryColor,
                  ),
                  data == null
                      ? Center(
                          child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(),
                        ))
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data['Response']['Records'].length,
                          itemBuilder: (context, index) => Column(
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    Apis()
                                        .UpdateUserChatLanguage(data['Response']
                                                ['Records'][index]['LanguageId']
                                            .toString())
                                        .then((value) async {
                                      if (value == 'Bad Request') {
                                        showToast(
                                            'Error! while updating language');
                                      } else if (jsonDecode(
                                              value)['IsSuccess'] ==
                                          true) {
                                        showToast(
                                            'Language updated successfully');
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.setString(
                                            'chatLanguage',
                                            data['Response']['Records'][index]
                                                    ['LanguageName']
                                                .toString());
                                        prefs.setString(
                                            'chatLanguageCode',
                                            data['Response']['Records'][index]
                                                    ['CultureName']
                                                .toString());
                                        prefs.setString(
                                            'chatLanguageId',
                                            data['Response']['Records'][index]
                                                    ['LanguageId']
                                                .toString());
                                        chatLanguage =
                                            prefs.getString('chatLanguage');
                                        print("languages $chatLanguage");

                                        String? LanguageCode =
                                            prefs.getString('chatLanguageCode');
                                        print("languages $chatLanguage");
                                        print('Language code: $LanguageCode');
                                        setState(() {});
                                      } else {
                                        showToast(
                                            jsonDecode(value)['ErrorMessage']);
                                      }
                                    });

                                    print(
                                        "lang2 :${data['Response']['Records'][index]['LanguageId']}");

                                    // setState(() async {
                                    //   SharedPreferences prefs = await SharedPreferences.getInstance();
                                    //   prefs.setString('chatLanguage', data['Response']['Records'][index]['LanguageId'].toString());
                                    //
                                    //   chatLanguage = prefs.getString('chatLanguage');
                                    //   print("languages $chatLanguage");
                                    //
                                    // });
                                  },
                                  child: Text(
                                    data['Response']['Records'][index]
                                        ['LanguageName'],
                                    style: TextStyle(
                                        fontSize: 15, color: kPrimaryColor),
                                  ))
                              // InkWell(
                              //     onTap: () {
                              //       setState(() {
                              //       });
                              //     },
                              //     child: Container(
                              //         padding: EdgeInsets.symmetric(vertical: 15),
                              //         child: Text(data['Response']['Records'][index]['LanguageName'],style: TextStyle(fontSize: 14),))),
                              ,
                              const Divider(
                                color: kPrimaryColor,
                              ),
                            ],
                          ),
                        ),
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
      title: Text(
        selectLng == null ? "" : "$selectLng",
      ),
    );
  }
}
