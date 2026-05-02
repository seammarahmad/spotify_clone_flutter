import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_clone_flutter/core/theme/app_pallete.dart';
import 'package:spotify_clone_flutter/features/home/view/pages/library_page.dart';
import 'package:spotify_clone_flutter/features/home/view/pages/song_page.dart';

import '../widgets/music_slab.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  int selectedindex = 0;
  final pages=[SongesPage(),LibraryPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          pages[selectedindex],
          Positioned(bottom: 0,child: MusicSlab(),),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedindex,
        onTap: (value) {
          setState(() {
            selectedindex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              selectedindex == 0
                  ? 'assets/images/home_filled.png'
                  : 'assets/images/home_unfilled.png',
              color: selectedindex == 0
                  ? Colors.white
                  : Pallete.greyColor,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/library.png',
              color: selectedindex == 1
                  ? Colors.white
                  : Pallete.greyColor,
            ),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
