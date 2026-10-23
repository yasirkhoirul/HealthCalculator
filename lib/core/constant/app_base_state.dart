import 'package:flutter/foundation.dart';

/// Base sealed state generic untuk manajemen state di seluruh aplikasi (ala BLoC).
///
/// [T] adalah tipe data payload. Pada [AppStateSuccess] data dibuat **nullable**
/// agar ViewModel tetap menjadi satu-satunya pihak yang menentukan apakah sebuah
/// operasi menghasilkan payload atau tidak (misal: aksi sukses tanpa data).
@immutable
sealed class AppBaseState<T> {
  const AppBaseState();
}

/// State inisial sebelum ada aksi atau pemuatan data.
class AppStateInitial<T> extends AppBaseState<T> {
  const AppStateInitial();
}

/// State saat proses asynchronous / pemuatan data sedang berjalan.
class AppStateLoading<T> extends AppBaseState<T> {
  final String? message;

  const AppStateLoading({this.message});
}

/// State ketika operasi berhasil. [data] boleh null bila aksi tidak
/// mengembalikan payload apa pun.
class AppStateSuccess<T> extends AppBaseState<T> {
  final T? data;
  final String? message;

  const AppStateSuccess({this.data, this.message});
}

/// State saat terjadi kegagalan atau error.
class AppStateError<T> extends AppBaseState<T> {
  final String message;
  final Object? error;

  const AppStateError({required this.message, this.error});
}

/// State ketika data yang diminta kosong (empty state).
class AppStateEmpty<T> extends AppBaseState<T> {
  final String? message;

  const AppStateEmpty({this.message});
}

/// Helper untuk mengambil payload dari state secara aman.
extension AppBaseStateX<T> on AppBaseState<T> {
  T? get dataOrNull => switch (this) {
        AppStateSuccess<T>(:final data) => data,
        _ => null,
      };

  bool get isLoading => this is AppStateLoading<T>;

  String? get errorOrNull => switch (this) {
        AppStateError<T>(:final message) => message,
        _ => null,
      };
}
