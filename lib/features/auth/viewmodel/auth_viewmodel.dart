import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotify_clone_flutter/core/models/user_model.dart';
import 'package:spotify_clone_flutter/core/provider/current_user_notifier.dart';
import 'package:spotify_clone_flutter/features/auth/repositories/auth_local_repository.dart';
import 'package:spotify_clone_flutter/features/auth/repositories/auth_remote_repository.dart';

part 'auth_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserProvider.notifier);
    return null;
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.signup(
      name: name,
      email: email,
      password: password,
    );
    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
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
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => _loginSuccess(r),
    };
    print (val);
  }

  Future<UserModel?> getData() async {
    state = const AsyncValue.loading();
    final token = _authLocalRepository.getToken();
    if (token != null) {
      final res = await _authRemoteRepository.getCurrentUserData(token);
      final val = switch (res) {
        Left(value: final l) => state = AsyncValue.error(
          l.message,
          StackTrace.current,
        ),
        Right(value: final r) => _getDataSuccess(r),
      };
      return val?.value;
    }
    state = null;
    return null;
  }

  ///Supportive Functions for the right in the login ad get data
  AsyncValue<UserModel>? _loginSuccess(UserModel user) {
    _authLocalRepository.setToken(user.token);
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }

  AsyncValue<UserModel>? _getDataSuccess(UserModel user) {
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }

  Future<void> initSharedPreferences() async {
    await _authLocalRepository.init();
  }
}
