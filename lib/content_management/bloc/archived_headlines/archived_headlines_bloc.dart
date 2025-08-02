import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

part 'archived_headlines_event.dart';
part 'archived_headlines_state.dart';

class ArchivedHeadlinesBloc extends Bloc<ArchivedHeadlinesEvent, ArchivedHeadlinesState> {
  ArchivedHeadlinesBloc() : super(ArchivedHeadlinesInitial()) {
    on<ArchivedHeadlinesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
