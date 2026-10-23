import '../../features/auth/data/models/auth_user_model.dart';
import 'app_base_state.dart';

export 'app_base_state.dart';

/// Alias state khusus autentikasi.
///
/// Semua sub-state di bawah hanyalah alias dari [AppBaseState] dengan tipe
/// payload [AuthUserModel], sehingga UI auth dapat memakai pattern matching
/// yang ringkas tanpa mengulang type argument.
typedef AppAuthState = AppBaseState<AuthUserModel>;

typedef AppAuthStateInitial = AppStateInitial<AuthUserModel>;
typedef AppAuthStateLoading = AppStateLoading<AuthUserModel>;
typedef AppAuthStateSuccess = AppStateSuccess<AuthUserModel>;
typedef AppAuthStateError = AppStateError<AuthUserModel>;
typedef AppAuthStateEmpty = AppStateEmpty<AuthUserModel>;