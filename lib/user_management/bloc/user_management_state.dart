part of 'user_management_bloc.dart';

sealed class UserManagementState extends Equatable {
  const UserManagementState();
  
  @override
  List<Object> get props => [];
}

final class UserManagementInitial extends UserManagementState {}
