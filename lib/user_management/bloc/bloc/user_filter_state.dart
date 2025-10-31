part of 'user_filter_bloc.dart';

sealed class UserFilterState extends Equatable {
  const UserFilterState();
  
  @override
  List<Object> get props => [];
}

final class UserFilterInitial extends UserFilterState {}
