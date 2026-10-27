/// Konfigurasi HTTP Client / Network helper untuk interaksi remote API StudyMap
class ApiClientHelper {
  final String baseUrl;
  final Duration timeout;

  const ApiClientHelper({
    this.baseUrl = 'https://api.studymap.ac.id/v1',
    this.timeout = const Duration(seconds: 15),
  });

  Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
}
