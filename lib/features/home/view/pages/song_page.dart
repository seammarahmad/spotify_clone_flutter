import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_clone_flutter/core/theme/app_pallete.dart';
import 'package:spotify_clone_flutter/core/utils/loader.dart';
import 'package:spotify_clone_flutter/features/home/viewmodel/home_viewmodel.dart';

import '../../../../core/provider/current_song_notifier.dart';

class SongesPage extends ConsumerWidget {
  const SongesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: const Text(
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
            child: ref.watch(getAllSongsProvider).when(
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
  final dynamic song;

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
                style: TextStyle(
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