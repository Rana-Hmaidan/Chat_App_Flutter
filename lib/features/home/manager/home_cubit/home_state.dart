part of 'home_cubit.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<UserData> users;
  final UserData currentUser;
  HomeLoaded(this.currentUser, this.users);
}

final class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}