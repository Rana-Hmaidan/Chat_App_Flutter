import 'package:chat_app/core/models/user_data.dart';
import 'package:chat_app/core/utils/route/app_routes.dart';
import 'package:chat_app/features/auth/views/pages/create_account_page.dart';
import 'package:chat_app/features/auth/views/pages/login_page.dart';
import 'package:chat_app/features/chat/manager/chat_cubit/chat_cubit.dart';
import 'package:chat_app/features/chat/views/pages/chat_page.dart';
import 'package:chat_app/features/chat/views/pages/private_chat_page.dart';
import 'package:chat_app/features/home/manager/home_cubit/home_cubit.dart';
import 'package:chat_app/features/home/views/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context){
              final cubit = HomeCubit();
              cubit.getHomeData();
              return cubit;
            },
            child: const HomePage(),
          ),
          settings: settings,
        );
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) => const CreateAccountPage(),
          settings: settings,
        );
      case AppRoutes.chat:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) {
              final cubit = ChatCubit();
              cubit.getMessages();
              return cubit;
            },
            child: const ChatPage(),
          ),
          settings: settings,
        );
      case AppRoutes.privateChat:
        final selectedUser = settings.arguments as UserData;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) {
              final cubit = ChatCubit();
              cubit.getChatMessages(selectedUser);
              return cubit;
            },
            child: const PrivateChatPage(),
          ),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => const Scaffold(
                  body: Center(
                    child: Text('No route defined here!'),
                  ),
                ));
    }
  }
}
