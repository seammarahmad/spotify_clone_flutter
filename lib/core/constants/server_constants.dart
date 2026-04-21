import 'dart:io';

class ServerConstant {
  static String serverURL =
  Platform.isAndroid ? 'http://10.0.2.2:5400' : 'http://127.0.0.1:5400';
}