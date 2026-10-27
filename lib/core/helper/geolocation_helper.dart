/// Helper kalkulasi jarak geolokasi dan koordinat peta kampus
class GeolocationHelper {
  const GeolocationHelper._();

  static String formatDistance(int distanceInMeters) {
    if (distanceInMeters >= 1000) {
      final km = (distanceInMeters / 1000).toStringAsFixed(1);
      return '${km}km';
    }
    return '${distanceInMeters}m';
  }
}
