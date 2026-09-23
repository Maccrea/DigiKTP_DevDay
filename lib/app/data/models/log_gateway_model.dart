class LayananLogModel {
  final String idLog;
  final String nikWarga;
  final String idPetugas;
  final String idInstansi;
  final String lokasiTugas;
  final String jenisLayanan;
  final String statusTransaksi;
  final String createdAt;

  LayananLogModel({
    required this.idLog,
    required this.nikWarga,
    required this.idPetugas,
    required this.idInstansi,
    required this.lokasiTugas,
    required this.jenisLayanan,
    required this.statusTransaksi,
    required this.createdAt,
  });

  factory LayananLogModel.fromJson(Map<String, dynamic> json) {
    return LayananLogModel(
      idLog: json['id_log'] ?? '',
      nikWarga: json['nik_warga'] ?? '',
      idPetugas: json['id_petugas'] ?? '',
      idInstansi: json['id_instansi'] ?? '',
      lokasiTugas: json['lokasi_tugas'] ?? '',
      jenisLayanan: json['jenis_layanan'] ?? '',
      statusTransaksi: json['status_transaksi'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id_log': idLog,
    'nik_warga': nikWarga,
    'id_petugas': idPetugas,
    'id_instansi': idInstansi,
    'lokasi_tugas': lokasiTugas,
    'jenis_layanan': jenisLayanan,
    'status_transaksi': statusTransaksi,
    'created_at': createdAt,
  };
}
