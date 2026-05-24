import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:grove/providers/grove_model.dart';
import 'package:grove/providers/grove_settings.dart';
import 'package:grove/services/grove_notifications.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GroveNotifications.instance.init();

  late ColorScheme? dynamicLight;
  late ColorScheme? dynamicDark;

  dynamicLight = null;
  dynamicDark  = null;

  final settings = GroveSettings();
  await settings.init(dynamicLight, dynamicDark);

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
