part of 'user_filter_dialog_bloc.dart';

sealed class UserFilterDialogState extends Equatable {
  const UserFilterDialogState();
  
  @override
  List<Object> get props => [];
}

final class UserFilterDialogInitial extends UserFilterDialogState {}
