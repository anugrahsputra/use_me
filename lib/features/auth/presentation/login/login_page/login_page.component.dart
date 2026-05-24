part of 'login_page.dart';

class AppIconHeader extends StatelessWidget {
  const AppIconHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image.asset(, width: 80),
          Text(
            'Login',
            style: TextStyle(fontSize: 30, fontWeight: .bold),
            textAlign: .center,
          ),

          Text(
            'Login to continue',
            style: const TextStyle(fontWeight: .w500),
            textAlign: .center,
          ),
        ],
      ),
    );
  }
}

class LoginFields extends StatelessWidget {
  const LoginFields({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select((LoginBloc bloc) => bloc.state);

    return Column(
      spacing: 16,
      children: [
        FormFieldWidget(
          initialValue: state.email.value,
          onChanged: (value) =>
              context.read<LoginBloc>().add(LoginEvent.onEmailChanged(value)),
          hintText: 'Email',
          keyboardType: .emailAddress,
          prefixIcon: const Icon(Icons.email),
          inputAction: .next,
          errorText:
              (state.hasSubmitted || !state.email.isPure) &&
                  state.email.isNotValid
              ? 'Email invalid'
              : null,
        ),
        FormFieldWidget(
          initialValue: state.password.value,
          onChanged: (value) => context.read<LoginBloc>().add(
            LoginEvent.onPasswordChanged(value),
          ),
          isPassword: true,
          hintText: 'Password',
          keyboardType: .visiblePassword,
          prefixIcon: const Icon(Icons.lock),
          onSubmit: (value) =>
              context.read<LoginBloc>().add(const LoginEvent.onLogin()),
          errorText:
              (state.hasSubmitted || !state.password.isPure) &&
                  state.password.isNotValid
              ? 'Password Jelek'
              : null,
        ),
      ],
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginBloc>().state;
    final isButtonEnabled = state.isValid && state.status != .inProgress;
    return ButtonWidget(
      isEnabled: isButtonEnabled,
      onTap: isButtonEnabled
          ? () => context.read<LoginBloc>().add(const LoginEvent.onLogin())
          : null,
      child: state.status == .inProgress
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          : Text(
              'Login',
              style: TextStyle(
                fontWeight: .w600,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
    );
  }
}

class LoginFooter extends StatelessWidget {
  const LoginFooter({required this.navigator, super.key});

  final AppNavigator navigator;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: .center,
      height: 80,
      width: 1,
      padding: .all(16),
      child: RichText(
        text: TextSpan(
          text: 'Don\'t have account?',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16,
          ),
          children: [
            TextSpan(
              text: 'Why?',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontWeight: .bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => navigator.goToRegister(context),
            ),
          ],
        ),
      ),
    );
  }
}
