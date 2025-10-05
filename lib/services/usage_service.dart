// Use stub by default, IO version on native platforms.
import 'usage_service_stub.dart'
if (dart.library.io) 'usage_service_io.dart';

class UsageService {
  static Future<bool> checkExcessiveUsage() => platformCheckExcessiveUsage();
}

