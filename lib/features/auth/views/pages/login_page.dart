import 'package:chat_app/core/utils/route/app_routes.dart';
import 'package:chat_app/features/auth/manager/auth_cubit/auth_cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _emailController, _passwordController;
  late FocusNode _emailFocusNode, _passwordFocusNode;
  String? _email, _password;
  bool visibility = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(message.notification!.title!),
            content: Text(message.notification!.body!),
          ),
        );
        print(
            'Message also contained a notification: ${message.notification!.title}');
        print(
            'Message also contained a notification: ${message.notification!.body}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.data}');
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void login(VoidCallback loginFunc) {
    debugPrint('Email: $_email, Password: $_password');
    if (_formKey.currentState!.validate()) {
      loginFunc();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 250,
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Colors.grey.shade200,
                      ),
                      child: CachedNetworkImage(
                        imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT4Lrl0mm2630FI3tWbcm1qMRRDUzjUMxYZ2_NiCXSmWw&s',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator.adaptive(),
                                            ),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                            ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _emailController,
                          onChanged: (value) => _email = value,
                          keyboardType: TextInputType.emailAddress,
                          focusNode: _emailFocusNode,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {
                            _emailFocusNode.unfocus();
                            FocusScope.of(context).requestFocus(_passwordFocusNode);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            } else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                            hintText: 'Enter your email',
                            prefixIcon: Icon(Icons.email),
                            prefixIconColor: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Password',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _passwordController,
                          onChanged: (value) => _password = value,
                          obscureText: !visibility,
                          focusNode: _passwordFocusNode,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () {
                            _passwordFocusNode.unfocus();
                            login(() => cubit.login(
                                _emailController.text, _passwordController.text));
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            prefixIcon: const Icon(Icons.password),
                            prefixIconColor: Colors.grey,
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  visibility = !visibility;
                                });
                              },
                              child: Icon(visibility
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                            suffixIconColor: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot Password?',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: Colors.deepPurpleAccent),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: BlocConsumer<AuthCubit, AuthState>(
                            bloc: cubit,
                            listenWhen: (previous, current) =>
                                current is AuthSuccess || current is AuthError,
                            listener: (context, state) {
                              if (state is AuthSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Login Success!'),
                                  ),
                                );
                                Navigator.of(context).pushNamed(AppRoutes.home);
                              } else if (state is AuthError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.message),
                                  ),
                                );
                              }
                            },
                            buildWhen: (previous, current) =>
                                current is AuthLoading ||
                                current is AuthError ||
                                current is AuthSuccess,
                            builder: (context, state) {
                              if (state is AuthLoading) {
                                return ElevatedButton(
                                  onPressed: null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurpleAccent,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  ),
                                );
                              }
                              return ElevatedButton(
                                onPressed: () => login(() => cubit.login(
                                    _emailController.text, _passwordController.text)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurpleAccent,
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(
                                  'Login',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.grey,
                                ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(AppRoutes.register);
                        },
                        child: Text(
                          'Register',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: Colors.deepPurpleAccent),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}