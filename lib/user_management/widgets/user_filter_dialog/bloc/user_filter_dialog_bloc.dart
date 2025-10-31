import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_filter_dialog_event.dart';
part 'user_filter_dialog_state.dart';

class UserFilterDialogBloc extends Bloc<UserFilterDialogEvent, UserFilterDialogState> {
  UserFilterDialogBloc() : super(UserFilterDialogInitial()) {
    on<UserFilterDialogEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
