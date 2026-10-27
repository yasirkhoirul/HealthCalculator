import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../router/app_routes.dart';
import '../viewmodels/map_viewmodel.dart';
import 'spot_detail/spot_detail_bottom_sheet.dart';
import 'top_spots/spot_list_card_widget.dart';

/// Preview Bottom Spots Sheet ("Top Campus Spots Live")
/// Menampilkan ringkasan 2 spot kampus teratas di atas bottom bar dengan link "View map list"
class MapBottomSpotsSheetWidget extends StatelessWidget {
  final MapViewModel mapViewModel;
  final VoidCallback? onViewMapList;

  const MapBottomSpotsSheetWidget({
    super.key,
    required this.mapViewModel,
    this.onViewMapList,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = AppColors.textPrimaryOf(context);
    const primaryPurple = Color(0xFF4F46E5);
    final spots = mapViewModel.spots.take(2).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Header: "Top Campus Spots" • Live • "View map list" ───
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title + Live Badge
              Row(
                children: [
                  Text(
                    'Top Campus Spots',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Live',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: primaryPurple,
                      ),
                    ),
                  ),
                ],
              ),

              // "View map list" Link Button
              TextButton(
                onPressed: () {
                  if (onViewMapList != null) {
                    onViewMapList!();
                  } else {
                    context.pushNamed(AppRoutes.topSpotsList);
                  }
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'View map list',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: primaryPurple,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // ─── List 2 Preview Spot Cards ───
        ...spots.map(
          (spot) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SpotListCardWidget(
              spot: spot,
              isCompact: true,
              onTap: () {
                mapViewModel.selectSpot(spot);
                SpotDetailBottomSheet.show(context, spot).whenComplete(() {
                  mapViewModel.clearSelectedSpot();
                });
              },
              onRouteTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Menampilkan rute tercepat ke ${spot.name}...'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
