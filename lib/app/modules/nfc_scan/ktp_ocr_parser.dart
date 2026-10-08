class KtpOcrParser {
  const KtpOcrParser._();

  static Map<String, String> parse(String recognizedText) {
    final lines = recognizedText
        .split(RegExp(r'[\r\n]+'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
    final fields = <String, String>{};

    _putField(fields, lines, 'nik', RegExp(r'N[I1]K'));
    _putField(fields, lines, 'nama_lengkap', RegExp(r'NAMA(?:\s+LENGKAP)?'));
    _putField(
      fields,
      lines,
      'tempat_tanggal_lahir',
      RegExp(r'TEMPAT\s*/\s*TGL\s+LAHIR|TEMPAT\s+TGL\s+LAHIR|TTL'),
    );
    _putField(fields, lines, 'jenis_kelamin', RegExp(r'JENIS\s+KELAMIN'));
    _putField(
      fields,
      lines,
      'golongan_darah',
      RegExp(r'GOL(?:\.|ONGAN)?\s+DARAH'),
    );
    _putField(fields, lines, 'agama', RegExp(r'AGAMA'));
    _putField(
      fields,
      lines,
      'status_perkawinan',
      RegExp(r'STATUS\s+PERKAWINAN'),
    );
    _putField(fields, lines, 'pekerjaan', RegExp(r'PEKERJAAN'));
    _putField(fields, lines, 'kewarganegaraan', RegExp(r'KEWARGANEGARAAN'));
    _putField(fields, lines, 'berlaku_hingga', RegExp(r'BERLAKU\s+HINGGA'));

    final address = _readAddress(lines);
    if (address != null) fields['alamat'] = address;
    _putField(fields, lines, 'rt_rw', RegExp(r'RT\s*/\s*RW'));
    _putField(
      fields,
      lines,
      'kelurahan_desa',
      RegExp(r'KEL\s*/\s*DESA|KELURAHAN'),
    );
    _putField(fields, lines, 'kecamatan', RegExp(r'KECAMATAN'));

    return fields;
  }

  static void _putField(
    Map<String, String> fields,
    List<String> lines,
    String key,
    RegExp label,
  ) {
    final value = _readField(lines, label);
    if (value != null) fields[key] = value;
  }

  static String? _readField(List<String> lines, RegExp label) {
    for (var index = 0; index < lines.length; index++) {
      final match = RegExp(
        '^\\s*${label.pattern}\\s*[:.]?\\s*(.*)\u0024',
        caseSensitive: false,
      ).firstMatch(lines[index]);
      if (match == null) continue;
      final inlineValue = match.group(1)?.trim() ?? '';
      if (inlineValue.isNotEmpty) return inlineValue;
      if (index + 1 < lines.length && !_isFieldLabel(lines[index + 1])) {
        return lines[index + 1].trim();
      }
    }
    return null;
  }

  static String? _readAddress(List<String> lines) {
    for (var index = 0; index < lines.length; index++) {
      final match = RegExp(
        r'^\s*ALAMAT\s*[:.]?\s*(.*)$',
        caseSensitive: false,
      ).firstMatch(lines[index]);
      if (match == null) continue;

      final parts = <String>[];
      final inline = match.group(1)?.trim() ?? '';
      if (inline.isNotEmpty) parts.add(inline);
      for (
        var next = index + 1;
        next < lines.length && parts.length < 3;
        next++
      ) {
        if (_isFieldLabel(lines[next])) break;
        parts.add(lines[next].trim());
      }
      if (parts.isNotEmpty) return parts.join(', ');
    }
    return null;
  }

  static bool _isFieldLabel(String value) {
    return RegExp(
      r'^(NIK|NAMA|TEMPAT|TTL|JENIS KELAMIN|GOL|AGAMA|STATUS|PEKERJAAN|KEWARGANEGARAAN|BERLAKU|KEL|KECAMATAN|ALAMAT)\b',
      caseSensitive: false,
    ).hasMatch(value.trim());
  }
}
