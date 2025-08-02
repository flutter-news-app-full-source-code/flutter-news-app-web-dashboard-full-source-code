import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'archived_sources_event.dart';
part 'archived_sources_state.dart';

class ArchivedSourcesBloc extends Bloc<ArchivedSourcesEvent, ArchivedSourcesState> {
  ArchivedSourcesBloc() : super(ArchivedSourcesInitial()) {
    on<ArchivedSourcesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
