import 'package:flutter/widgets.dart';
import '../../../../core/constant/app_base_state.dart';
import '../../data/models/spot_model.dart';
import '../../data/models/study_status_model.dart';
import '../../data/models/user_presence_model.dart';
import '../../data/source/map_remote_source.dart';

typedef MapPresenceState = AppBaseState<List<UserPresenceModel>>;
typedef MapSpotsState = AppBaseState<List<SpotModel>>;

/// ViewModel untuk manajemen presensi pengguna, mood belajar (Study Status),
/// lokasi pengguna saat ini, serta eksplorasi dan penyortiran spot belajar kampus.
class MapViewModel extends ChangeNotifier {
  final MapRemoteSource _remoteSource;

  MapPresenceState _presenceState = const AppStateInitial();
  MapPresenceState get presenceState => _presenceState;
  List<UserPresenceModel> get nearbyUsers => _presenceState.dataOrNull ?? [];

  MapSpotsState _spotsState = const AppStateInitial();
  MapSpotsState get spotsState => _spotsState;

  List<SpotModel> _allSpots = SpotModel.defaultSpots;
  List<SpotModel> get allSpots => _allSpots;

  UserPresenceModel? _myLocation;
  UserPresenceModel? get myLocation => _myLocation;

  StudyStatusModel _currentStatus = StudyStatusModel.defaultStatus;
  StudyStatusModel get currentStatus => _currentStatus;

  UserPresenceModel? _selectedUser;
  UserPresenceModel? get selectedUser => _selectedUser;

  SpotModel? _selectedSpot;
  SpotModel? get selectedSpot => _selectedSpot;

  String _sortBy = 'nearest'; // 'nearest' | 'relevant'
  String get sortBy => _sortBy;

  String _selectedVibe = 'All Vibe'; // 'All Vibe' | 'Coding' | 'UI/UX' | 'Exam Prep'
  String get selectedVibe => _selectedVibe;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  int _recenterTrigger = 0;
  int get recenterTrigger => _recenterTrigger;

  // ─── Zoom & Transformation State Management ───
  static const double defaultZoom = 1.0;
  static const double minZoom = 0.75;
  static const double maxZoom = 3.5;
  static const double zoomStep = 0.25;

  double _currentZoom = defaultZoom;
  double get currentZoom => _currentZoom;
  double get minZoomValue => minZoom;
  double get maxZoomValue => maxZoom;

  bool get canZoomIn => _currentZoom < (maxZoom - 0.001);
  bool get canZoomOut => _currentZoom > (minZoom + 0.001);

  TransformationController? _transformationController;
  TransformationController get transformationController {
    if (_transformationController == null) {
      _transformationController = TransformationController();
      _transformationController!.addListener(_onTransformationChanged);
    }
    return _transformationController!;
  }

  void attachTransformationController(TransformationController controller) {
    if (_transformationController != controller) {
      _transformationController?.removeListener(_onTransformationChanged);
      _transformationController = controller;
      _transformationController!.addListener(_onTransformationChanged);
    }
  }

  void _onTransformationChanged() {
    if (_transformationController != null && !_isDisposed) {
      final scale = _transformationController!.value.getMaxScaleOnAxis();
      if ((_currentZoom - scale).abs() > 0.01) {
        _currentZoom = scale;
      }
      notifyListeners();
    }
  }

  /// Memusatkan kembali viewport peta ke posisi pengguna saat ini.
  void recenterToUser() {
    if (_transformationController != null) {
      _transformationController!.value = Matrix4.identity();
    }
    recenterToMyLocation();
  }

  bool _isDisposed = false;

  MapViewModel({MapRemoteSource? remoteSource})
      : _remoteSource = remoteSource ?? MapRemoteSource() {
    initUserLocation();
    loadSpots();
  }

  /// Memperbesar skala viewport peta sebesar 0.25 level hingga batas maksimal 3.5x.
  void zoomIn() {
    if (canZoomIn) {
      final next = (_currentZoom + zoomStep).clamp(minZoom, maxZoom);
      _currentZoom = double.parse(next.toStringAsFixed(2));
      if (_transformationController != null) {
        _transformationController!.value =
            Matrix4.diagonal3Values(_currentZoom, _currentZoom, 1.0);
      }
      notifyListeners();
    }
  }

  /// Memperkecil skala viewport peta sebesar 0.25 level hingga batas minimal 0.75x.
  void zoomOut() {
    if (canZoomOut) {
      final next = (_currentZoom - zoomStep).clamp(minZoom, maxZoom);
      _currentZoom = double.parse(next.toStringAsFixed(2));
      if (_transformationController != null) {
        _transformationController!.value =
            Matrix4.diagonal3Values(_currentZoom, _currentZoom, 1.0);
      }
      notifyListeners();
    }
  }

  /// Mengatur skala zoom langsung dengan nilai tertentu dalam batas aman.
  void setZoom(double zoom) {
    final clamped = zoom.clamp(minZoom, maxZoom);
    if ((_currentZoom - clamped).abs() > 0.001) {
      _currentZoom = double.parse(clamped.toStringAsFixed(2));
      if (_transformationController != null) {
        _transformationController!.value =
            Matrix4.diagonal3Values(_currentZoom, _currentZoom, 1.0);
      }
      notifyListeners();
    }
  }

  /// Mengembalikan skala zoom ke skala default 1.0x.
  void resetZoom() {
    if (_currentZoom != defaultZoom) {
      _currentZoom = defaultZoom;
      if (_transformationController != null) {
        _transformationController!.value = Matrix4.identity();
      }
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (_isDisposed) return;
    super.notifyListeners();
  }

  /// List spot terfilter dan terurut berdasarkan kriteria aktif
  List<SpotModel> get spots {
    var result = List<SpotModel>.from(_allSpots);

    // 1. Filter Vibe/Kategori
    if (_selectedVibe != 'All Vibe') {
      result = result
          .where((s) => s.vibe.toLowerCase() == _selectedVibe.toLowerCase())
          .toList();
    }

    // 2. Filter Pencarian Teks
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((s) {
        return s.name.toLowerCase().contains(q) ||
            s.subtitle.toLowerCase().contains(q) ||
            s.category.toLowerCase().contains(q);
      }).toList();
    }

    // 3. Penyortiran (Nearest / Relevant)
    if (_sortBy == 'nearest') {
      result.sort((a, b) => a.distanceInMeters.compareTo(b.distanceInMeters));
    } else {
      // Relevant: utamakan rating tinggi & jumlah teman terbanyak
      result.sort((a, b) {
        final scoreA = (a.rating * 10) + a.friendsCount;
        final scoreB = (b.rating * 10) + b.friendsCount;
        return scoreB.compareTo(scoreA);
      });
    }

    return result;
  }

  /// Memuat daftar spot belajar kampus
  Future<void> loadSpots() async {
    _spotsState = const AppStateLoading();
    notifyListeners();

    try {
      _allSpots = SpotModel.defaultSpots;
      _spotsState = AppStateSuccess(data: _allSpots);
    } catch (e) {
      _spotsState = AppStateError(
        message: 'Gagal memuat spot: ${e.toString()}',
        error: e,
      );
    }
    notifyListeners();
  }

  /// Mengubah kriteria pengurutan spot ('nearest' | 'relevant')
  void setSortBy(String criteria) {
    if (_sortBy != criteria) {
      _sortBy = criteria;
      notifyListeners();
    }
  }

  /// Alias pemanggilan sortSpots
  void sortSpots(String criteria) => setSortBy(criteria);

  /// Mengubah filter vibe aktif ('All Vibe', 'Coding', 'UI/UX', 'Exam Prep')
  void setVibe(String vibe) {
    if (_selectedVibe != vibe) {
      _selectedVibe = vibe;
      notifyListeners();
    }
  }

  /// Memperbarui kata kunci pencarian spot atau rekan
  void updateSearchQuery(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  /// Memilih spot belajar aktif
  void selectSpot(SpotModel spot) {
    _selectedSpot = spot;
    notifyListeners();
  }

  /// Menghapus spot terpilih
  void clearSelectedSpot() {
    if (_selectedSpot != null) {
      _selectedSpot = null;
      notifyListeners();
    }
  }

  int _panTrigger = 0;
  int get panTrigger => _panTrigger;
  double? _targetLatitude;
  double? get targetLatitude => _targetLatitude;
  double? _targetLongitude;
  double? get targetLongitude => _targetLongitude;
  SpotModel? _targetSpot;
  SpotModel? get targetSpot => _targetSpot;

  /// Menggeser dan memusatkan koordinat peta ke posisi koordinat tertentu
  void animateToLocation(double latitude, double longitude) {
    _targetLatitude = latitude;
    _targetLongitude = longitude;
    _panTrigger++;
    notifyListeners();
  }

  /// Memusatkan koordinat peta ke posisi spot yang dipilih
  void panToSpotCoordinate(SpotModel spot) {
    _targetSpot = spot;
    _targetLatitude = spot.latitude;
    _targetLongitude = spot.longitude;
    _panTrigger++;
    selectSpot(spot);
  }

  /// Inisialisasi posisi pengguna saat ini dan daftar teman di sekitar kampus.
  Future<void> initUserLocation() async {
    try {
      _myLocation = await _remoteSource.getMyLocation();
      if (_myLocation?.status != null) {
        _currentStatus = _myLocation!.status!;
      }
    } catch (_) {
      // Fallback data lokal jika source gagal
      _myLocation = UserPresenceModel(
        id: 'me',
        name: 'Saya',
        campus: 'Universitas Indonesia',
        major: 'Ilmu Komputer',
        currentSpotName: 'Main Campus Library Floor 2',
        currentTopic: 'Sistem Operasi & Jaringan',
        latitude: -6.3635,
        longitude: 106.8275,
        isOnline: true,
        isCurrentUser: true,
        status: _currentStatus,
      );
    }
    notifyListeners();

    await loadNearbyUsers();
  }

  /// Memuat data presensi pengguna/mahasiswa aktif di sekitar spot kampus.
  Future<void> loadNearbyUsers() async {
    _presenceState = const AppStateLoading();
    notifyListeners();

    try {
      final users = await _remoteSource.getNearbyUserPresences();
      if (users.isEmpty) {
        _presenceState =
            const AppStateEmpty(message: 'Tidak ada mahasiswa aktif di sekitar.');
      } else {
        _presenceState = AppStateSuccess(data: users);
      }
    } catch (e) {
      _presenceState = AppStateError(
        message: 'Gagal memuat presensi pengguna: ${e.toString()}',
        error: e,
      );
    }
    notifyListeners();
  }

  /// Memperbarui status emote kondisi belajar pengguna saat ini.
  void setStudyStatus(StudyStatusModel newStatus) {
    _currentStatus = newStatus;
    if (_myLocation != null) {
      _myLocation = _myLocation!.copyWith(status: newStatus);
    }
    notifyListeners();
  }

  /// Trigger pemusatan ulang viewport peta ke posisi pengguna saat ini (My Location).
  void recenterToMyLocation() {
    _recenterTrigger++;
    notifyListeners();
  }

  /// Memilih pin pengguna aktif di peta untuk menampilkan floating card detail.
  void selectUser(UserPresenceModel? user) {
    if (_selectedUser?.id != user?.id) {
      _selectedUser = user;
      notifyListeners();
    }
  }

  /// Alias pemanggilan seleksi user pin.
  void selectUserPresence(UserPresenceModel? user) => selectUser(user);

  /// Mereset pin terpilih saat modal ditutup.
  void clearSelectedUser() {
    if (_selectedUser != null) {
      _selectedUser = null;
      notifyListeners();
    }
  }
}
