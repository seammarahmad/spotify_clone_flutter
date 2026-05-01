import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:spotify_clone_flutter/core/provider/current_user_notifier.dart';
import 'package:spotify_clone_flutter/core/theme/app_pallete.dart';
import 'package:spotify_clone_flutter/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:spotify_clone_flutter/features/auth/view/pages/signup_page.dart';
import 'package:spotify_clone_flutter/features/home/view/pages/home_page.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(seconds: 4));

    final authNotifier = ref.read(authViewModelProvider.notifier);
    if (!mounted) return;

    await authNotifier.initSharedPreferences();
    await authNotifier.getData();

    final currentUser = ref.read(currentUserProvider);

    if (currentUser == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignupPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/splash.json',
                width: 220,
                height: 220,
                repeat: true,
              ),

              const SizedBox(height: 40),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Loading Please Wait ",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Pallete.gradient3,
                    ),
                  ),
                  TypewriterAnimatedTextKit(
                    speed: Duration(seconds: 1),
                    text: ['...'],
                    textStyle: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Pallete.gradient3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
