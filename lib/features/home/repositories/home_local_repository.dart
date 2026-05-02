import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/song_model.dart';

part 'home_local_repository.g.dart';

@riverpod
HomeLocalRepository homeLocalRepository(Ref ref) {
  return HomeLocalRepository();
}

class HomeLocalRepository {
  final Box<String> box = Hive.box<String>('songs');


  Future<void> uploadLocalSong(SongModel song) async {
    await box.put(song.id, song.toJson());
  }


  List<SongModel> loadSongs() {
    List<SongModel> songs = [];
    for (final key in box.keys) {
      final json = box.get(key);
      if (json != null) {
        songs.add(SongModel.fromJson(json));
      }
    }
    return songs;
  }
  bool songExists(String id) {
    return box.containsKey(id);
  }


  SongModel? getSong(String id) {
    final json = box.get(id);
    if (json == null) return null;
    return SongModel.fromJson(json);
  }

  Future<void> updateSong(SongModel song) async {
    if (box.containsKey(song.id)) {
      await box.put(song.id, song.toJson());
    }
  }


  Future<void> deleteSong(String id) async {
    await box.delete(id);
  }


  Future<void> clearAll() async {
    await box.clear();
  }

  int get songCount => box.length;
}