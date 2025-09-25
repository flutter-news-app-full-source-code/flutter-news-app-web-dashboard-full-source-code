import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';

part 'update_local_banner_ad_event.dart';
part 'update_local_banner_ad_state.dart';

/// A BLoC to manage the state of updating an existing local banner ad.
class UpdateLocalBannerAdBloc
    extends Bloc<UpdateLocalBannerAdEvent, UpdateLocalBannerAdState> {
  /// {@macro update_local_banner_ad_bloc}
  UpdateLocalBannerAdBloc({
    required DataRepository<LocalAd> localAdsRepository,
    required String id,
  }) : _localAdsRepository = localAdsRepository,
       _id = id,
       super(const UpdateLocalBannerAdState()) {
    on<UpdateLocalBannerAdLoaded>(_onLoaded);
    on<UpdateLocalBannerAdImageUrlChanged>(_onImageUrlChanged);
    on<UpdateLocalBannerAdTargetUrlChanged>(_onTargetUrlChanged);
    on<UpdateLocalBannerAdSubmitted>(_onSubmitted);

    add(UpdateLocalBannerAdLoaded(_id));
  }

  final DataRepository<LocalAd> _localAdsRepository;
  final String _id;

  Future<void> _onLoaded(
    UpdateLocalBannerAdLoaded event,
    Emitter<UpdateLocalBannerAdState> emit,
  ) async {
    emit(state.copyWith(status: UpdateLocalBannerAdStatus.loading));
    try {
      final localBannerAd =
          await _localAdsRepository.read(id: event.id) as LocalBannerAd;
      emit(
        state.copyWith(
          status: UpdateLocalBannerAdStatus.initial,
          initialAd: localBannerAd,
          imageUrl: localBannerAd.imageUrl,
          targetUrl: localBannerAd.targetUrl,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(status: UpdateLocalBannerAdStatus.failure, exception: e),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: UpdateLocalBannerAdStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  void _onImageUrlChanged(
    UpdateLocalBannerAdImageUrlChanged event,
    Emitter<UpdateLocalBannerAdState> emit,
  ) {
    emit(state.copyWith(imageUrl: event.imageUrl));
  }

  void _onTargetUrlChanged(
    UpdateLocalBannerAdTargetUrlChanged event,
    Emitter<UpdateLocalBannerAdState> emit,
  ) {
    emit(state.copyWith(targetUrl: event.targetUrl));
  }

  Future<void> _onSubmitted(
    UpdateLocalBannerAdSubmitted event,
    Emitter<UpdateLocalBannerAdState> emit,
  ) async {
    if (!state.isFormValid || !state.isDirty) return;

    emit(state.copyWith(status: UpdateLocalBannerAdStatus.submitting));
    try {
      final now = DateTime.now();
      final updatedLocalBannerAd = state.initialAd!.copyWith(
        imageUrl: state.imageUrl,
        targetUrl: state.targetUrl,
        updatedAt: now,
        status: state.initialAd!.status,
      );

      await _localAdsRepository.update(
        id: _id,
        item: updatedLocalBannerAd,
      );
      emit(
        state.copyWith(
          status: UpdateLocalBannerAdStatus.success,
          updatedAd: updatedLocalBannerAd,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(status: UpdateLocalBannerAdStatus.failure, exception: e),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: UpdateLocalBannerAdStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }
}
