import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';

part 'update_local_video_ad_event.dart';
part 'update_local_video_ad_state.dart';

/// A BLoC to manage the state of updating an existing local video ad.
class UpdateLocalVideoAdBloc
    extends Bloc<UpdateLocalVideoAdEvent, UpdateLocalVideoAdState> {
  /// {@macro update_local_video_ad_bloc}
  UpdateLocalVideoAdBloc({
    required DataRepository<LocalAd> localAdsRepository,
    required String id,
  })  : _localAdsRepository = localAdsRepository,
        _id = id,
        super(const UpdateLocalVideoAdState()) {
    on<UpdateLocalVideoAdLoaded>(_onLoaded);
    on<UpdateLocalVideoAdVideoUrlChanged>(_onVideoUrlChanged);
    on<UpdateLocalVideoAdTargetUrlChanged>(_onTargetUrlChanged);
    on<UpdateLocalVideoAdStatusChanged>(_onStatusChanged);
    on<UpdateLocalVideoAdSubmitted>(_onSubmitted);

    add(UpdateLocalVideoAdLoaded(_id));
  }

  final DataRepository<LocalAd> _localAdsRepository;
  final String _id;

  Future<void> _onLoaded(
    UpdateLocalVideoAdLoaded event,
    Emitter<UpdateLocalVideoAdState> emit,
  ) async {
    emit(state.copyWith(status: UpdateLocalVideoAdStatus.loading));
    try {
      final localVideoAd =
          await _localAdsRepository.read(id: event.id) as LocalVideoAd;
      emit(
        state.copyWith(
          status: UpdateLocalVideoAdStatus.initial,
          initialAd: localVideoAd,
          videoUrl: localVideoAd.videoUrl,
          targetUrl: localVideoAd.targetUrl,
          contentStatus: localVideoAd.status,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: UpdateLocalVideoAdStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: UpdateLocalVideoAdStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  void _onVideoUrlChanged(
    UpdateLocalVideoAdVideoUrlChanged event,
    Emitter<UpdateLocalVideoAdState> emit,
  ) {
    emit(state.copyWith(videoUrl: event.videoUrl));
  }

  void _onTargetUrlChanged(
    UpdateLocalVideoAdTargetUrlChanged event,
    Emitter<UpdateLocalVideoAdState> emit,
  ) {
    emit(state.copyWith(targetUrl: event.targetUrl));
  }

  void _onStatusChanged(
    UpdateLocalVideoAdStatusChanged event,
    Emitter<UpdateLocalVideoAdState> emit,
  ) {
    emit(state.copyWith(contentStatus: event.status));
  }

  Future<void> _onSubmitted(
    UpdateLocalVideoAdSubmitted event,
    Emitter<UpdateLocalVideoAdState> emit,
  ) async {
    if (!state.isFormValid || !state.isDirty) return;

    emit(state.copyWith(status: UpdateLocalVideoAdStatus.submitting));
    try {
      final now = DateTime.now();
      final updatedLocalVideoAd = state.initialAd!.copyWith(
        videoUrl: state.videoUrl,
        targetUrl: state.targetUrl,
        updatedAt: now,
        status: state.contentStatus,
      );

      await _localAdsRepository.update(
        id: _id,
        item: updatedLocalVideoAd,
      );
      emit(
        state.copyWith(
          status: UpdateLocalVideoAdStatus.success,
          updatedAd: updatedLocalVideoAd,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: UpdateLocalVideoAdStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: UpdateLocalVideoAdStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }
}
