import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:system_reports_app/ui/homeModule/home_screen.dart';
import 'package:system_reports_app/ui/registerModule/sign_up_view_model.dart';
import 'package:system_reports_app/ui/signInModule/sign_in_screen.dart';
import 'package:toastification/toastification.dart';

import '../appModule/assets.dart';
import '../style/dimens.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  static const String route = '/SignUpScreen';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    Widget view = Container();
    if (screenWidth >= 600) {
      view = Row(
        children: [
          Expanded(
            child: formForSignUp(context),
          ),
          Expanded(
            child: Lottie.asset(Assets.loginAnim),
          ),
        ],
      );
    } else {
      view = Center(child: formForSignUp(context));
    }
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(Dimens.commonPaddingDefault),
        child: Center(child: SingleChildScrollView(child: view)),
      ),
    );
  }

  Widget formForSignUp(BuildContext context) {
    final provider = Provider.of<SignUpViewModel>(context);
    return Center(
        child: Column(
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
                    Text('Sign Up',
                        style: Theme.of(context).textTheme.headlineLarge),
                    Text('Enter your details to create a new account.',
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: Dimens.commonPaddingExtraLarge),
                    _Form(),
                    const SizedBox(height: Dimens.commonPaddingDefault),
                    SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                            onPressed: () async {
                              var response =
                                  await provider.signUpWithEmailAndPassword();
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
                            child: const Text('Sign Up'))),
                    const SizedBox(height: Dimens.commonPaddingDefault),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Already have an account?'),
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, SignInScreen.route);
                              },
                              child: const Text('Sign In'))
                        ])
                  ],
                ),
              ),
            ))
      ],
    ));
  }
}

class _Form extends StatefulWidget {
  @override
  State createState() => _FormState();
}

class _FormState extends State<_Form> {
  SignUpViewModel? provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SignUpViewModel>(context);
    return Column(children: [
      TextField(
          controller: provider?.nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            hintText: 'Enter your fullname',
            prefixIcon: Icon(Icons.person),
            filled: true,
          ),
          keyboardType: TextInputType.name),
      const SizedBox(height: Dimens.commonPaddingDefault),
      TextField(
          controller: provider?.emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            hintText: 'Enter your email',
            prefixIcon: Icon(Icons.email),
            filled: true,
          ),
          keyboardType: TextInputType.emailAddress),
      const SizedBox(height: Dimens.commonPaddingDefault),
      TextField(
          controller: provider?.fseController,
          decoration: const InputDecoration(
            labelText: 'FSE Name',
            hintText: 'Enter your fse name',
            prefixIcon: Icon(Icons.person),
            filled: true,
          ),
          keyboardType: TextInputType.emailAddress),
      const SizedBox(height: Dimens.commonPaddingDefault),
      TextField(
        controller: provider?.passwordController,
        decoration: InputDecoration(
          labelText: 'Password',
          hintText: 'Enter your password',
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: GestureDetector(
            onTap: () => provider?.changeVisibilityPassword(),
            child: Icon(provider!.isVisiblePassword
                ? Icons.visibility
                : Icons.visibility_off),
          ),
          filled: true,
        ),
        obscureText: provider!.isVisiblePassword,
      ),
      const SizedBox(height: Dimens.commonPaddingDefault),
      TextField(
        controller: provider?.confirmPasswordController,
        decoration: InputDecoration(
          labelText: 'Confirm Password',
          hintText: 'Enter your password',
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: GestureDetector(
            onTap: () => provider?.changeVisibilityConfirmPassword(),
            child: Icon(provider!.isVisiblePassword
                ? Icons.visibility
                : Icons.visibility_off),
          ),
          filled: true,
        ),
        obscureText: provider!.isVisibleConfirmPassword,
      )
    ]);
  }

  @override
  void dispose() {
    provider?.dispose();
    super.dispose();
  }
}
