// main.dart (excerpt)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen.dart';

final _neonColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF00FF9D),
  brightness: Brightness.dark,
);

final ThemeData dgfiTheme = ThemeData(
  useMaterial3: true,
  colorScheme: _neonColorScheme,
  scaffoldBackgroundColor: const Color(0xFF050816),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
      color: Colors.white,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: Color(0xFFB0B3C0),
    ),
  ),
  cardColor: const Color(0xFF0B1020),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF00FF9D),
      foregroundColor: const Color(0xFF050816),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      elevation: 10,
      shadowColor: const Color(0xFF00FF9D).withValues(0.6),
    ),
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disc Golf For Idiots',
      debugShowCheckedModeBanner: false,
      theme: dgfiTheme,
      home: const HomeScreen(),
    );
  }
}
