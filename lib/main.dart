import 'package:flutter/material.dart';
import 'package:noteskeeper/screens/splash_screen.dart';
import 'package:noteskeeper/providers/note_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    // Wrap app with ChangeNotifierProvider
    ChangeNotifierProvider(
      create: (context) => NoteProvider(), // Provide an instance of NoteProvider
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes Keeper',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black54),
          headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.amber.shade700,
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.amber,
        ).copyWith(
          secondary: Colors.amber.shade400,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}