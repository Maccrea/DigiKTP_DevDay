class PetugasModel {
  final String idPetugas;
  final String nip;
  final String nama;
  final String email;
  final String idInstansi;
  final String lokasiLayanan;

  PetugasModel({
    required this.idPetugas,
    required this.nip,
    required this.nama,
    required this.email,
    required this.idInstansi,
    required this.lokasiLayanan,
  });

  factory PetugasModel.fromJson(Map<String, dynamic> json) {
    return PetugasModel(
      idPetugas: json['id_petugas'] ?? '',
      nip: json['nip'] ?? '',
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      idInstansi: json['id_instansi'] ?? '',
      lokasiLayanan: json['current_location'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id_petugas': idPetugas,
    'nip': nip,
    'nama': nama,
    'email': email,
    'id_instansi': idInstansi,
    'current_location': lokasiLayanan,
  };
}
