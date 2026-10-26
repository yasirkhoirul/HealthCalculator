import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../core/constant/app_base_state.dart';
import '../../data/models/spot_model.dart';
import '../../data/source/search_local_source.dart';

/// ViewModel untuk mengelola alur pencarian cerdas (Smart Search Overlay):
/// debouncing kata kunci 300ms, riwayat pencarian terkini, dan filtering spot kampus.
class MapSearchViewModel extends ChangeNotifier {
  final SearchLocalSource _localSource;

  List<String> _recentSearches = [];
  List<String> get recentSearches => _recentSearches;

  AppBaseState<List<SpotModel>> _searchState = const AppStateInitial();
  AppBaseState<List<SpotModel>> get searchState => _searchState;

  String _currentQuery = '';
  String get currentQuery => _currentQuery;

  Timer? _debounceTimer;

  List<SpotModel> _allSpots = SpotModel.defaultSpots;
  List<SpotModel> get allSpots => _allSpots;

  MapSearchViewModel({SearchLocalSource? localSource})
      : _localSource = localSource ?? SearchLocalSource() {
    initRecentSearches();
  }

  /// Memuat riwayat pencarian dari penyimpanan lokal
  Future<void> initRecentSearches() async {
    _recentSearches = await _localSource.getRecentSearches();
    notifyListeners();
  }

  /// Menetapkan daftar data spot (bisa diisi dari MapViewModel atau data mock)
  void setSpots(List<SpotModel> spots) {
    _allSpots = spots;
    if (_currentQuery.isNotEmpty) {
      _performSearch(_currentQuery);
    }
  }

  /// Dipanggil saat teks pada input pencarian berubah dengan debounce 300ms
  void onQueryChanged(String query) {
    _currentQuery = query;
    _debounceTimer?.cancel();

    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      _searchState = const AppStateInitial();
      notifyListeners();
      return;
    }

    // Tampilkan state loading singkat selama debounce
    _searchState = const AppStateLoading(message: 'Mencari spot...');
    notifyListeners();

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(trimmed);
    });
  }

  /// Menjalankan pemfilteran spot kampus secara real-time berdasarkan query
  void _performSearch(String query) {
    final lowerQuery = query.toLowerCase();

    final filtered = _allSpots.where((spot) {
      final nameMatches = spot.name.toLowerCase().contains(lowerQuery);
      final categoryMatches = spot.category.toLowerCase().contains(lowerQuery);
      final subtitleMatches = spot.subtitle.toLowerCase().contains(lowerQuery);
      final crowdMatches = spot.crowdLevel.toLowerCase().contains(lowerQuery) ||
          spot.crowdStatus.toLowerCase().contains(lowerQuery);
      final vibeMatches = spot.vibe.toLowerCase().contains(lowerQuery);
      final friendsMatches =
          spot.friendsSummary.toLowerCase().contains(lowerQuery);

      return nameMatches ||
          categoryMatches ||
          subtitleMatches ||
          crowdMatches ||
          vibeMatches ||
          friendsMatches;
    }).toList();

    if (filtered.isEmpty) {
      _searchState = const AppStateEmpty(
        message: 'Spot belajar tidak ditemukan',
      );
    } else {
      _searchState = AppStateSuccess(data: filtered);
    }
    notifyListeners();
  }

  /// Menyimpan kata kunci ke riwayat pencarian lokal
  Future<void> addRecentSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    await _localSource.saveRecentSearch(trimmed);
    _recentSearches = await _localSource.getRecentSearches();
    notifyListeners();
  }

  /// Helper saat hasil pencarian spot dipilih oleh pengguna
  Future<void> onSelectSearchResult(SpotModel spot) async {
    await addRecentSearch(spot.name);
  }

  /// Menghapus satu kata kunci dari riwayat pencarian
  Future<void> removeRecentSearch(String query) async {
    await _localSource.removeRecentSearch(query);
    _recentSearches = await _localSource.getRecentSearches();
    notifyListeners();
  }

  /// Menghapus seluruh riwayat pencarian
  Future<void> clearAllRecentSearches() async {
    await _localSource.clearAllRecentSearches();
    _recentSearches = [];
    notifyListeners();
  }

  /// Mengosongkan query dan mengembalikan search state ke Initial
  void clearQuery() {
    _currentQuery = '';
    _debounceTimer?.cancel();
    _searchState = const AppStateInitial();
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
