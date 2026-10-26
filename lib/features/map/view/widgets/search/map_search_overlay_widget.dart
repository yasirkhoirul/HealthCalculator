import 'package:flutter/material.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../data/models/spot_model.dart';
import '../../viewmodels/map_search_viewmodel.dart';
import 'search_recent_list_widget.dart';
import 'search_results_list_widget.dart';

/// Container View Overlay untuk Pencarian Cerdas (Smart Search Overlay)
/// Terbuka penuh / ekspansi transisi dengan header input, riwayat, dan live results.
class MapSearchOverlayWidget extends StatefulWidget {
  final MapSearchViewModel viewModel;
  final ValueChanged<SpotModel> onSpotSelected;
  final VoidCallback onClose;
  final String? initialQuery;

  const MapSearchOverlayWidget({
    super.key,
    required this.viewModel,
    required this.onSpotSelected,
    required this.onClose,
    this.initialQuery,
  });

  @override
  State<MapSearchOverlayWidget> createState() => _MapSearchOverlayWidgetState();
}

class _MapSearchOverlayWidgetState extends State<MapSearchOverlayWidget> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.initialQuery ?? widget.viewModel.currentQuery,
    );
    _focusNode = FocusNode();

    // Memuat riwayat pencarian terkini saat overlay dibuka
    widget.viewModel.initRecentSearches();

    _textController.addListener(_onTextChanged);

    // Otomatis fokus keyboard setelah rendering pertama
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  void _onTextChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSelectSpot(SpotModel spot) {
    // 1. Simpan query / nama spot ke riwayat lokal
    widget.viewModel.addRecentSearch(spot.name);

    // 2. Hilangkan fokus keyboard
    FocusScope.of(context).unfocus();

    // 3. Panggil callback pemilihan spot
    widget.onSpotSelected(spot);
  }

  void _handleSelectRecentQuery(String query) {
    _textController.text = query;
    _textController.selection = TextSelection.fromPosition(
      TextPosition(offset: query.length),
    );
    widget.viewModel.onQueryChanged(query);
  }

  void _handleClearQuery() {
    _textController.clear();
    widget.viewModel.clearQuery();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final surfaceColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final cardBgColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textMuted = AppColors.textMutedOf(context);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    const primaryPurple = Color(0xFF4F46E5);

    final isQueryEmpty = _textController.text.trim().isEmpty;

    return Container(
      color: surfaceColor,
      child: SafeArea(
        child: Column(
          children: [
            // ─── 1. Header Search Bar Interaktif ───
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: surfaceColor,
                border: Border(
                  bottom: BorderSide(color: borderColor, width: 0.8),
                ),
              ),
              child: Row(
                children: [
                  // Tombol Kembali (Arrow Back)
                  Tooltip(
                    message: 'Tutup pencarian',
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          widget.onClose();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            size: 22,
                            color: textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Capsule TextField Container
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: cardBgColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: borderColor, width: 0.8),
                      ),
                      child: Row(
                        children: [
                          // Search Icon
                          Padding(
                            padding: const EdgeInsets.only(left: 14, right: 8),
                            child: Icon(
                              Icons.search_rounded,
                              size: 20,
                              color: primaryPurple,
                            ),
                          ),

                          // Search TextField
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              focusNode: _focusNode,
                              autofocus: true,
                              textInputAction: TextInputAction.search,
                              onChanged: (val) {
                                widget.viewModel.onQueryChanged(val);
                              },
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                                color: textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    'Cari spot belajar, meja, atau teman...',
                                hintStyle: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w400,
                                  color: textMuted,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),

                          // Tombol Clear (✕) saat ada teks
                          if (_textController.text.isNotEmpty)
                            Tooltip(
                              message: 'Kosongkan teks',
                              child: Material(
                                color: Colors.transparent,
                                shape: const CircleBorder(),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: _handleClearQuery,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Icon(
                                      Icons.close_rounded,
                                      size: 18,
                                      color: textMuted,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ─── 2. Body: Riwayat Pencarian vs Hasil Pencarian ───
            Expanded(
              child: AnimatedBuilder(
                animation: widget.viewModel,
                builder: (context, _) {
                  if (isQueryEmpty) {
                    return SearchRecentListWidget(
                      recentSearches: widget.viewModel.recentSearches,
                      onSelectRecent: _handleSelectRecentQuery,
                      onRemoveRecent: widget.viewModel.removeRecentSearch,
                      onClearAll: widget.viewModel.clearAllRecentSearches,
                    );
                  }

                  return SearchResultsListWidget(
                    searchState: widget.viewModel.searchState,
                    query: _textController.text,
                    onSpotTap: _handleSelectSpot,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
