# 📝 Catatan Panduan Belajar & Arsitektur HangoutMap

Halo! Dokumen ini dibuat khusus sebagai panduan santai tapi lengkap untuk kita berdua dalam mengerjakan proyek **HangoutMap / StudyMap** (aplikasi interaktif mirip Zenly untuk hangout/belajar bareng).

---

## 🎯 1. Pola yang Kita Pakai: MVVM (Model - View - ViewModel)

Di proyek ini kita sepakat memakai **MVVM murni** dan **TIDAK memakai layer `domain` / `usecase`**. 

**Kenapa tanpa `domain`?**  
Biar kita nggak pusing bolak-balik bikin file yang terlalu banyak (*boilerplate*). Cukup 3 lapis utama:
1. **View (`view/`)**: Layar UI (`pages/`) dan komponen kecil (`widgets/`). Tugasnya cuma menampilkan data dan menangkap input tombol.
2. **ViewModel (`view/viewmodels/`)**: Otak pengatur logika bisnis (menggunakan `ChangeNotifier`). Mengambil data dari data source, menyimpan status (`isLoading`, error, data), dan memberi tahu View lewat `notifyListeners()`.
3. **Data (`data/`)**: 
   - `models/`: Objek data / entitas (wajib pakai `json_serializable`).
   - `source/`: Tempat narik data dari Firebase atau API HTTP.

---

## 📦 2. Aturan Wajib Membuat Model (`json_serializable`)

Setiap data dari internet/Firebase **WAJIB** dibuatkan model dengan anotasi `@JsonSerializable()`. Tujuannya agar kita tidak menulis parsing JSON manual `json['title']` yang rawan salah ketik (*human error*).

### Contoh Template Model:

Buat file baru, misalnya `lib/features/auth/data/models/user_model.dart`:

```dart
import 'package:json_annotation/json_annotation.dart';

// 1. Tulis 'part' sesuai dengan nama file kamu ditambah '.g.dart'
part 'user_model.g.dart';

// 2. Pasang anotasi @JsonSerializable()
@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  // 3. Pasang 2 baris boiler plate factory ini:
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
```

### ⚡ Cara Generate File `.g.dart` (Build Runner):
Setelah selesai menulis kode model di atas, buka terminal dan jalankan:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

> **PENTING:**
> - File yang berakhiran `.g.dart` dibuat otomatis oleh generator. **Jangan pernah mengedit file `.g.dart` secara manual!**
> - Kalau sedang membuat banyak model sekaligus, kamu bisa jalankan mode otomatis:
>   ```bash
>   flutter pub run build_runner watch --delete-conflicting-outputs
>   ```
>   *(Dia akan otomatis meng-generate setiap kali kamu menekan Save/Ctrl+S/Cmd+S)*.

---

## 💉 3. Dependency Injection dengan `get_it`

Biar kita tidak perlu membuat instance `new AuthRemoteSource()` berulang-ulang di mana-mana, kita kumpulkan semua pembuatan objek di satu tempat: **`lib/core/di/injection.dart`**.

### Contoh Mendaftarkan Service & ViewModel:
Buka file `lib/core/di/injection.dart`:

```dart
import 'package:get_it/get_it.dart';
import '../../features/auth/data/source/auth_remote_source.dart';
import '../../features/auth/view/viewmodels/auth_view_models.dart';

final locator = GetIt.instance;

void setupLocator() {
  // 1. Remote Source / Service -> Pakai LazySingleton (hanya dibuat 1 kali saat pertama diakses)
  locator.registerLazySingleton<AuthRemoteSource>(() => AuthRemoteSource());

  // 2. ViewModel -> Pakai Factory (dibuat baru tiap screen dibuka)
  locator.registerFactory<AuthViewModel>(
    () => AuthViewModel(locator<AuthRemoteSource>()),
  );
}
```

---

## 🔄 4. Alur Kerja Praktis: Kalau Mau Bikin Fitur Baru

Misalkan kamu mau buat fitur **Room Belajar** di folder `lib/features/study/`:

1. **Langkah 1 (Data Model)**:
   - Buat `lib/features/study/data/models/room_model.dart`.
   - Pasang `@JsonSerializable()`, lalu jalankan `build_runner`.
2. **Langkah 2 (Data Source)**:
   - Buat `lib/features/study/data/source/room_remote_source.dart`.
   - Tulis fungsi untuk ambil room dari Firebase / kirim data room.
3. **Langkah 3 (ViewModel)**:
   - Buat `lib/features/study/view/viewmodels/room_viewmodel.dart` yang meng-`extends ChangeNotifier`.
   - Panggil `roomRemoteSource` di dalamnya, dan panggil `notifyListeners()` saat data selesai dimuat.
4. **Langkah 4 (Daftarkan ke GetIt)**:
   - Masukkan `RoomRemoteSource` dan `RoomViewModel` ke `lib/core/di/injection.dart`.
5. **Langkah 5 (View / Halaman UI)**:
   - Buat halaman di `lib/features/study/view/pages/room_detail_page.dart`.
   - Bungkus halamannya dengan `ChangeNotifierProvider` memanggil `locator<RoomViewModel>()`:
     ```dart
     ChangeNotifierProvider(
       create: (_) => locator<RoomViewModel>()..fetchRooms(),
       child: Consumer<RoomViewModel>(
         builder: (context, vm, child) {
           if (vm.isLoading) return const CircularProgressIndicator();
           return ListView(...);
         },
       ),
     );
     ```

---

## 🤝 5. Tips Biar Nggak Bentrok saat Git Merge

1. Kerjakan fitur di dalam folder masing-masing (`features/auth`, `features/map`, `features/study`, dll).
2. Kalau membuat model baru, pastikan file `.g.dart` ikut di-commit agar temanmu tidak perlu run build runner lagi saat pull kode terbaru.
3. Kalau ada bingung atau mau nambah dependensi baru di `pubspec.yaml`, diskusikan dulu ya!

Selamat ngoding bareng! 🚀
