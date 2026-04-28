import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_clone_flutter/core/provider/current_user_notifier.dart';
import 'package:spotify_clone_flutter/core/theme/theme.dart';
import 'package:spotify_clone_flutter/features/auth/view/pages/signup_page.dart';
import 'package:spotify_clone_flutter/features/auth/viewmodel/auth_viewmodel.dart';

import 'features/home/view/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  final notifier = container.read(authViewModelProvider.notifier);
  await notifier.initSharedPreferences();
  await notifier.getData();
  runApp(UncontrolledProviderScope(container: container, child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    return MaterialApp(
      title: 'Music Player App',
      theme: AppTheme.darkThemeMode,
      home: currentUser == null ? SignupPage() : HomePage(),
    );
  }
}
