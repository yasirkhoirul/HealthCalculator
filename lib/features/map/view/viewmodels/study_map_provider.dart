import 'package:flutter/foundation.dart';
import '../../../../core/mock/mock_data.dart';

/// ViewModel / Provider untuk Peta Interaktif Spot Belajar Kampus
class StudyMapProvider extends ChangeNotifier {
  final List<String> _categories = const [
    'All Spot',
    'Coworking',
    'Library',
    'Event/Meet',
  ];

  String _selectedCategory = 'All Spot';
  String _searchQuery = '';
  StudySpot? _selectedSpot;
  bool _isBottomSheetOpen = true;
  bool _isExpanded = false;

  StudyMapProvider() {
    _selectedSpot = MockData.spots.isNotEmpty ? MockData.spots.first : null;
  }

  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  StudySpot? get selectedSpot => _selectedSpot;
  bool get isBottomSheetOpen => _isBottomSheetOpen;
  bool get isExpanded => _isExpanded;

  List<StudySpot> get allSpots => MockData.spots;

  List<StudySpot> get filteredSpots {
    return MockData.spots.where((spot) {
      final matchesCategory = _selectedCategory == 'All Spot' ||
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

  List<StudyBuddy> get selectedSpotBuddies {
    if (_selectedSpot == null) return const [];
    return MockData.getBuddiesBySpot(_selectedSpot!.id);
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

  void setExpanded(bool expanded) {
    if (_isExpanded != expanded) {
      _isExpanded = expanded;
      notifyListeners();
    }
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
