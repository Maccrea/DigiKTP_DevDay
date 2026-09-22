class CekWargaModel {
  final String namaMasking;
  final String wilayah;
  final bool isActive;
  final String phoneLastDigits;

  const CekWargaModel({
    required this.namaMasking,
    required this.wilayah,
    required this.isActive,
    required this.phoneLastDigits,
  });

  factory CekWargaModel.fromResponse(Map<String, dynamic> response) {
    final data = Map<String, dynamic>.from(response['data'] as Map);
    return CekWargaModel(
      namaMasking: data['nama_masking'] as String? ?? '',
      wilayah: data['wilayah'] as String? ?? '',
      isActive: data['is_active'] as bool? ?? false,
      phoneLastDigits: data['phone_last_digits'] as String? ?? '',
    );
  }
}