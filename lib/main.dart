import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/wardrobe_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final provider = WardrobeProvider();
  await provider.init();
  
  runApp(WardrobeApp(provider: provider));
}

class WardrobeApp extends StatelessWidget {
  final WardrobeProvider provider;
  
  const WardrobeApp({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: MaterialApp(
        title: '衣橱管家',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF6B6B),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
