// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:digiktp/app/data/providers/api_provider.dart';
import 'package:digiktp/app/modules/nfc_scan/nfc_scan_controller.dart';
import 'package:digiktp/app/modules/nfc_scan/views/nfc_scan_view.dart';

void main() {
  testWidgets('NFC flow fits a narrow viewport', (WidgetTester tester) async {
    await Supabase.initialize(
      url: 'https://kocnlqtyfffwkfmaomcb.supabase.co',
      anonKey: 'sb_publishable_xqV78cO7bMGLZO8CtM52Qw_6Ctx0ga-',
    );
    Get.put(ApiProvider());
    Get.put(NfcScanController());
    final errors = <FlutterErrorDetails>[];
    final previousOnError = FlutterError.onError;
    FlutterError.onError = errors.add;

    try {
      await tester.binding.setSurfaceSize(const Size(320, 568));
      await tester.pumpWidget(
        const GetMaterialApp(home: NfcScanView()),
      );
      await tester.pump();

      expect(
        errors.where((error) =>
            error.exceptionAsString().contains('RenderFlex overflowed')),
        isEmpty,
      );
      expect(find.text('Pemindaian e-KTP'), findsOneWidget);
    } finally {
      FlutterError.onError = previousOnError;
      await tester.binding.setSurfaceSize(null);
      Get.reset();
    }
  });
}
