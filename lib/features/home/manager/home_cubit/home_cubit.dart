import 'package:chat_app/core/models/user_data.dart';
import 'package:chat_app/core/services/user_services.dart';
import 'package:chat_app/features/auth/services/auth_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  //final _userServices = UserServices();
  final AuthServices _authServices = AuthServicesImpl();

  Future<void> getHomeData() async {
    emit(HomeLoading());
    try {
      final users = await _authServices.getUsers();
      final currentUser = await _authServices.getUser();
      final user = await _authServices.getCurrentUser(currentUser!.uid); 
      emit(HomeLoaded(user, users));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
 
}