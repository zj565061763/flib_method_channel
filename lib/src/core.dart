import 'package:flutter/services.dart';

const String methodChannelPrefix = 'flutter.fanwe.com/';

abstract class FMethodChannelHandler {
  Future<dynamic> handle(MethodCall methodCall);
}
