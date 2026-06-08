import 'package:flutter/material.dart';
import 'package:use_me/app/app_initialize.dart';
import 'flavors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  F.appFlavor = Flavor.macchiato;
  await appInitialize();
}
