class WargaModel {
  final String nik;
  final String uidNfc;
  final String namaLengkap;
  final String email;
  final String noHandphone;
  final String tempatTanggalLahir;
  final String jenisKelamin;
  final String alamat;
  final String agama;

  WargaModel({
    required this.nik,
    required this.uidNfc,
    required this.namaLengkap,
    required this.email,
    required this.noHandphone,
    required this.tempatTanggalLahir,
    required this.jenisKelamin,
    required this.alamat,
    required this.agama,
  });

  factory WargaModel.fromJson(Map<String, dynamic> json) {
    return WargaModel(
      nik: json['nik'] ?? '',
      uidNfc: json['uid_nfc'] ?? '',
      namaLengkap: json['nama_lengkap'] ?? '',
      email: json['email'] ?? '',
      noHandphone: json['no_hp'] ?? '',
      tempatTanggalLahir: json['tempat_tanggal_lahir'] ?? '',
      jenisKelamin: json['jenis_kelamin'] ?? '',
      alamat: json['alamat'] ?? '',
      agama: json['agama'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'nik': nik,
    'uid_nfc': uidNfc,
    'nama_lengkap': namaLengkap,
    'email': email,
    'no_hp': noHandphone,
    'tempat_tanggal_lahir': tempatTanggalLahir,
    'jenis_kelamin': jenisKelamin,
    'alamat': alamat,
    'agama': agama,
  };
}