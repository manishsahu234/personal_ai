import 'package:flutter/material.dart';

import 'features/chat/presentation/pages/chat_page.dart';

class PersonalAiApp extends StatelessWidget {
  const PersonalAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF7665D8);

    return MaterialApp(
      title: 'Personal AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F8FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8F8FC),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xFFE7E6EF)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xFFE7E6EF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: seed, width: 1.5),
          ),
        ),
      ),
      home: const ChatPage(),
    );
  }
}
