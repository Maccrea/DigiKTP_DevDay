import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/data/services/auth_service.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://kocnlqtyfffwkfmaomcb.supabase.co',
    anonKey: 'MASUKKAN_ANON_KEY_KAMU_DISINI', // Ganti dengan Anon Key dari Dashboard Supabase
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