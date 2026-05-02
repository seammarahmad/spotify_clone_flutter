import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotify_clone_flutter/core/theme/theme.dart';
import 'package:spotify_clone_flutter/features/auth/view/pages/splash_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  final dir = await getApplicationDocumentsDirectory();
  Hive.defaultDirectory = dir.path;
  runApp(UncontrolledProviderScope(container: container, child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Music Player App',
      theme: AppTheme.darkThemeMode,
      home: SplashScreen(),
    );
  }
}
