import 'dart:async';

import 'package:flutter/services.dart';

typedef dynamic MethodCallHandler(dynamic arguments);

class FMethodChannel {
  static final FMethodChannel global = _FGlobalMethodChannel();

  final MethodChannel _methodChannel;
  final Map<String, MethodCallHandler> _mapCallHandler = {};

  FMethodChannel(String name)
      : assert(name != null && name.isNotEmpty),
        this._methodChannel = MethodChannel('flutter.fanwe.com/' + name) {
    _methodChannel.setMethodCallHandler(_onMethodCall);
  }

  Future<dynamic> _onMethodCall(MethodCall call) async {
    final MethodCallHandler handler = _mapCallHandler[call.method];
    return handler == null ? null : handler(call.arguments);
  }

  /// 设置某个方法的处理对象
  void setHandler(String method, MethodCallHandler handler) {
    assert(method != null && method.isNotEmpty);
    assert(handler != null);
    _mapCallHandler[method] = handler;
  }

  /// 移除某个方法的处理对象
  void removeHandler(String method) {
    assert(method != null && method.isNotEmpty);
    _mapCallHandler.remove(method);
  }

  /// 调用某个方法
  Future<T> invokeMethod<T>(String method, [dynamic arguments]) {
    return _methodChannel.invokeMethod(method, arguments);
  }

  /// 销毁
  void dispose() {
    _mapCallHandler.clear();
    _methodChannel.setMethodCallHandler(null);
  }
}

class _FGlobalMethodChannel extends FMethodChannel {
  _FGlobalMethodChannel() : super('_global_');

  @override
  void dispose() {}
}
