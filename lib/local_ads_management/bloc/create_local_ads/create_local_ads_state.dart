part of 'create_local_ads_bloc.dart';

sealed class CreateLocalAdsState extends Equatable {
  const CreateLocalAdsState();

  @override
  List<Object> get props => [];
}

final class CreateLocalAdsInitial extends CreateLocalAdsState {}
