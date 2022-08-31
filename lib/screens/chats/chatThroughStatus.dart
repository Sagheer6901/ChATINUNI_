// ignore_for_file: file_names

import 'dart:convert';
import 'package:chatinunii/authScreens/login.dart';
import 'package:chatinunii/components/bottomnavbar.dart';
import 'package:chatinunii/core/apis.dart';
import 'package:chatinunii/screens/chats/chats_screen.dart';
import 'package:chatinunii/screens/chats/components/statusmodel.dart';
import 'package:chatinunii/screens/profile.dart';
import 'package:chatinunii/screens/settings/settings.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:chatinunii/models/activeStatusUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:translator/translator.dart';
import '../../authScreens/signup.dart';
import '../../constants.dart';
import '../SiginInOrSignUp/signin_or_signup_screen.dart';
import '../splashscreen.dart';

class ChatByStatus extends StatefulWidget {
  bool flag;
  ChatByStatus({required this.flag});

  @override
  State<ChatByStatus> createState() => _ChatByStatusState();
}

var chats, people, profile, settings;

class _ChatByStatusState extends State<ChatByStatus> {
  final translator = GoogleTranslator();
  var select, snack1, shuffle, noUser;
  Locale? getlang;
  void didChangeDependencies() {
    Locale myLocale = Localizations.localeOf(context);
    setState(() {
      lang = myLocale.toLanguageTag();
    });
    print('my locale ${myLocale.toLanguageTag()}');
    super.didChangeDependencies();
  }

  String? language;
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
          .translate("No user found", from: 'en', to: '${l.split('_')[0]}')
          .then((value) {
        setState(() {
          noUser = value;
        });
      });
      translator
          .translate("Chats", from: 'en', to: '${l.split('_')[0]}')
          .then((value) {
        setState(() {
          chats = value;
        });
      });

      translator
          .translate("People", from: 'en', to: '${l.split('_')[0]}')
          .then((value) {
        setState(() {
          people = value;
        });
      });
      translator
          .translate("Profile", from: 'en', to: '${l.split('_')[0]}')
          .then((value) {
        setState(() {
          profile = value;
        });
      });
      translator
          .translate("Settings", from: 'en', to: '${l.split('_')[0]}')
          .then((value) {
        setState(() {
          settings = value;
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
          .translate("shuffle", from: 'en', to: '${l.split('_')[0]}')
          .then((value) {
        setState(() {
          shuffle = value;
        });
      });

      if (token == null) {
        Apis().getToken().then((value) {
          setState(() {
            token = value['Response']['Token'];
          });
        });
      }
      Apis().getStatus('${l.split('_')[0]}-${l.split('_')[1]}').then((value) {
        setState(() {
          status = value;
          language = '${l.split('_')[0]}-${l.split('_')[1]}';
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
          chatThroughStatus('null', '${l.split('_')[0]}-${l.split('_')[1]}')
              .then((value) => print(value[0].userName));
        }
      });
    });
  }

  var size, height, width;

  String? statusId;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          backgroundColor: kPrimaryColor,
          elevation: 0,
          title: Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Text(
              'ChatInUni',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          )),
      body: (statuses.isEmpty || shuffle == null)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                statusList(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Divider(),
                Container(
                  height: widget.flag == false
                      ? MediaQuery.of(context).size.height * 0.715
                      : MediaQuery.of(context).size.height * 0.635,
                  width: double.infinity,
                  child: GetX<DateController>(
                      init: DateController(),
                      builder: (_) {
                        return SearchWidget(_.booking().date, language!);
                      }),
                ),
              ],
            ),
      floatingActionButton: InkWell(
        onTap: () {
          setState(() {});
        },
        child: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shuffle,
                  size: 32,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: kPrimaryColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        onTap: (int index) => btn(index, context),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.messenger,
            ),
            label: chats == null ? "" : "$chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'active_users'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: chats == null ? "" : "$profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "settings".tr,
          ),
        ],
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
              Icons.search,
              color: kPrimaryColor,
            ),
            DropdownButton<String>(
                hint: _mySelection == null
                    ? Text('search_by_status'.tr,
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
                      _mySelection = val;
                      print(_mySelection);
                    },
                  );
                  for (var i = 0; i < range; i++) {
                    if (status!.response.statuses[i].statusName ==
                        _mySelection) {
                      setState(() {
                        statusId = status!.response.statuses[i].statusId;
                        print(statusId);

                        Get.find<DateController>().updateBooking(statusId!);
                      });
                      break;
                    }
                  }
                  print(statusId);
                }),
          ],
        ),
      ),
    );
  }

  Future<List<Record>> chatThroughStatus(String statusId, String lang) async {
    String finalurl =
        'https://test-api.chatinuni.com/User/GetActiveUserList/$statusId';
    var result = await http
        .get(Uri.parse(finalurl), headers: {'lang': lang, 'Token': token!});
    var msg = await json.decode(result.body);
    if (result.statusCode == 200) {
      final parsed = json
          .decode(result.body)['Response']['Records']
          .cast<Map<String, dynamic>>();
      return parsed.map<Record>((json) => Record.fromJson(json)).toList();
    }

    return msg;
  }

  Widget SearchWidget(String statusId, String lang) {
    return FutureBuilder<List<Record>>(
        future: chatThroughStatus(statusId, lang),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: Text('$noUser'),
            );
          } else if (snapshot.hasData) {
            print('profile photo: ${snapshot.data![0].profilePhotos}');
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  String img = snapshot.data![index].profilePhotos == null
                      ? 'https://chatinuni.com/assets/image/profile-place-holder.jpg'
                      : snapshot.data![index].profilePhotos.split(",")[1];
                  String imgUrl = snapshot.data![index].profilePhotos == null
                      ? 'https://chatinuni.com/assets/image/profile-place-holder.jpg'
                      : img.split('"')[3];
                  imgUrl = snapshot.data![index].profilePhotos == null
                      ? 'https://chatinuni.com/assets/image/profile-place-holder.jpg'
                      : imgUrl.replaceAll('\\', '');
                  print(imgUrl);
                  return InkWell(
                    onTap: () {
                      print(snapshot.data![index].userName);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              Profile(username: snapshot.data![index].userName
                                  // flag: false,
                                  )));
                    },
                    child: ListTile(
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.grey.shade200,
                            child: CircleAvatar(
                              radius: 70,
                              backgroundImage:
                                  // AssetImage('assets/images/welcome_image.png'),
                                  NetworkImage(imgUrl),
                            ),
                          ),
                          Positioned(
                            bottom: 1,
                            right: 1,
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: SvgPicture.network(
                                  snapshot.data![index].statusIcon,
                                  height: 15,
                                  width: 15,
                                ),
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      50,
                                    ),
                                  ),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(2, 4),
                                      color: Colors.black.withOpacity(
                                        0.3,
                                      ),
                                      blurRadius: 3,
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                      // CircleAvatar(
                      //   backgroundColor: Colors.white,
                      //   child: SvgPicture.network(
                      //     snapshot.data![index].statusIcon,
                      //     height: 30,
                      //     width: 30,
                      //     // color: Colors.amber,
                      //   ),
                      // ),
                      title: Text(snapshot.data![index].userName),
                      subtitle: Text(snapshot.data![index].statusText),
                      trailing: Icon(Icons.mail),
                    ),
                  );
                });
          } else {
            return SizedBox();
          }
        });
  }
}

btn(i, context) {
  if (i == 0) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ChatsScreen()));
  } else if (i == 1) {
  } else if (i == 2) {
    if (loginFlag == true) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Profile()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  } else {
    if (loginFlag == true) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Settings()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Login()));
    }
  }
}
