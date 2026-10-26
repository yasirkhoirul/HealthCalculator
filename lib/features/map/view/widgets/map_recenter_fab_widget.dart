import 'package:flutter/material.dart';
import 'single_recenter_fab_widget.dart';

/// Floating Action Button "Lokasi Saya" (Crosshair / GPS)
/// Digunakan untuk memusatkan kembali peta ke koordinat pengguna saat ini.
class MapRecenterFabWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const MapRecenterFabWidget({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SingleRecenterFabWidget(onPressed: onPressed);
  }
}
