import 'package:get_storage/get_storage.dart';

class KtpPhotoStorage {
  KtpPhotoStorage._();

  static const _storageKey = 'ktp_transaction_photos';
  static final _storage = GetStorage();

  static Future<void> save(String logId, String path) async {
    final key = logId.trim();
    if (key.isEmpty || key == 'UUID-UNKNOWN' || path.trim().isEmpty) return;

    final stored = _storage.read<Map<dynamic, dynamic>>(_storageKey) ?? {};
    final paths = <String, String>{
      for (final entry in stored.entries)
        entry.key.toString(): entry.value.toString(),
    };
    paths[key] = path;
    await _storage.write(_storageKey, paths);
  }

  static List<Map<String, dynamic>> attachPaths(
    Iterable<Map<String, dynamic>> activities,
  ) {
    final stored = _storage.read<Map<dynamic, dynamic>>(_storageKey) ?? {};
    final paths = <String, String>{
      for (final entry in stored.entries)
        entry.key.toString(): entry.value.toString(),
    };

    return activities.map((activity) {
      final logId = (activity['log_id'] ?? activity['id_log'] ?? '').toString();
      final photoPath = paths[logId];
      return {
        ...activity,
        if (photoPath != null) 'photo_path': photoPath,
      };
    }).toList();
  }
}