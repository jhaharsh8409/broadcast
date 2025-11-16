import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const BroadcastApp());
}

class BroadcastApp extends StatelessWidget {
  const BroadcastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Broadcast',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.black,
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme,
        ),
        // Apply font to all text styles
        typography: Typography.material2021(
          platform: TargetPlatform.android,
          black: GoogleFonts.interTextTheme(Typography.blackMountainView),
          white: GoogleFonts.interTextTheme(Typography.whiteMountainView),
          englishLike: GoogleFonts.interTextTheme(Typography.englishLike2021),
          dense: GoogleFonts.interTextTheme(Typography.dense2018),
          tall: GoogleFonts.interTextTheme(Typography.tall2014),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}


