import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../nfc_scan_controller.dart';

class StepResultWidget extends GetView<NfcScanController> {
  const StepResultWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - 32.0,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF86EFAC)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFF16A34A),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check, color: Colors.white, size: 14),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'CHIP e-KTP TERVALIDASI',
                                    style: TextStyle(
                                      color: Color(0xFF15803D),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Obx(() => Text(
                                    'UID: ${controller.scannedUid.value.isEmpty ? "E004123456789A" : controller.scannedUid.value}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Color(0xFF0F172A),
                                      fontFamily: 'Monospace',
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'DATA WARGA (DUKCAPIL)',
                                  style: TextStyle(
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDCFCE7),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'TEREGISTRASI',
                                    style: TextStyle(
                                      color: Color(0xFF15803D),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24, color: Color(0xFFF1F5F9)),
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: 64,
                                    height: 76,
                                    color: const Color(0xFFEFF6FF),
                                    child: const Icon(
                                      Icons.person_rounded,
                                      color: Color(0xFF2563EB),
                                      size: 42,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Siti Rahmawati',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'NIK: 3171012345670003',
                                        style: TextStyle(
                                          color: Color(0xFF334155),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'TTL: Jakarta, 12-05-1994',
                                        style: TextStyle(
                                          color: Color(0xFF64748B),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            const SizedBox(height: 12),
                            _buildDetailRow('Status Hubungan', 'Kepala Keluarga'),
                            const SizedBox(height: 8),
                            _buildDetailRow('Alamat e-KTP', 'Jl. Kebon Sirih No. 12'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Container(
                      //   padding: const EdgeInsets.all(14),
                      //   decoration: BoxDecoration(
                      //     color: const Color(0xFFFEFCE8),
                      //     borderRadius: BorderRadius.circular(14),
                      //     border: Border.all(color: const Color(0xFFFEF08A)),
                      //   ),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: const [
                      //       Icon(Icons.warning_amber_rounded, color: Color(0xFFD97706), size: 20),
                      //       SizedBox(width: 10),
                      //       // Expanded(
                      //       //   child: Column(
                      //       //     crossAxisAlignment: CrossAxisAlignment.start,
                      //       //     children: [
                      //       //       Text(
                      //       //         'Data Belum Terdaftar di Posko?',
                      //       //         style: TextStyle(
                      //       //           fontWeight: FontWeight.bold,
                      //       //           fontSize: 12,
                      //       //           color: Color(0xFF854D0E),
                      //       //         ),
                      //       //       ),
                      //       //       SizedBox(height: 2),
                      //       //       Text(
                      //       //         'Jika warga ini membutuhkan registrasi bantuan sosial atau verifikasi khusus posko daerah baru.',
                      //       //         style: TextStyle(
                      //       //           fontSize: 11,
                      //       //           color: Color(0xFFA16207),
                      //       //           height: 1.3,
                      //       //         ),
                      //       //       ),
                      //       //     ],
                      //       //   ),
                      //       // ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                  const Spacer(),

                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () => controller.goToStep(ScanStep.validation),
                            child: const Text(
                              'VERIFIKASI & SIMPAN',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () => controller.goToStep(ScanStep.validation),
                            child: const Text(
                              'DAFTARKAN DATA BARU',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}