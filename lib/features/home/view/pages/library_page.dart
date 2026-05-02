import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_clone_flutter/core/provider/current_song_notifier.dart';
import 'package:spotify_clone_flutter/core/provider/current_user_notifier.dart';
import 'package:spotify_clone_flutter/features/home/view/pages/upload_song_page.dart';
import 'package:spotify_clone_flutter/features/home/viewmodel/home_viewmodel.dart';

import '../../../../core/theme/app_pallete.dart';
import '../../../../core/utils/loader.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Real-time favorites from local state — updates instantly on button tap
    final userFavorites = ref.watch(
      currentUserProvider.select((data) => data!.favorites),
    );

    return ref
        .watch(getAllFavSongsProvider)
        .when(
          // ✅ Don't flash a full Loader when refreshing after fav toggle
          skipLoadingOnRefresh: true,
          data: (songs) {
            // ✅ Pull-to-refresh
            return RefreshIndicator(
              color: Pallete.whiteColor,
              backgroundColor: Pallete.backgroundColor,
              onRefresh: () async {
                ref.invalidate(getAllFavSongsProvider);
                // Wait for the provider to finish refreshing
                await ref.read(getAllFavSongsProvider.future);
              },
              child: ListView.builder(
                // ✅ physics must allow scroll even with few items for pull-to-refresh
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: songs.length + 1,
                itemBuilder: (context, index) {
                  // Last item → Upload button
                  if (index == songs.length) {
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const UploadSongPage(),
                          ),
                        );
                      },
                      leading: const CircleAvatar(
                        radius: 35,
                        backgroundColor: Pallete.backgroundColor,
                        child: Icon(CupertinoIcons.plus),
                      ),
                      title: const Text(
                        'Upload New Song',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  }

                  final song = songs[index];

                  // ✅ Read from local state (instant) not from async provider
                  final isFav = userFavorites.any(
                    (fav) => fav.song_id == song.id,
                  );

                  return ListTile(
                    onTap: () {
                      ref.read(currentSongProvider.notifier).updateSong(song);
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(song.thumbnail_url),
                      radius: 35,
                      backgroundColor: Pallete.backgroundColor,
                    ),
                    title: Text(
                      song.song_name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      song.artist,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // ✅ Heart button with real-time state
                    trailing: IconButton(
                      onPressed: () {
                        ref
                            .read(homeViewmodelProvider.notifier)
                            .favSong(songId: song.id);
                      },
                      icon: Icon(
                        isFav
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart,
                        color: isFav ? Colors.red : Pallete.whiteColor,
                      ),
                    ),
                  );
                },
              ),
            );
          },
          error: (error, st) => Center(
            child: Text(
              error.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          loading: () => const Loader(),
        );
  }
}
