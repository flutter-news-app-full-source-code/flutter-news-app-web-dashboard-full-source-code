part of 'archived_topics_bloc.dart';

sealed class ArchivedTopicsState extends Equatable {
  const ArchivedTopicsState();
  
  @override
  List<Object> get props => [];
}

final class ArchivedTopicsInitial extends ArchivedTopicsState {}
