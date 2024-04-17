import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/core/utils/route/app_routes.dart';
import 'package:chat_app/features/auth/manager/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {

    late final GlobalKey<FormState> _formKey;
    late final TextEditingController _userNameController, _emailController, _passwordController;
    late FocusNode _userNameFocusNode, _emailFocusNode, _passwordFocusNode;
    bool visibility = false;

  @override
  void initState(){
    _formKey = GlobalKey<FormState>();

    _userNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
   
    _userNameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose(){
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
   Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      await BlocProvider.of<AuthCubit>(context).register(
        _emailController.text,
        _passwordController.text,
        _userNameController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  const SizedBox(height: 24.0,),
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
                  const SizedBox(height: 30.0,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Username',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10.0,),
                        TextFormField(
                          controller: _userNameController,
                          keyboardType: TextInputType.name,
                          focusNode: _userNameFocusNode,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: (){
                            _userNameFocusNode.unfocus();
                            FocusScope.of(context).requestFocus(_emailFocusNode);
                          },
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'Please enter your username';
                            }else if(value.length < 3){
                              return 'Username must be at least 3 characters';
                            }else{
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Create your username',
                            prefixIcon: const Icon(Icons.person_outline),
                            prefixIconColor:  _userNameController.text.isNotEmpty ? Colors.deepPurpleAccent : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 30.0,),
                        Text(
                          'Email',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10.0,),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          focusNode: _emailFocusNode,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: (){
                            _emailFocusNode.unfocus();
                            FocusScope.of(context).requestFocus(_passwordFocusNode);
                          },
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'Please enter your email';
                            }else if(!value.contains('@')){
                              return 'Please enter a valid email';
                            }else{
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Create your email',
                            prefixIcon:  const Icon(Icons.email),
                            prefixIconColor: _emailController.text.isNotEmpty ? Colors.deepPurpleAccent : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 30.0,),
                        Text(
                          'Password',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10.0,),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !visibility,
                          focusNode: _passwordFocusNode,
                          onEditingComplete: () {
                            _passwordFocusNode.unfocus();
                            register();
                          },
                          decoration: InputDecoration(
                            hintText: 'Create your password',
                            prefixIcon: const Icon(Icons.password),
                            prefixIconColor: _passwordController.text.isNotEmpty ? Colors.deepPurpleAccent : Colors.grey,
                            suffixIcon: InkWell(
                              onTap: (){
                                setState(() {
                                  visibility = !visibility;
                                });
                              },
                              child: Icon(
                                visibility == true 
                                ? Icons.visibility_off
                                : Icons.visibility
                              ),
                            ),
                            suffixIconColor: Colors.grey,
                          ),
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'Please enter your password';
                            }else if(value.length<6){
                              return 'Password must be at least 6 characters';
                            }else{
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 24.0,),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: BlocConsumer<AuthCubit, AuthState>(
                            bloc: BlocProvider.of<AuthCubit>(context),
                              listenWhen: (previous, current) =>
                                  current is AuthSuccess || current is AuthError,
                              listener: (context, state) {
                                if (state is AuthSuccess) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Register Success!'),
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
                                  current is AuthLoading || current is AuthError,
                              builder: (context, state) {
                              if (state is AuthLoading) {
                                  return ElevatedButton(
                                    onPressed: null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:Colors.deepPurpleAccent,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator.adaptive(),
                                    ),
                                  );
                                }
                              return ElevatedButton(
                                onPressed: register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurpleAccent,
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(
                                  'Create Account',
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
                        const SizedBox(height: 16.0,),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Have an account?',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      TextButton(
                        onPressed: (){
                          Navigator.of(context).pushNamed(AppRoutes.login);
                        }, 
                        child: Text(
                          'Login',
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}