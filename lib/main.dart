import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grove/providers/grove_model.dart';
import 'package:grove/providers/grove_settings.dart';
import 'package:grove/services/grove_notifications.dart';
import 'package:grove/painters/fractal_tree_painter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GroveNotifications.instance.init();

  final settings = GroveSettings();
  await settings.init(null, null);

  final model = GroveModel();
  await model.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settings),
        ChangeNotifierProvider.value(value: model),
      ],
      child: const GroveApp(),
    ),
  );
}
