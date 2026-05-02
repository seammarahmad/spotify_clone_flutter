import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotify_clone_flutter/core/provider/current_user_notifier.dart';
import 'package:spotify_clone_flutter/core/utils/utils.dart';
import 'package:spotify_clone_flutter/features/home/model/fav_song_model.dart';
import 'package:spotify_clone_flutter/features/home/model/song_model.dart';
import 'package:spotify_clone_flutter/features/home/repositories/home_local_repository.dart';
import 'package:spotify_clone_flutter/features/home/repositories/home_repository.dart';

part 'home_viewmodel.g.dart';

// ─── Get All Songs Provider ──────────────────────────────────────────────────

@riverpod
Future<List<SongModel>> getAllSongs(Ref ref) async {
  final token = ref.watch(currentUserProvider)!.token;
  final res = await ref.watch(homeRepositoryProvider).getAllSongs(token: token);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

// ─── Get All Favourite Songs Provider ───────────────────────────────────────

@riverpod
Future<List<SongModel>> getAllFavSongs(Ref ref) async {
  final token = ref.watch(currentUserProvider.select((user) => user!.token));
  final res = await ref.watch(homeRepositoryProvider).getFavSongs(token: token);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

// ─── Home Viewmodel ──────────────────────────────────────────────────────────

@riverpod
class HomeViewmodel extends _$HomeViewmodel {
  late HomeRepository _homeRepository;
  late HomeLocalRepository _homeLocalRepository;

  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  // ─── Upload Song ─────────────────────────────────────────────────────────

  Future<void> uploadSong({
    required File selectedAudio,
    required File selectedImage,
    required String songName,
    required String artist,
    required Color selectedColor,
  }) async {
    state = const AsyncValue.loading();

    final res = await _homeRepository.uploadSong(
      selectedAudio: selectedAudio,
      selectedImage: selectedImage,
      songName: songName,
      artist: artist,
      selectedColor: rgbtoHex(selectedColor),
      token: ref.read(currentUserProvider)!.token,
    );

    if (!ref.mounted) return;

    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }

  // ─── Recently Played Songs ────────────────────────────────────────────────

  List<SongModel> getrecentlyPlayedSong() {
    return _homeLocalRepository.loadSongs();
  }

  // ─── Favourite Song ───────────────────────────────────────────────────────

  Future<void> favSong({required String songId}) async {
    // ✅ Step 1: Optimistic update — update UI instantly before server responds
    _toggleFavOptimistically(songId);

    final res = await _homeRepository.favSong(
      songId: songId,
      token: ref.read(currentUserProvider)!.token,
    );

    if (!ref.mounted) return;

    switch (res) {
      case Left(value: final l):
        // ✅ Step 2a: Server failed — revert the optimistic update
        _toggleFavOptimistically(songId);
        state = AsyncValue.error(l.message, StackTrace.current);
      case Right(value: _):
        // ✅ Step 2b: Server confirmed — refresh library silently in background
        ref.invalidate(getAllFavSongsProvider);
    }
  }

  // ─── Optimistic Toggle (no server call) ──────────────────────────────────

  void _toggleFavOptimistically(String songId) {
    if (!ref.mounted) return;

    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    final alreadyFav = currentUser.favorites.any(
      (fav) => fav.song_id == songId,
    );

    final updatedFavorites = alreadyFav
        // Remove it
        ? currentUser.favorites.where((fav) => fav.song_id != songId).toList()
        // Add it
        : [
            ...currentUser.favorites,
            FavSongModel(id: '', song_id: songId, user_id: ''),
          ];

    ref
        .read(currentUserProvider.notifier)
        .addUser(currentUser.copyWith(favorites: updatedFavorites));
  }
}
