import 'package:chat_app/core/models/user_data.dart';
import 'package:chat_app/core/utils/route/app_routes.dart';
import 'package:chat_app/features/auth/manager/auth_cubit/auth_cubit.dart';
import 'package:chat_app/features/home/manager/home_cubit/home_cubit.dart';
import 'package:chat_app/features/home/views/widgets/user_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    final cubit = BlocProvider.of<HomeCubit>(context);
    final authCubit = BlocProvider.of<AuthCubit>(context);

    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listenWhen: (previous, current) => current is AuthLoggedOut,
        listener: (context, state) {
          if (state is AuthLoggedOut) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.login);
          }
        },
        child: BlocBuilder<HomeCubit, HomeState>(
          bloc: cubit,
          buildWhen: (previous, current) => 
            current is HomeLoaded ||
            current is HomeLoading ||
            current is HomeError,
          builder: (context, state) {
            if(state is HomeLoading){
              return const Center(
                child:  CircularProgressIndicator.adaptive()
              );
            } else if (state is HomeLoaded){
              final users = state.users;
              final currentUser = state.currentUser;
              return SafeArea(
                child: SingleChildScrollView(
                  //physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                            'Chats',
                            style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.deepPurple[50],
                              ),
                              child: Row(
                                children:[
                                  const Icon(
                                    Icons.add,
                                    color: Colors.deepPurpleAccent,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 2,),
                                  Text(
                                    'Add New',
                                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                      fontWeight: FontWeight.w500,
                                    )
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () async => await authCubit.logout(),
                              icon: const Icon(Icons.logout_outlined),
                            ),
                            const SizedBox(width: 8),
                          ]
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16,left: 16,right: 16),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: TextStyle(color: Colors.grey.shade600),
                            prefixIcon: Icon(Icons.search,color: Colors.grey.shade600, size: 20,),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding: const EdgeInsets.all(8),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Colors.grey.shade100
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'MATCHES',
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4,),
                      const Divider( indent: 20, endIndent: 20,),
                      const SizedBox(height: 6,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: UserListTile(
                          photoUrl: 'https://cdn-icons-png.flaticon.com/512/2352/2352167.png', 
                          name: 'Grouping Chat', 
                          onTapItem: (){
                            Navigator.of(context, rootNavigator: true).pushNamed(AppRoutes.chat);
                          }
                        ),
                      ),
                      const SizedBox(height: 16,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Expanded(
                          child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: users.length,
                                  itemBuilder: (context, index){
                                    final user = users[index];
                                
                                    if(user.id != currentUser.id){
                                      return UserListTile(
                                        photoUrl: user.photoUrl, 
                                        name: user.username,
                                        onTapItem: (){
                                          Navigator.of(context, rootNavigator: true).pushNamed(
                                            AppRoutes.privateChat,
                                            arguments: users[index],
                                          );
                                        }
                                      );
                                    } else{
                                      return const SizedBox.shrink();
                                    }
                                  }
                                ),

                          ),
                        ),
                        const SizedBox(height: 16,),
                    ],
                  ),
                ),
              );
            }else{
              return const SizedBox.shrink();
            }
          }
        ),
      ),
    );
  }
}