import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:use_me/app/app.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/features/auth/auth.dart';
import 'package:use_me/features/home/home.dart';

final di = GetIt.instance;

Future<void> configureDependencies() async {
  await CoreModule.register(di);
  await AppModule.register(di);
  await AuthModule.register(di);
  await HomeModule.register(di);
}
