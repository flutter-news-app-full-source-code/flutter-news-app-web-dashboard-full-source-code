part of 'update_local_ads_bloc.dart';

sealed class UpdateLocalAdsState extends Equatable {
  const UpdateLocalAdsState();

  @override
  List<Object> get props => [];
}

final class UpdateLocalAdsInitial extends UpdateLocalAdsState {}
