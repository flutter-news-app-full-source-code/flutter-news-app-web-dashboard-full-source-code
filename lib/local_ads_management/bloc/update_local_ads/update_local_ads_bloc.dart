import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'update_local_ads_event.dart';
part 'update_local_ads_state.dart';

class UpdateLocalAdsBloc
    extends Bloc<UpdateLocalAdsEvent, UpdateLocalAdsState> {
  UpdateLocalAdsBloc() : super(UpdateLocalAdsInitial()) {
    on<UpdateLocalAdsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
