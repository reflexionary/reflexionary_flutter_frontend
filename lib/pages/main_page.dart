import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:reflexionary_frontend/providers/auth_provider.dart' as my_auth;

import 'appTheme/theme_provider.dart';
import 'package:reflexionary_frontend/components/animated_gradient_box.dart';
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

  void load_lighthouseScreen() =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => AnimatedHome()));
  void load_tethysScreen() =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TethysScreen()));
  void load_kuberaScreen() =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const KuberesScreen()));

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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        child: Text(
          pageID,
          style: const TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ---- Local login/logout controls using AuthProvider ----
  Widget _buildLoginControls(BuildContext context) {
    final authProvider = Provider.of<my_auth.AuthProvider>(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    void showLoginDialog() {
      final emailController = TextEditingController();
      final passwordController = TextEditingController();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: isDark ? Colors.black : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text(
              'Login',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              height: 150,
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email (dummy)'),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password (dummy)'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await authProvider.login(); // Simulate login, ignores actual input
                      // Optionally: Show a SnackBar for demo
                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Logged in!")));
                      Navigator.pop(context);
                    },
                    child: authProvider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Login'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    if (!authProvider.loggedIn) {
      return ElevatedButton(
        onPressed: authProvider.isLoading ? null : showLoginDialog,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? Colors.white12 : Colors.blueGrey.shade100,
        ),
        child: authProvider.isLoading
            ? const SizedBox(
                width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : const Text("Login"),
      );
    } else {
      final displayName = "User"; // Dummy, since there's no email/name
      return Row(
        children: [
          Text(
            'Welcome, $displayName',
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
            onPressed: () => authProvider.logout(),
          ),
        ],
      );
    }
  }

  Widget buildGlassMorphicLottieBackground() {
    final animation = Lottie.asset(
          'lib/assets/animations/Bubbles.json',
          fit: BoxFit.cover,
          repeat: true,
          width: double.infinity
        );
  return Positioned.fill(
    child: Stack(
      children: [
        // Lottie background animation
        animation,

        // Glassmorphic blur mask over the animation
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            color: Colors.white.withOpacity(0.1), // gives a frosty glass look
          ),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeIcon = themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode;

    return Scaffold(
      body: Stack(
        children: [
          // unique bg anim
          buildGlassMorphicLottieBackground(),


          const TypewriterQuestionBanner(),
          // App bar area
          Positioned(
            top: 10.0,
            right: 15.0,
            child: Row(
              children: <Widget>[
                _buildLoginControls(context),
                const SizedBox(width: 10.0),
                IconButton(
                  onPressed: _changeTheme,
                  icon: Icon(themeIcon),
                ),
              ],
            ),
          ),
          // Main content
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Reflexionary',
                    style: TextStyle(
                      fontFamily: 'Runalto',
                      fontSize: 72,
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
