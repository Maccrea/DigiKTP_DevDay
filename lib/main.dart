import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/data/services/auth_service.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';

const supabaseUrl = 'https://kocnlqtyfffwkfmaomcb.supabase.co';
const supabaseAnonKey = 'sb_publishable_xqV78cO7bMGLZO8CtM52Qw_6Ctx0ga-';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (supabaseAnonKey.isEmpty) {
    throw StateError(
      'SUPABASE_ANON_KEY belum diatur. Jalankan dengan '
      '--dart-define=SUPABASE_ANON_KEY=<anon-key>',
    );
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  
  await GetStorage.init();
  await Get.putAsync(() => AuthService().init());

  runApp(
    GetMaterialApp(
      title: "SmartKTP",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
    ),
  );
}