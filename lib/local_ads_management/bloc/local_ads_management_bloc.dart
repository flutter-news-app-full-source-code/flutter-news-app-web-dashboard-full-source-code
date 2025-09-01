import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'local_ads_management_event.dart';
part 'local_ads_management_state.dart';

class LocalAdsManagementBloc extends Bloc<LocalAdsManagementEvent, LocalAdsManagementState> {
  LocalAdsManagementBloc() : super(LocalAdsManagementInitial()) {
    on<LocalAdsManagementEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
