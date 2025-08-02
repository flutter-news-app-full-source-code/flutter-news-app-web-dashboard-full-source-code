part of 'archived_sources_bloc.dart';

sealed class ArchivedSourcesState extends Equatable {
  const ArchivedSourcesState();
  
  @override
  List<Object> get props => [];
}

final class ArchivedSourcesInitial extends ArchivedSourcesState {}
