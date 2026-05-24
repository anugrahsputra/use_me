import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:use_me/app/app.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/injections.dart';

class AppSplash extends StatefulWidget {
  const AppSplash({super.key});

  @override
  State<AppSplash> createState() => _AppSplashState();
}

class _AppSplashState extends State<AppSplash> {
  final AppNavigator appNavigator = di<AppNavigator>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<AppCubit>(),
      child: BlocListener<AppCubit, AppState>(
        listener: (context, state) {
          state.whenOrNull(
            authenticated: () => appNavigator.goToHome(context),
            unauthenticated: () => appNavigator.goToLogin(context),
          );
        },

        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
