import 'package:digiktp/app/modules/nfc_scan/ktp_ocr_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('reads NIK split into grouped digits after its label', () {
    final parsed = KtpOcrParser.parse('''
NIK
3273 0102
1234 5678
Nama: RANI ANGGRAENI
Alamat: JL MELATI NO 8
RT/RW: 001/002
''');

    expect(parsed['nik'], '3273010212345678');
    expect(parsed['nama_lengkap'], 'RANI ANGGRAENI');
    expect(parsed['alamat'], 'JL MELATI NO 8, RT/RW: 001/002');
  });

  test('corrects common OCR confusions in NIK digits', () {
    final parsed = KtpOcrParser.parse('NIK: 32B3 0102 1234 5678');

    expect(parsed['nik'], '3283010212345678');
  });

  test('does not invent fields when OCR output has no matching labels', () {
    expect(KtpOcrParser.parse('KOTA BANDUNG\nINDONESIA'), isEmpty);
  });
}