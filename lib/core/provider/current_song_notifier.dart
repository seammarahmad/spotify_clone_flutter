import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotify_clone_flutter/features/home/model/song_model.dart';

part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  AudioPlayer? audioPlayer;
  bool isPlaying = false;

  @override
  SongModel? build() {
    return null;
  }

  void updateSong(SongModel song) async {
    await audioPlayer?.dispose();
    await audioPlayer?.stop();

    audioPlayer = AudioPlayer();

    final audioSource = AudioSource.uri(Uri.parse(song.song_url));

    await audioPlayer!.setAudioSource(audioSource);

    audioPlayer!.playerStateStream.listen((stated) {
      if (stated.processingState == ProcessingState.completed) {
        audioPlayer!.seek(Duration.zero);
        isPlaying = false;
        audioPlayer!.pause();

        state = state?.copyWith(hex_code: state?.hex_code);
      }
    });

    audioPlayer!.play();
    isPlaying = true;
    state = null;
    state = song;
  }

  void playPause() {
    if (isPlaying) {
      audioPlayer?.pause();
    } else {
      audioPlayer?.play();
    }

    isPlaying = !isPlaying;

    state = state?.copyWith(hex_code: state?.hex_code);
  }

  void seek(double val) {
    audioPlayer!.seek(
      Duration(
        milliseconds: (val * audioPlayer!.duration!.inMilliseconds).toInt(),
      ),
    );
  }
}
