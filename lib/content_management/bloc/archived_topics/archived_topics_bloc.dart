import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'archived_topics_event.dart';
part 'archived_topics_state.dart';

class ArchivedTopicsBloc extends Bloc<ArchivedTopicsEvent, ArchivedTopicsState> {
  ArchivedTopicsBloc() : super(ArchivedTopicsInitial()) {
    on<ArchivedTopicsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
