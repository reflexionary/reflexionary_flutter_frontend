// // lib/major_screen.dart


// import 'package:reflexionary_frontend/pages/home.dart';
// import 'package:flutter/material.dart';
// import 'package:reflexionary_frontend/pages/appTheme/theme_class.dart';

// class MajorScreen extends StatefulWidget {
//   const MajorScreen({super.key});

//   @override
//   MajorScreenScreen createState() => MajorScreenScreen();
// }

// class MajorScreenScreen extends State<MajorScreen> {
//   int selectedPage = 0; // Default selected page

//   @override
//   Widget build(BuildContext context) {
//     Color primaryColor = ThemeClass().primaryAccent;
//     Color secondaryColor = ThemeClass().secondaryAccent;
//     PageController pageController = PageController();

//     return Stack(
//       alignment: Alignment.bottomCenter,
//       children: [
//         // Image decoration for wallpaper
//         SizedBox(
//           height: MediaQuery.sizeOf(context).height,
//           width: MediaQuery.sizeOf(context).width,
//           child: Image.asset(
//             'lib/images/wallpapers/home_page/centre_of_excellence.jpg',
//             fit: BoxFit.cover,
//           ),
//         ),

//         // main page screens
//         PageView(
//           onPageChanged: (index) {
//             setState(() {
//               selectedPage = index;
//             });
//           },
//           controller: pageController,
//           children: const [
//             Home(),
//             Teams(),
//             EquipmentsPage(),
//             Projects(),
//           ],
//         ),

//         // floating nav bar
//         SafeArea(
//           child: Container(
//             margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//             decoration: BoxDecoration(
//               color: secondaryColor,
//               borderRadius: BorderRadius.circular(30),
//               boxShadow: [
//                 BoxShadow(
//                   color: secondaryColor,
//                   spreadRadius: 1,
//                   blurRadius: 9,
//                   offset: const Offset(1, 2),
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 15),
//               child: GNav(
//                 duration: const Duration(milliseconds: 800),
//                 selectedIndex: selectedPage,
//                 color: primaryColor,
//                 activeColor: Colors.white,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//                 onTabChange: (index) {
//                   setState(() {
//                     if ((selectedPage - index).abs() == 1) {
//                       selectedPage = index;
//                       pageController.animateToPage(
//                         index,
//                         duration: const Duration(milliseconds: 350),
//                         curve: Curves.easeIn,
//                       );
//                     } else {
//                       pageController.jumpToPage(index);
//                     }
//                   });
//                 },
//                 tabs: const [
//                   GButton(
//                     icon: Icons.home,
//                     text: 'Home',
//                   ),
//                   GButton(
//                     icon: Icons.people_alt_outlined,
//                     text: 'Teams',
//                   ),
//                   GButton(
//                     icon: Icons.build_rounded,
//                     text: 'Equipments',
//                   ),
//                   GButton(
//                     icon: Icons.collections_bookmark_outlined,
//                     text: 'Projects',
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
