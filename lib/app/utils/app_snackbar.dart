import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void show({
    required String message,
    String? title,
    IconData icon = Icons.info_outline_rounded,
    Color backgroundColor = const Color(0xFF1E293B),
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.TOP,
  }) {
    Get.rawSnackbar(
      messageText: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null && title.isNotEmpty) ...[
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      snackPosition: position,
      backgroundColor: backgroundColor,
      borderRadius: 18,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      duration: duration,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static void warning({String? title, required String message}) {
    show(
      message: message,
      title: title,
      icon: Icons.warning_amber_rounded,
      backgroundColor: const Color(0xFFD97706),
    );
  }

  static void error({String? title, required String message}) {
    show(
      message: message,
      title: title,
      icon: Icons.error_outline_rounded,
      backgroundColor: const Color(0xFFDC2626),
      duration: const Duration(seconds: 4),
    );
  }

  static void success({String? title, required String message}) {
    show(
      message: message,
      title: title,
      icon: Icons.check_circle_outline_rounded,
      backgroundColor: const Color(0xFF16A34A),
    );
  }
}
