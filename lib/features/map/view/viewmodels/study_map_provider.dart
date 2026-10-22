import 'package:flutter/foundation.dart';
import '../../../../core/mock/mock_data.dart';

/// ViewModel / Provider untuk Peta Interaktif Spot Belajar Kampus
class StudyMapProvider extends ChangeNotifier {
  final List<String> _categories = const [
    'Semua',
    'Perpustakaan',
    'Cafe Belajar',
    'Coworking',
    'Ruang Terbuka',
  ];

  String _selectedCategory = 'Semua';
  String _searchQuery = '';
  StudySpot? _selectedSpot;
  bool _isBottomSheetOpen = true;

  StudyMapProvider() {
    _selectedSpot = MockData.spots.isNotEmpty ? MockData.spots.first : null;
  }

  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  StudySpot? get selectedSpot => _selectedSpot;
  bool get isBottomSheetOpen => _isBottomSheetOpen;

  List<StudySpot> get allSpots => MockData.spots;

  List<StudySpot> get filteredSpots {
    return MockData.spots.where((spot) {
      final matchesCategory = _selectedCategory == 'Semua' ||
          spot.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesQuery = _searchQuery.isEmpty ||
          spot.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          spot.address.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          spot.facilities.any(
            (f) => f.toLowerCase().contains(_searchQuery.toLowerCase()),
          );
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void selectCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  void selectSpot(StudySpot spot) {
    _selectedSpot = spot;
    _isBottomSheetOpen = true;
    notifyListeners();
  }

  void toggleBottomSheet() {
    _isBottomSheetOpen = !_isBottomSheetOpen;
    notifyListeners();
  }

  void closeBottomSheet() {
    _isBottomSheetOpen = false;
    notifyListeners();
  }

  void openBottomSheet() {
    _isBottomSheetOpen = true;
    notifyListeners();
  }
}
