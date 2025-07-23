import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
  bool _isDarkMode = false;

  void _changeTheme() {
    // Use setState to rebuild the widget and reflect the UI changes.
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
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
    // Get the current theme from the context.
    // This is better than ThemeData() as it respects the app's current theme.
    final theme = Theme.of(context);

    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        // Use the primary color for the border.
        side: BorderSide(color: theme.primaryColor, width: 1.5),
        // Use a semi-transparent version of the primary color for the background.
        backgroundColor: theme.primaryColor.withOpacity(0.1),
        // Set the color for the text/icon when the button is enabled.
        foregroundColor: theme.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      child: Text(pageID, style: const TextStyle(fontWeight: FontWeight.bold)),
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
    final themeIcon = _isDarkMode ? Icons.dark_mode : Icons.light_mode;

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
                  Text('Reflexionary'),

                  // spacer for better visuals
                  SizedBox(height: 10,),

                  // buttons for the three Gurus
                  Container(
                    decoration: BoxDecoration(
                      color: ThemeData().primaryColor.withOpacity(0.3),
                      border: Border.all(color: ThemeData().primaryColor, width: 1.5),
                      borderRadius: BorderRadius.circular(20),
                      
                    ),
                    padding: EdgeInsets.all(20),
                    child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [ 
                      pageButton(load_lighthouseScreen, 'Lighthouse'),
                      
                      SizedBox(width: 10,),

                      pageButton(load_tethysScreen, 'Tethys'),

                      SizedBox(width: 10,),

                      pageButton(load_kuberaScreen, 'Kubera'),
                    ],
                  ),)
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