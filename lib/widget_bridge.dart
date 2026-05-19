import 'package:flutter/services.dart';

class GroveWidgetBridge {
  GroveWidgetBridge._();
  static final GroveWidgetBridge instance = GroveWidgetBridge._();

  static const _channel = MethodChannel('com.grove.app/widgets');

  Future<void> requestUpdate() async {
    try {
      await _channel.invokeMethod<void>('updateWidgets');
    } on MissingPluginException {
      
    } catch (e) {
    }
  }
}
