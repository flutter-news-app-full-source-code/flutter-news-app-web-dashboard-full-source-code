import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

part 'create_local_banner_ad_event.dart';
part 'create_local_banner_ad_state.dart';

/// A BLoC to manage the state of creating a new local banner ad.
class CreateLocalBannerAdBloc
    extends Bloc<CreateLocalBannerAdEvent, CreateLocalBannerAdState> {
  /// {@macro create_local_banner_ad_bloc}
  CreateLocalBannerAdBloc({
    required DataRepository<LocalAd> localAdsRepository,
  }) : _localAdsRepository = localAdsRepository,
       super(const CreateLocalBannerAdState()) {
    on<CreateLocalBannerAdImageUrlChanged>(_onImageUrlChanged);
    on<CreateLocalBannerAdTargetUrlChanged>(_onTargetUrlChanged);
    on<CreateLocalBannerAdSubmitted>(_onSubmitted);
  }

  final DataRepository<LocalAd> _localAdsRepository;
  final _uuid = const Uuid();

  void _onImageUrlChanged(
    CreateLocalBannerAdImageUrlChanged event,
    Emitter<CreateLocalBannerAdState> emit,
  ) {
    emit(state.copyWith(imageUrl: event.imageUrl));
  }

  void _onTargetUrlChanged(
    CreateLocalBannerAdTargetUrlChanged event,
    Emitter<CreateLocalBannerAdState> emit,
  ) {
    emit(state.copyWith(targetUrl: event.targetUrl));
  }

  Future<void> _onSubmitted(
    CreateLocalBannerAdSubmitted event,
    Emitter<CreateLocalBannerAdState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: CreateLocalBannerAdStatus.submitting));
    try {
      final now = DateTime.now();
      final newLocalBannerAd = LocalBannerAd(
        id: _uuid.v4(),
        imageUrl: state.imageUrl,
        targetUrl: state.targetUrl,
        createdAt: now,
        updatedAt: now,
        status: ContentStatus.active,
      );

      await _localAdsRepository.create(item: newLocalBannerAd);
      emit(
        state.copyWith(
          status: CreateLocalBannerAdStatus.success,
          createdLocalBannerAd: newLocalBannerAd,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          status: CreateLocalBannerAdStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateLocalBannerAdStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }
}
