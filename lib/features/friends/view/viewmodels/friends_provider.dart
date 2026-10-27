import 'package:flutter/foundation.dart';
import '../../../../core/mock/mock_data.dart';

/// ViewModel / Provider untuk Tab Temukan Teman & Explore
class FriendsProvider extends ChangeNotifier {
  final List<StudyBuddy> _buddies = List.from(MockData.buddies);
  final List<StudyRequest> _requests = List.from(MockData.requests);
  String _searchQuery = '';
  final Set<String> _knockedBuddyIds = {};

  List<StudyBuddy> get buddies {
    if (_searchQuery.isEmpty) return _buddies;
    final q = _searchQuery.toLowerCase();
    return _buddies.where((b) {
      return b.name.toLowerCase().contains(q) ||
          b.major.toLowerCase().contains(q) ||
          b.currentStudyTopic.toLowerCase().contains(q);
    }).toList();
  }

  List<StudyRequest> get requests => _requests;
  int get requestCount => _requests.length;
  String get searchQuery => _searchQuery;

  bool isKnocked(String buddyId) => _knockedBuddyIds.contains(buddyId);

  void updateSearchQuery(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  void acceptRequest(String requestId) {
    final reqIndex = _requests.indexWhere((r) => r.id == requestId);
    if (reqIndex != -1) {
      final acceptedSender = _requests[reqIndex].sender;
      _buddies.insert(0, acceptedSender);
      _requests.removeAt(reqIndex);
      notifyListeners();
    }
  }

  void declineRequest(String requestId) {
    _requests.removeWhere((r) => r.id == requestId);
    notifyListeners();
  }

  void knockBuddy(String buddyId) {
    _knockedBuddyIds.add(buddyId);
    notifyListeners();
  }
}
