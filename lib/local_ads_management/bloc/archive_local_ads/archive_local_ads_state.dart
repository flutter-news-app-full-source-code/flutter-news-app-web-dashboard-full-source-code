part of 'archive_local_ads_bloc.dart';

sealed class ArchiveLocalAdsState extends Equatable {
  const ArchiveLocalAdsState();
  
  @override
  List<Object> get props => [];
}

final class ArchiveLocalAdsInitial extends ArchiveLocalAdsState {}
