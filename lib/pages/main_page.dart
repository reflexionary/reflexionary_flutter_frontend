// main_page.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reflexionary_frontend/components/animated_gradient_box.dart';
import 'package:reflexionary_frontend/providers/auth_provider.dart';

// ... other imports
import 'appTheme/theme_provider.dart';
// import 'package/reflexionary_frontend/components/animated_gradient_box.dart';
import 'package:reflexionary_frontend/components/glass_morphic_box.dart';
import 'package:reflexionary_frontend/components/typewriter_question_banner.dart';
import 'package:reflexionary_frontend/pages/lighthouse/lighthouse_screen.dart';
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
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AnimatedHome()));
    if (kDebugMode) {
      print("Navigating to Lighthouse...");
    }
  }
  // ignore: non_constant_identifier_names
  void load_tethysScreen(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TethysScreen()));
    if (kDebugMode) {
      print("Navigating to Tethys...");
    }
  }
  // ignore: non_constant_identifier_names
  void load_kuberaScreen(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const KuberesScreen()));
    if (kDebugMode) {
      print("Navigating to Kubera...");
    }
  }
  Widget pageButton(VoidCallback onTap, String pageID) {
    // ... this method is unchanged
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
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.bold
            ),
        ),
      ),
    );
  }
  // NEW: A helper widget to build the login/logout controls
Widget _buildLoginControls(BuildContext context) {
  final authProvider = Provider.of<AuthProvider>(context);
  final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
  final currentUser = authProvider.currentUser;

  if (currentUser == null) {
    // 🧠 Detect web and render button directly
    if (kIsWeb) {
      return SizedBox(
        height: 40,
        child: HtmlElementView(
          viewType: 'google-signin-button',
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          authProvider.signIn();
        },
        child: Text('Login'),
      );
    }
  } else {
    return Row(
      children: [
        Text(
          'Hi, ${currentUser.displayName?.split(' ').first ?? 'User'}',
          style: TextStyle(
            fontFamily: 'Casanova',
            fontSize: 20,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Logout',
          onPressed: () => authProvider.signOut(),
        ),
      ],
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeIcon = themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode;

    return Scaffold(
      body: Stack(
        children: [
          const TypewriterQuestionBanner(),

          // App bar section
          Positioned(
            top: 10.0,
            right: 15.0,
            child: Row(
              children: <Widget>[
                // Use the new helper widget here
                _buildLoginControls(context),
                const SizedBox(width: 10.0),
                IconButton(
                  onPressed: _changeTheme,
                  icon: Icon(themeIcon),
                ),
              ],
            ),
          ),

          // Central content (unchanged)
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Reflexionary',
                    style: TextStyle(
                      fontFamily: 'Runalto',
                      fontSize: 60,
                      // shadows: [
                      //   Shadow(
                      //     color: themeProvider.isDarkMode ? Colors.white.withAlpha(128) : Colors.black.withAlpha(128),
                      //     offset: const Offset(2, 2),
                      //     blurRadius: 2,
                      //   ),
                      // ],
                    ),
                  ),
                  const SizedBox(height: 10),
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
            ),
          ),
        ],
      ),
    );
  }
}