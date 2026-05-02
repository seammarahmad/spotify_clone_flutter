import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/song_model.dart';

part 'home_local_repository.g.dart';

@riverpod
HomeLocalRepository homeLocalRepository(Ref ref) {
  return HomeLocalRepository();
}

class HomeLocalRepository {
  final Box<SongModel> box = Hive.box<SongModel>('songs');

  Future<void> uploadLocalSong(SongModel song) async {
    await box.put(song.id, song.toJson());
  }

  List<SongModel> loadSongs() {
    List<SongModel> songs = [];
    for (final key in box.keys) {
      songs.add(SongModel.fromJson(box.get(key) as String));
    }
    return songs;
  }
  Future<void> deleteSong(String id) async {
    await box.delete(id);
  }

  SongModel? getSong(String id) {
    return box.get(id);
  }

  Future<void> clearAll() async {
    await box.clear();
  }
}