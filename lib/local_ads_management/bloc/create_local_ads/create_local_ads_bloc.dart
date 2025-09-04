import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_local_ads_event.dart';
part 'create_local_ads_state.dart';

class CreateLocalAdsBloc
    extends Bloc<CreateLocalAdsEvent, CreateLocalAdsState> {
  CreateLocalAdsBloc() : super(CreateLocalAdsInitial()) {
    on<CreateLocalAdsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
