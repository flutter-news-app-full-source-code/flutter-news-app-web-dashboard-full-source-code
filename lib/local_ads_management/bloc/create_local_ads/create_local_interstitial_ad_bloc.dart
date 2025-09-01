import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

part 'create_local_interstitial_ad_event.dart';
part 'create_local_interstitial_ad_state.dart';

/// A BLoC to manage the state of creating a new local interstitial ad.
class CreateLocalInterstitialAdBloc
    extends Bloc<CreateLocalInterstitialAdEvent, CreateLocalInterstitialAdState> {
  /// {@macro create_local_interstitial_ad_bloc}
  CreateLocalInterstitialAdBloc({
    required DataRepository<LocalAd> localAdsRepository,
  }) : _localAdsRepository = localAdsRepository,
       super(const CreateLocalInterstitialAdState()) {
    on<CreateLocalInterstitialAdImageUrlChanged>(_onImageUrlChanged);
    on<CreateLocalInterstitialAdTargetUrlChanged>(_onTargetUrlChanged);
    on<CreateLocalInterstitialAdStatusChanged>(_onStatusChanged);
    on<CreateLocalInterstitialAdSubmitted>(_onSubmitted);
  }

  final DataRepository<LocalAd> _localAdsRepository;
  final _uuid = const Uuid();

  void _onImageUrlChanged(
    CreateLocalInterstitialAdImageUrlChanged event,
    Emitter<CreateLocalInterstitialAdState> emit,
  ) {
    emit(state.copyWith(imageUrl: event.imageUrl));
  }

  void _onTargetUrlChanged(
    CreateLocalInterstitialAdTargetUrlChanged event,
    Emitter<CreateLocalInterstitialAdState> emit,
  ) {
    emit(state.copyWith(targetUrl: event.targetUrl));
  }

  void _onStatusChanged(
    CreateLocalInterstitialAdStatusChanged event,
    Emitter<CreateLocalInterstitialAdState> emit,
  ) {
    emit(
      state.copyWith(
        contentStatus: event.status,
        status: CreateLocalInterstitialAdStatus.initial,
      ),
    );
  }

  Future<void> _onSubmitted(
    CreateLocalInterstitialAdSubmitted event,
    Emitter<CreateLocalInterstitialAdState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: CreateLocalInterstitialAdStatus.submitting));
    try {
      final now = DateTime.now();
      final newLocalInterstitialAd = LocalInterstitialAd(
        id: _uuid.v4(),
        imageUrl: state.imageUrl,
        targetUrl: state.targetUrl,
        createdAt: now,
        updatedAt: now,
        status: state.contentStatus,
      );

      await _localAdsRepository.create(item: newLocalInterstitialAd);
      emit(
        state.copyWith(
          status: CreateLocalInterstitialAdStatus.success,
          createdLocalInterstitialAd: newLocalInterstitialAd,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          status: CreateLocalInterstitialAdStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateLocalInterstitialAdStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }
}
