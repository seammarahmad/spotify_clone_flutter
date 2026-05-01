import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:spotify_clone_flutter/core/provider/current_song_notifier.dart';
import 'package:spotify_clone_flutter/core/theme/app_pallete.dart';
import 'package:spotify_clone_flutter/core/utils/utils.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    final songNotifier = ref.read(currentSongProvider.notifier);
    if (currentSong == null) {
      return const SizedBox();
    }
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          height: 66,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: hextoColor(currentSong.hex_code),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      currentSong.thumbnail_url,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, _) => Container(
                        width: 48,
                        height: 48,
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.music_note,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentSong.song_name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                      ),
                      Text(
                        currentSong.artist,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Pallete.subtitleText,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.add_circle_outline),
                  ),

                  IconButton(
                    onPressed: () {
                      songNotifier.playPause();
                    },
                    icon: Icon(
                      songNotifier.isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        StreamBuilder(
          stream: songNotifier.audioPlayer?.positionStream,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox();
            }
            final position = snapshot.data;
            final duration = songNotifier.audioPlayer?.duration;
            double sliderValue = 0.0;
            if (position != null && duration != null) {
              sliderValue = position / duration;
            }

            return Positioned(
              bottom: 0,
              left: 10,
              child: Container(
                height: 3,
                width: sliderValue * MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Pallete.whiteColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            );
          },
        ),
        Positioned(
          bottom: 0,
          left: 10,
          child: Container(
            height: 3,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Pallete.inactiveSeekColor,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ],
    );
  }
}
