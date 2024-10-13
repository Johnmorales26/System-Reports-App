import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:system_reports_app/ui/appModule/assets.dart';
import 'package:system_reports_app/ui/homeModule/home_screen.dart';
import 'package:system_reports_app/ui/signInModule/sign_in_view_model.dart';
import 'package:system_reports_app/ui/registerModule/sign_up_screen.dart';
import 'package:toastification/toastification.dart';

import '../style/dimens.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  static const String route = '/SignInScreen';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    Widget view = Container();
    if (screenWidth >= 600) {
      view = Row(
        children: [
          Expanded(
            child: formForSignIn(context),
          ),
          Expanded(
            child: Lottie.asset(Assets.loginAnim),
          ),
        ],
      );

    } else {
      view = formForSignIn(context);
    }
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(Dimens.commonPaddingDefault),
        child: view,
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contact administrator'),
          content: const Text('You can contact the administrator to reset your password'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            )
          ],
        );
      },
    );
  }

  Widget formForSignIn(BuildContext context) {
    final provider = Provider.of<SignInViewModel>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            width: double.infinity,
            child: Card.outlined(
              child: Container(
                padding: const EdgeInsets.all(Dimens.commonPaddingDefault),
                child: Column(
                  children: [
                    Text('Sign In',
                        style: Theme.of(context).textTheme.headlineLarge),
                    Text(
                        'Enter your email and password to access your account.',
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: Dimens.commonPaddingExtraLarge),
                    _Form(),
                    const SizedBox(height: Dimens.commonPaddingDefault),
                    TextButton(onPressed: () => _showAlertDialog(context), child: const Text('Did you forget your password?')),
                    const SizedBox(height: Dimens.commonPaddingDefault),
                    SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                            onPressed: () async {
                              var response = await provider
                                  .signInWithEmailAndPassword();
                              if (response == HomeScreen.route) {
                                Navigator.pushReplacementNamed(
                                    context, response);
                              } else {
                                toastification.show(
                                    context: context,
                                    title: Text(response),
                                    autoCloseDuration: const Duration(seconds: 5),
                                    type: ToastificationType.error
                                );
                              }
                            },
                            child: const Text('Sign In'))),
                    const SizedBox(height: Dimens.commonPaddingDefault),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('You do not have an account?'),
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, SignUpScreen.route);
                              },
                              child: const Text('Sign up'))
                        ])
                  ],
                ),
              ),
            ))
      ],
    );
  }
}

class _Form extends StatefulWidget {
  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<_Form> {
  SignInViewModel? provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SignInViewModel>(context);
    return Column(
      children: [
        TextField(
            controller: provider?.emailController,
            decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email),
                filled: true,),
            keyboardType: TextInputType.emailAddress),
        const SizedBox(height: Dimens.commonPaddingDefault),
        TextField(
          controller: provider?.passwordController,
          decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: GestureDetector(
                onTap: () => provider?.changePassword(),
                child: Icon(provider!.isVisiblePassword
                    ? Icons.visibility
                    : Icons.visibility_off),
              ),
              filled: true),
          obscureText: provider!.isVisiblePassword,
        )
      ],
    );
  }

  @override
  void dispose() {
    provider?.dispose();
    super.dispose();
  }
}
