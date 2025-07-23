import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reflexionary_frontend/components/animated_gradient_box.dart';
import 'package:reflexionary_frontend/components/glass_morphic_box.dart';
import 'appTheme/theme_provider.dart';
import 'package:provider/provider.dart';

// importing pages
import 'package:reflexionary_frontend/models/shared_preferences/shared_preference_model.dart';
import 'package:reflexionary_frontend/pages/lighthouse/animated_home.dart';
import 'package:reflexionary_frontend/pages/login_page.dart';
import 'package:reflexionary_frontend/pages/kubera_pages/kuberes_page.dart';
import 'package:reflexionary_frontend/pages/tethys_pages/tethys_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  void _changeTheme() {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  themeProvider.toggleTheme();
  }


  // ignore: non_constant_identifier_names
  void load_lighthouseScreen(){
    // Navigate to LighthouseScreen.
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AnimatedHome()));
    if (kDebugMode) {
      print("Navigating to Lighthouse...");
    }
  }
  // ignore: non_constant_identifier_names
  void load_tethysScreen(){
    // Navigate to TethysScreen.
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TethysScreen()));
    if (kDebugMode) {
      print("Navigating to Tethys...");
    }
  }
  // ignore: non_constant_identifier_names
  void load_kuberaScreen(){
    // Navigate to KuberaScreen.
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const KuberesScreen()));
    if (kDebugMode) {
      print("Navigating to Kubera...");
    }
  }

Widget pageButton(VoidCallback onTap, String pageID) {
  final colorScheme = Theme.of(context).colorScheme;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return GlassMorphicBox(
    child: OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: colorScheme.primary, width: 1.5),
        backgroundColor: colorScheme.primary.withAlpha(25),
        foregroundColor: isDark ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      child: Text(
        pageID,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold),
      ),
    ),
  );
}


  Widget loginDetail(){
    return IconButton(
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
            ));
  }


  @override
  Widget build(BuildContext context) {
    // The icon can now change based on the current theme state.
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final themeIcon = isDark ? Icons.dark_mode : Icons.light_mode;


    return Scaffold(
      body: Stack(
        children: [
          // App bar
          Positioned(
            top: 10.0,
            right: 15.0,
            child: Row(
              children: <Widget>[
                // Login button / account details
                TextButton(onPressed: (){
                  // Set userLogin sharedPref to false (user logged out)
                  SharedPreferenceModel().setUserLoginStatus(false);

                  // Take user to login page
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()));
                    }, child: Text('Login')),

                    // spacer for better visuals
                    const SizedBox(width: 10.0),

                    // light/dark mode button
                    IconButton(
                      onPressed: _changeTheme,
                      icon: Icon(themeIcon),
                    )
                  ],
                ),
              ),

          // central content
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // reflexionary logo
                  // Image(asset_id),

                  // reflexionary label
                  Text(
                    'Reflexionary', 
                    style: TextStyle(
                      fontFamily: 'Runalto', 
                      fontSize: 60,
                      shadows: [
                        Shadow(
                          color: isDark? Colors.white.withAlpha((0.5 * 255).round()) : Colors.black.withAlpha((0.5 * 255).round()),
                          offset: const Offset(2, 2),
                          blurRadius: 2,
                        ),
                      ],
                      ),
                    ),

                  // spacer for better visuals
                  SizedBox(height: 10,),

                  // buttons for the three Gurus
                  AnimatedGradientBox(
                    borderRadius: 24,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          pageButton(load_lighthouseScreen, 'Lighthouse'),
                          const SizedBox(width: 10),
                          pageButton(load_tethysScreen, 'Tethys'),
                          const SizedBox(width: 10),
                          pageButton(load_kuberaScreen, 'Qubera'),
                          ],
                          ),
                          ),
                          )

                ],
              ),
            )
          ),

          // lighthouse, tethys, kubera buttons
          // documentation and behind.the.scenes buttons
        ],
      ),
    );
  }
}