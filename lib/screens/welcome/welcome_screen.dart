import 'package:chatinunii/screens/chats/chatThroughStatus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

import '../../constants.dart';
import '../SiginInOrSignUp/signin_or_signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

var prefs;
setPrefrences() async {
  prefs = await SharedPreferences.getInstance();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final translator = GoogleTranslator();
  var t1, t2, t3;

  var l = Get.deviceLocale.toString();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setPrefrences().then((_) {
      setState(() {});
      prefs.setString("welcome", "done");
    });

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
    // var l = Get.deviceLocale.toString();
    print("lang: ${l.toString()}");
    translator
        .translate("Welcome to ChatInUni \nmessaging app",
            from: 'en', to: '${l.split('_')[0]}')
        .then((value) {
      setState(() {
        t1 = value;
      });
    });
    translator
        .translate("Freedom talk any person of your \nmother language",
            from: 'en', to: '${l.split('_')[0]}')
        .then((value) {
      setState(() {
        t2 = value;
      });
    });
    translator
        .translate("Skip", from: 'en', to: '${l.split('_')[0]}')
        .then((value) {
      setState(() {
        t3 = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return t1 == null
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  const Spacer(
                    flex: 2,
                  ),
                  Image.asset("assets/images/welcome_image.png"),
                  const Spacer(
                    flex: 3,
                  ),
                  Text(
                    "$t1",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  Text(
                    "$t2",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.color
                          ?.withOpacity(0.64),
                    ),
                  ),
                  const Spacer(
                    flex: 3,
                  ),
                  FittedBox(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatByStatus(
                              flag: false,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            "$t3",
                            style:
                                Theme.of(context).textTheme.bodyText1?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.color
                                          ?.withOpacity(0.8),
                                    ),
                          ),
                          const SizedBox(
                            width: kDefaultPadding / 4,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.color
                                ?.withOpacity(0.8),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
