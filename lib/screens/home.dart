import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_seoul/controllers/count_controller.dart';
import 'package:flutter_seoul/screens/edit_profile.dart';
import 'package:flutter_seoul/utils/colors.dart';
import 'package:flutter_seoul/utils/localization.dart';
import 'package:flutter_seoul/widgets/edit_text.dart';
import 'package:flutter_seoul/widgets/seoul_button.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginValue {
  String name;
  TextInputType? keyboardType;
  String? hintText;
  bool obscureText;
  bool enableSuggestions;
  bool autocorrect;

  LoginValue(
      {required this.name,
      this.keyboardType,
      this.hintText,
      this.obscureText = false,
      this.enableSuggestions = true,
      this.autocorrect = true});
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = Get.put(CountController());
  late String _emailValue = "";
  late String _passwordValue = "";
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final List<LoginValue> loginValues = [
    LoginValue(
        name: "Email",
        hintText: "Email",
        keyboardType: TextInputType.emailAddress),
    LoginValue(
      name: "Password",
      hintText: "Password",
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
    ),
  ];

  _getThemeStatus() async {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    if (isDarkMode) {
      () => Get.changeThemeMode(ThemeMode.dark);
      SharedPreferences pref = await _prefs;
      pref.setBool('theme', true);
      return;
    }

    var isLight = _prefs.then((SharedPreferences prefs) {
      if (prefs.getBool('theme') == null) {
        return false;
      }
      return prefs.getBool('theme');
    }).obs;
    bool copyValue = (await isLight.value)!;
    Get.changeThemeMode(copyValue ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  void initState() {
    super.initState();
    _getThemeStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(32, 60, 32, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.fromLTRB(0, 64, 0, 8),
                      child: Text(
                        t("FLUTTER_SEOUL"),
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 64),
                      child: const Text(
                        "Flutter BoilerPlate",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Column(
                        children: loginValues.map((LoginValue item) {
                      return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: EditText(
                            onChanged: (String txt) => setState(() {
                              if (item.name == "Email") {
                                _emailValue = txt;
                              } else {
                                _passwordValue = txt;
                              }
                            }),
                            keyboardType: item.keyboardType,
                            hintText: item.hintText,
                            obscureText: item.obscureText,
                            enableSuggestions: item.enableSuggestions,
                            autocorrect: item.autocorrect,
                          ));
                    }).toList()),
                    SeoulButton(
                      onPressed: () {
                        Get.to(
                          () => const EditProfile(),
                          arguments: "${controller.count.value}",
                        );
                      },
                      disabled: _emailValue == "" || _passwordValue == "",
                      style: SeoulButtonStyle(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                        backgroundColor: Theme.of(context)
                            .buttonTheme
                            .colorScheme!
                            .background,
                      ),
                      child: Text(
                        "로그인 하기",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.background,
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 56, bottom: 48),
                child: Column(
                  children: [
                    const Text("이용문의",
                        style: TextStyle(fontSize: 12, color: grey)),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: const Text(
                        "support@dooboolab.com",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
