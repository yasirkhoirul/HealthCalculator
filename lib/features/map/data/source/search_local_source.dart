import 'package:shared_preferences/shared_preferences.dart';
import '../models/search_history_model.dart';

/// Sumber data lokal (Local Source) untuk menyimpan dan mengelola riwayat pencarian.
/// Menggunakan SharedPreferences dengan in-memory fallback untuk performa tinggi.
class SearchLocalSource {
  static const String _keyRecentSearches = 'map_recent_searches_v1';
  static const int maxRecentSearches = 10;

  // In-memory cache untuk pembacaan instan tanpa I/O lag
  List<String>? _cachedSearches;

  static const List<String> defaultRecentSearches = [
    'Main Library',
    'CS301 Sprint',
    'Cafe Ada',
  ];

  /// Mengambil daftar kata kunci pencarian terkini
  Future<List<String>> getRecentSearches() async {
    if (_cachedSearches != null) {
      return List<String>.from(_cachedSearches!);
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedList = prefs.getStringList(_keyRecentSearches);
      if (storedList != null && storedList.isNotEmpty) {
        _cachedSearches = List<String>.from(storedList);
        return List<String>.from(_cachedSearches!);
      }
    } catch (_) {
      // Fallback jika SharedPreferences tidak tersedia
    }

    // Gunakan default awal jika belum ada data tersimpan
    _cachedSearches = List<String>.from(defaultRecentSearches);
    return List<String>.from(_cachedSearches!);
  }

  /// Menyimpan kata kunci pencarian baru ke urutan teratas (maksimal 10 item)
  Future<void> saveRecentSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final current = await getRecentSearches();

    // Hapus duplikat (case-insensitive)
    current.removeWhere((item) => item.toLowerCase() == trimmed.toLowerCase());

    // Masukkan ke urutan teratas
    current.insert(0, trimmed);

    // Batasi hingga 10 item
    if (current.length > maxRecentSearches) {
      current.removeRange(maxRecentSearches, current.length);
    }

    _cachedSearches = List<String>.from(current);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_keyRecentSearches, current);
    } catch (_) {
      // SharedPreferences error ignored for memory fallback
    }
  }

  /// Menghapus satu item dari riwayat pencarian
  Future<void> removeRecentSearch(String query) async {
    final current = await getRecentSearches();
    current.removeWhere((item) => item.toLowerCase() == query.trim().toLowerCase());
    _cachedSearches = List<String>.from(current);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_keyRecentSearches, current);
    } catch (_) {
      // Error ignored
    }
  }

  /// Menghapus seluruh riwayat pencarian
  Future<void> clearAllRecentSearches() async {
    _cachedSearches = [];

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyRecentSearches);
    } catch (_) {
      // Error ignored
    }
  }

  /// Mengambil riwayat dalam bentuk model [SearchHistoryModel]
  Future<List<SearchHistoryModel>> getRecentHistory() async {
    final list = await getRecentSearches();
    return list
        .map(
          (q) => SearchHistoryModel(
            query: q,
            timestamp: DateTime.now(),
          ),
        )
        .toList();
  }
}
