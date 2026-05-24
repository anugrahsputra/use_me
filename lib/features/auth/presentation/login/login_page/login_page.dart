import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:logging/logging.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/features/auth/auth.dart';
import 'package:use_me/injections.dart';

part 'login_page.component.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AppNavigator appNavigator = di<AppNavigator>();
  final LoginBloc loginBloc = di<LoginBloc>();
  final Logger log = Logger('Login View');

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => loginBloc,
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                behavior: SnackBarBehavior.floating,
              ),
            );
            context.read<LoginBloc>().add(const OnError());
          } else if (state.status == FormzSubmissionStatus.success) {
            appNavigator.goToHome(context);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: CustomScrollView(
              keyboardDismissBehavior: .onDrag,
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const AppIconHeader(),
                      SizedBox(height: 80),
                      const LoginFields(),
                      const SizedBox(height: 16),
                      const LoginButton(),
                    ]),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  fillOverscroll: true,
                  child: Column(
                    children: [
                      const Spacer(),
                      LoginFooter(navigator: appNavigator),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
