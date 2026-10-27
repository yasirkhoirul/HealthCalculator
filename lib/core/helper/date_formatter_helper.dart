/// Helper utilitas formatting tanggal, waktu, dan durasi fokus
class DateFormatterHelper {
  const DateFormatterHelper._();

  static String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSecs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSecs.toString().padLeft(2, '0')}';
  }

  static String formatTimestamp(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
