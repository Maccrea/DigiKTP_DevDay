class InstansiModel {
  final String idInstansi;
  final String namaInstansi;
  final String kodeInstansi;

  InstansiModel({
    required this.idInstansi,
    required this.namaInstansi,
    required this.kodeInstansi,
  });

  factory InstansiModel.fromJson(Map<String, dynamic> json) {
    return InstansiModel(
      idInstansi: json['id_instansi'] ?? '',
      namaInstansi: json['nama_instansi'] ?? '',
      kodeInstansi: json['kode_instansi'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id_instansi': idInstansi,
    'nama_instansi': namaInstansi,
    'kode_instansi': kodeInstansi,
  };
}