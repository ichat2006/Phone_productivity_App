import 'dart:io';
import 'package:app_usage/app_usage.dart';

Future<bool> platformCheckExcessiveUsage() async {
  if (!Platform.isAndroid) return false;
  try {
    final end = DateTime.now();
    final start = end.subtract(const Duration(hours: 1));
    final list = await AppUsage().getAppUsage(start, end);

    var total = Duration.zero;
    for (final info in list) {
      total += info.usage;
    }

    return total > const Duration(minutes: 30);
  } catch (_) {
    return false;
  }
}