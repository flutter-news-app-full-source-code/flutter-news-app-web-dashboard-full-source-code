part of 'archived_headlines_bloc.dart';

sealed class ArchivedHeadlinesState extends Equatable {
  const ArchivedHeadlinesState();
  
  @override
  List<Object> get props => [];
}

final class ArchivedHeadlinesInitial extends ArchivedHeadlinesState {}
