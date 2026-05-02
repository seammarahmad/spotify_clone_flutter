import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_clone_flutter/core/provider/current_song_notifier.dart';
import 'package:spotify_clone_flutter/core/theme/app_pallete.dart';
import 'package:spotify_clone_flutter/core/utils/loader.dart';
import 'package:spotify_clone_flutter/features/home/model/song_model.dart';
import 'package:spotify_clone_flutter/features/home/viewmodel/home_viewmodel.dart';

class SongesPage extends ConsumerWidget {
  const SongesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlyPlayedSong = ref
        .watch(homeViewmodelProvider.notifier)
        .getrecentlyPlayedSong();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: recentlyPlayedSong.length,
            itemBuilder: (context, index) {
              final song = recentlyPlayedSong[index];
              return GestureDetector(
                onTap: () {
                  ref.read(currentSongProvider.notifier).updateSong(song);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Pallete.borderColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(song.thumbnail_url),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          song.song_name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              'Latest Today',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 32,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: ref
                .watch(getAllSongsProvider)
                .when(
                  data: (songs) => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      return _SongCard(song: song);
                    },
                  ),
                  error: (error, _) => Center(
                    child: Text(
                      error.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  loading: () => const Loader(),
                ),
          ),
        ],
      ),
    );
  }
}

class _SongCard extends ConsumerWidget {
  final SongModel song; // ✅ Fix 2: typed properly

  const _SongCard({required this.song});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(currentSongProvider.notifier).updateSong(song);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                song.thumbnail_url,
                width: 180,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, _) => Container(
                  width: 180,
                  height: 180,
                  color: Colors.grey[800],
                  child: const Icon(Icons.music_note, color: Colors.white54),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 180,
              child: Text(
                song.song_name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 180,
              child: Text(
                song.artist,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Pallete.subtitleText,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
