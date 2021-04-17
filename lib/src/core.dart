import 'dart:async';

import 'package:flutter/services.dart';

/// 原生平台方法触发回调
typedef dynamic FMethodCallHandler(dynamic arguments);

class FMethodChannel {
  /// 全局通道
  static final FMethodChannel global = _FGlobalMethodChannel();

  final MethodChannel _methodChannel;
  final Map<String, FMethodCallHandler> _mapCallHandler = {};

  FMethodChannel(String name)
      : assert(name.isNotEmpty),
        this._methodChannel = MethodChannel('flutter.fanwe.com/' + name) {
    _methodChannel.setMethodCallHandler(_onMethodCall);
  }

  /// 原生平台方法触发回调
  Future<dynamic> _onMethodCall(MethodCall call) async {
    final FMethodCallHandler? handler = _mapCallHandler[call.method];
    return handler == null ? null : handler(call.arguments);
  }

  /// 监听原生平台方法
  void subscribe(String method, FMethodCallHandler handler) {
    assert(method.isNotEmpty);
    _mapCallHandler[method] = handler;
  }

  /// 取消监听原生平台方法
  void unsubscribe(String method) {
    assert(method.isNotEmpty);
    _mapCallHandler.remove(method);
  }

  /// 调用原生平台方法
  Future<T?> invokeMethod<T>(String method, [dynamic arguments]) {
    assert(method.isNotEmpty);
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
