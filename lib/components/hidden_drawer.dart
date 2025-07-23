
import 'package:reflexionary_frontend/pages/appTheme/theme_class.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import '../models/shared_preferences/shared_preference_model.dart';
import '../pages/login_page.dart';

// importing classes
import 'package:reflexionary_frontend/pages/lighthouse/insights_screen.dart';
import 'package:reflexionary_frontend/pages/lighthouse/journals_screen.dart';
import 'package:reflexionary_frontend/pages/lighthouse/patterns_screen.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  @override
  HiddenDrawerState createState() => HiddenDrawerState();
}

class HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> pageList = [];

  final Color primaryColor = ThemeClass().primaryAccent;
  final Color secondaryColor = ThemeClass().secondaryAccent;

  // base style of drawer items
  final baseStyle = TextStyle(
      color: ThemeClass().secondaryAccent, fontWeight: FontWeight.normal);

  // style of selected item in drawer menu
  final selectedStyle = TextStyle(
      color: ThemeClass().primaryAccent,
      fontWeight: FontWeight.bold,
      fontSize: 22);

  @override
  void initState() {
    super.initState();

    // Initialize the screens which will be shown in the custom drawer
    pageList = [
      // journal screen
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: 'Centre of Excellence E-mobility',
              baseStyle: baseStyle,
              selectedStyle: selectedStyle),
          const JournalsScreen()),

      // insights screen
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: 'About',
              baseStyle: baseStyle,
              selectedStyle: selectedStyle),
          const InsightsScreen()),

      // patterns screen
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: 'our Achievements',
              baseStyle: baseStyle,
              selectedStyle: selectedStyle),
          const PatternsScreen()
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyle(
        color: primaryColor,
        fontSize: MediaQuery.sizeOf(context).width * 0.045,
        fontFamily: 'Lora_italic',
        fontWeight: FontWeight.w400);

    return HiddenDrawerMenu(
      styleAutoTittleName: titleStyle,
      backgroundColorAppBar: Colors.white,
      elevationAppBar: 0,
      isTitleCentered: true,
      screens: pageList,
      backgroundColorMenu: Colors.white,
      initPositionSelected: 0,
      slidePercent: 65,
      actionsAppBar: [
        IconButton(
            onPressed: () {
              // Handle user logout here

              // Set userLogin sharedPref to false (user logged out)
              SharedPreferenceModel().setUserLoginStatus(false);

              // Take user to login page
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage()));
            },
            icon: const Icon(
              Icons.logout_sharp,
            ))
      ],
    );
  }
}
