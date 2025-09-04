import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';

part 'update_local_interstitial_ad_event.dart';
part 'update_local_interstitial_ad_state.dart';

/// A BLoC to manage the state of updating an existing local interstitial ad.
class UpdateLocalInterstitialAdBloc
    extends
        Bloc<UpdateLocalInterstitialAdEvent, UpdateLocalInterstitialAdState> {
  /// {@macro update_local_interstitial_ad_bloc}
  UpdateLocalInterstitialAdBloc({
    required DataRepository<LocalAd> localAdsRepository,
    required String id,
  }) : _localAdsRepository = localAdsRepository,
       _id = id,
       super(const UpdateLocalInterstitialAdState()) {
    on<UpdateLocalInterstitialAdLoaded>(_onLoaded);
    on<UpdateLocalInterstitialAdImageUrlChanged>(_onImageUrlChanged);
    on<UpdateLocalInterstitialAdTargetUrlChanged>(_onTargetUrlChanged);
    on<UpdateLocalInterstitialAdStatusChanged>(_onStatusChanged);
    on<UpdateLocalInterstitialAdSubmitted>(_onSubmitted);

    add(UpdateLocalInterstitialAdLoaded(_id));
  }

  final DataRepository<LocalAd> _localAdsRepository;
  final String _id;

  Future<void> _onLoaded(
    UpdateLocalInterstitialAdLoaded event,
    Emitter<UpdateLocalInterstitialAdState> emit,
  ) async {
    emit(state.copyWith(status: UpdateLocalInterstitialAdStatus.loading));
    try {
      final localInterstitialAd =
          await _localAdsRepository.read(id: event.id) as LocalInterstitialAd;
      emit(
        state.copyWith(
          status: UpdateLocalInterstitialAdStatus.initial,
          initialAd: localInterstitialAd,
          imageUrl: localInterstitialAd.imageUrl,
          targetUrl: localInterstitialAd.targetUrl,
          contentStatus: localInterstitialAd.status,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          status: UpdateLocalInterstitialAdStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: UpdateLocalInterstitialAdStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  void _onImageUrlChanged(
    UpdateLocalInterstitialAdImageUrlChanged event,
    Emitter<UpdateLocalInterstitialAdState> emit,
  ) {
    emit(state.copyWith(imageUrl: event.imageUrl));
  }

  void _onTargetUrlChanged(
    UpdateLocalInterstitialAdTargetUrlChanged event,
    Emitter<UpdateLocalInterstitialAdState> emit,
  ) {
    emit(state.copyWith(targetUrl: event.targetUrl));
  }

  void _onStatusChanged(
    UpdateLocalInterstitialAdStatusChanged event,
    Emitter<UpdateLocalInterstitialAdState> emit,
  ) {
    emit(state.copyWith(contentStatus: event.status));
  }

  Future<void> _onSubmitted(
    UpdateLocalInterstitialAdSubmitted event,
    Emitter<UpdateLocalInterstitialAdState> emit,
  ) async {
    if (!state.isFormValid || !state.isDirty) return;

    emit(state.copyWith(status: UpdateLocalInterstitialAdStatus.submitting));
    try {
      final now = DateTime.now();
      final updatedLocalInterstitialAd = state.initialAd!.copyWith(
        imageUrl: state.imageUrl,
        targetUrl: state.targetUrl,
        updatedAt: now,
        status: state.contentStatus,
      );

      await _localAdsRepository.update(
        id: _id,
        item: updatedLocalInterstitialAd,
      );
      emit(
        state.copyWith(
          status: UpdateLocalInterstitialAdStatus.success,
          updatedAd: updatedLocalInterstitialAd,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          status: UpdateLocalInterstitialAdStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: UpdateLocalInterstitialAdStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }
}
