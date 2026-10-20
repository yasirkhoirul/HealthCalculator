# 🗺️ HangoutMap / StudyMap — Architecture & Project Structure Guide

Dokumen ini merupakan panduan standar arsitektur dan struktur folder untuk pengembangan aplikasi **HangoutMap / StudyMap** (aplikasi interaktif mirip Zenly untuk hangout/belajar bersama: peta live, room dengan durasi & kuota, serta sistem izin knock/join dari host).

---

## 🏗️ 1. Pola Arsitektur (MVVM + Provider)

Proyek ini mengadopsi pola **Feature-First MVVM (Model-View-ViewModel)** dengan **Provider** sebagai state management:

```
┌─────────────────────────────────────────────────────────────┐
│                          VIEW                               │
│   (Pages & Widgets: UI deklaratif, mendengarkan ViewModel)   │
└──────────────────────────────▲──────────────────────────────┘
                               │ (Notifikasi State / notifyListeners)
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                       VIEWMODEL                             │
│   (ChangeNotifier: Logic bisnis, state UI, validasi form)   │
└──────────────────────────────▲──────────────────────────────┘
                               │ (Panggil Service / DataSource)
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                         DATA                                │
│   - Source: HTTP API Client / Firebase Firestore & Auth     │
│   - Models: Data Entity + JsonSerializable (@JsonSerializable)│
└─────────────────────────────────────────────────────────────┘
```

---

## 📁 2. Konvensi Struktur Folder (`lib/`)

Struktur dibuat modular berbasis fitur (**Feature-First**), mengacu pada pola folder yang telah disiapkan di `lib/features/auth/`:

```
lib/
├── core/
│   ├── common/                  # Widget umum yang dipakai lintas fitur (Button, Input, Avatar, Dialog)
│   ├── constant/                # Konstanta (warna tema, gaya teks, asset paths, api endpoints)
│   ├── di/                      # Dependency Injection / Service Locator (injection.dart menggunakan GetIt)
│   ├── helper/                  # Fungsi utilitas (format tanggal/waktu, permission location, validasi)
│   └── network/                 # Konfigurasi HTTP client & Firebase helper
│
├── features/
│   ├── auth/                    # Fitur Autentikasi (Login, Register, Forgot Password)
│   │   ├── data/
│   │   │   ├── models/          # user_model.dart (+ user_model.g.dart)
│   │   │   └── source/          # auth_remote_source.dart (Firebase Auth / HTTP)
│   │   └── view/
│   │       ├── pages/           # login_page.dart, register_page.dart
│   │       ├── viewmodels/      # auth_viewmodel.dart (ChangeNotifier)
│   │       └── widgets/         # auth_text_field.dart, social_login_btn.dart
│   │
│   ├── map/                     # Fitur Utama Peta Interaktif (Zenly-style)
│   │   ├── data/
│   │   │   ├── models/          # map_pin_model.dart, user_presence_model.dart
│   │   │   └── source/          # map_remote_source.dart, location_service.dart
│   │   └── view/
│   │       ├── pages/           # map_page.dart
│   │       ├── viewmodels/      # map_viewmodel.dart
│   │       └── widgets/         # map_marker_widget.dart, quick_filter_bar.dart, bottom_sheet_preview.dart
│   │
│   ├── study/                   # Fitur Hangout / Study Room & Knocking
│   │   ├── data/
│   │   │   ├── models/          # room_model.dart, knock_request_model.dart
│   │   │   └── source/          # room_remote_source.dart (Firestore Realtime)
│   │   └── view/
│   │       ├── pages/           # room_detail_page.dart, create_room_page.dart, active_session_page.dart
│   │       ├── viewmodels/      # room_viewmodel.dart, session_timer_viewmodel.dart
│   │       └── widgets/         # knock_bottom_sheet.dart, participant_avatar_list.dart, timer_ring_widget.dart
│   │
│   ├── profile/                 # Profil Pengguna & Study Interests
│   │   ├── data/
│   │   │   ├── models/          # profile_model.dart
│   │   │   └── source/          # profile_remote_source.dart
│   │   └── view/
│   │       ├── pages/           # profile_page.dart, user_detail_page.dart
│   │       ├── viewmodels/      # profile_viewmodel.dart
│   │       └── widgets/         # interest_tag.dart, privacy_toggle_card.dart
│   │
│   └── settings/                # Pengaturan Aplikasi & Ghost Mode
│       └── ...
│
├── router/
│   └── app_router.dart          # Konfigurasi GoRouter (Named routes, auth guard, shell route navbar)
│
└── main.dart                    # Entry point aplikasi (Firebase init, MultiProvider setup, MaterialApp.router)
```

---

## ⚙️ 3. Konvensi Kode & Tooling

### A. Model & Serialisasi JSON (`json_serializable` + `build_runner`)
Setiap model data wajib menggunakan annotasi `@JsonSerializable()`:

```dart
// lib/features/study/data/models/room_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'room_model.g.dart';

@JsonSerializable()
class RoomModel {
  final String id;
  final String title;
  final String hostId;
  final int maxParticipants;
  final DateTime startTime;
  final int durationMinutes;

  RoomModel({
    required this.id,
    required this.title,
    required this.hostId,
    required this.maxParticipants,
    required this.startTime,
    required this.durationMinutes,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) => _$RoomModelFromJson(json);
  Map<String, dynamic> toJson() => _$RoomModelToJson(this);
}
```

**Perintah Menjalankan Generator:**
```bash
# Sekali jalan (Generate code):
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode saat sedang banyak membuat model:
flutter pub run build_runner watch --delete-conflicting-outputs
```

---

### B. ViewModel (Provider)
ViewModel meng-extend `ChangeNotifier`. Gunakan `notifyListeners()` saat data state berubah:

```dart
class RoomViewModel extends ChangeNotifier {
  final RoomRemoteSource _roomSource;
  RoomViewModel(this._roomSource);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> knockToJoin(String roomId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _roomSource.sendKnockRequest(roomId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

---

### C. Routing (`go_router`)
Semua navigasi didaftarkan secara terpusat di `lib/router/app_router.dart`:
- Path rute menggunakan konstanta (misal: `/`, `/login`, `/map`, `/room/:id`).
- Gunakan `context.pushNamed(...)` atau `context.goNamed(...)`.

### D. Dependency Injection (`get_it`)
Untuk mengelola pembuatan instance object (*Service Locator* / *Dependency Injection*) tanpa repot oper-oper parameter secara manual, kita menggunakan `get_it`.

File konfigurasi diletakkan di `lib/core/di/injection.dart`:

```dart
// lib/core/di/injection.dart
import 'package:get_it/get_it.dart';
import '../../features/auth/data/source/auth_remote_source.dart';
import '../../features/auth/view/viewmodels/auth_viewmodels.dart';

final locator = GetIt.instance;

void setupLocator() {
  // 1. Data Sources / Services (LazySingleton: dibuat sekali saat pertama kali diakses)
  locator.registerLazySingleton<AuthRemoteSource>(() => AuthRemoteSource());

  // 2. ViewModels (Factory: dibuat baru setiap dipanggil, atau Singleton jika ingin state global)
  locator.registerFactory<AuthViewModel>(
    () => AuthViewModel(locator<AuthRemoteSource>()),
  );
}
```

**Panggilan di `main.dart` sebelum `runApp()`:**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Dependency Injection
  setupLocator();

  runApp(const MainApp());
}
```

**Cara pakai bersama Provider di Widget/Screen:**
```dart
// Menggunakan ChangeNotifierProvider dengan GetIt
ChangeNotifierProvider(
  create: (_) => locator<AuthViewModel>(),
  child: const LoginPage(),
);

// Atau mengambil instance service secara langsung tanpa context:
final authSource = locator<AuthRemoteSource>();
```

---

## 🤝 4. Pedoman Kolaborasi Git dengan Rekan Tim

1. **Struktur Folder Terpisah**: Karena setiap fitur dipisahkan di `lib/features/<feature>/`, Anda dan rekan tim dapat mengerjakan fitur yang berbeda (misalnya: Anda mengerjakan `features/map` & `features/study`, rekan mengerjakan `features/auth` & `features/profile`) tanpa risiko merge conflict.
2. **File `.g.dart`**: Disarankan untuk tetap meng-commit file `.g.dart` ke git agar rekan tim bisa langsung menjalankan aplikasi tanpa perlu menjalankan build runner terlebih dahulu.
3. **Konstanta Bersama**: Bila menambahkan warna atau rute baru, tambahkan di `lib/core/constant/` atau `lib/router/app_router.dart` dengan komunikasi via PR / commit jelas.
