part of 'local_ads_management_bloc.dart';

sealed class LocalAdsManagementState extends Equatable {
  const LocalAdsManagementState();
  
  @override
  List<Object> get props => [];
}

final class LocalAdsManagementInitial extends LocalAdsManagementState {}
