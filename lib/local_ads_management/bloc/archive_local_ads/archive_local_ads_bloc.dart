import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'archive_local_ads_event.dart';
part 'archive_local_ads_state.dart';

class ArchiveLocalAdsBloc extends Bloc<ArchiveLocalAdsEvent, ArchiveLocalAdsState> {
  ArchiveLocalAdsBloc() : super(ArchiveLocalAdsInitial()) {
    on<ArchiveLocalAdsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
