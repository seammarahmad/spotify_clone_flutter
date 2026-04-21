import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotify_clone_flutter/core/models/user_model.dart';
import 'package:spotify_clone_flutter/features/auth/repositories/auth_remote_repository.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  final AuthRemoteRepository _authRemoteRepository = AuthRemoteRepository();

  @override
  AsyncValue<UserModel>? build() {
    return null;
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state= const AsyncValue.loading();
    final res = await _authRemoteRepository.signup(
      name: name,
      email: email,
      password: password,
    );
    final val = switch (res) {
      Left(value: final l) => state=AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state=AsyncValue.data(r),
    };
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    final res = await _authRemoteRepository.login(
      email: email,
      password: password,
    );
    final val = switch (res) {
      Left(value: final l) => l,
      Right(value: final r) => r.name,
    };
  }
}
