import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';

part 'update_local_native_ad_event.dart';
part 'update_local_native_ad_state.dart';

/// A BLoC to manage the state of updating an existing local native ad.
class UpdateLocalNativeAdBloc
    extends Bloc<UpdateLocalNativeAdEvent, UpdateLocalNativeAdState> {
  /// {@macro update_local_native_ad_bloc}
  UpdateLocalNativeAdBloc({
    required DataRepository<LocalAd> localAdsRepository,
    required String id,
  }) : _localAdsRepository = localAdsRepository,
       _id = id,
       super(const UpdateLocalNativeAdState()) {
    on<UpdateLocalNativeAdLoaded>(_onLoaded);
    on<UpdateLocalNativeAdTitleChanged>(_onTitleChanged);
    on<UpdateLocalNativeAdSubtitleChanged>(_onSubtitleChanged);
    on<UpdateLocalNativeAdImageUrlChanged>(_onImageUrlChanged);
    on<UpdateLocalNativeAdTargetUrlChanged>(_onTargetUrlChanged);
    on<UpdateLocalNativeAdStatusChanged>(_onStatusChanged);
    on<UpdateLocalNativeAdSubmitted>(_onSubmitted);

    add(UpdateLocalNativeAdLoaded(_id));
  }

  final DataRepository<LocalAd> _localAdsRepository;
  final String _id;

  Future<void> _onLoaded(
    UpdateLocalNativeAdLoaded event,
    Emitter<UpdateLocalNativeAdState> emit,
  ) async {
    emit(state.copyWith(status: UpdateLocalNativeAdStatus.loading));
    try {
      final localNativeAd =
          await _localAdsRepository.read(id: event.id) as LocalNativeAd;
      emit(
        state.copyWith(
          status: UpdateLocalNativeAdStatus.initial,
          initialAd: localNativeAd,
          title: localNativeAd.title,
          subtitle: localNativeAd.subtitle,
          imageUrl: localNativeAd.imageUrl,
          targetUrl: localNativeAd.targetUrl,
          contentStatus: localNativeAd.status,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(status: UpdateLocalNativeAdStatus.failure, exception: e),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: UpdateLocalNativeAdStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  void _onTitleChanged(
    UpdateLocalNativeAdTitleChanged event,
    Emitter<UpdateLocalNativeAdState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  void _onSubtitleChanged(
    UpdateLocalNativeAdSubtitleChanged event,
    Emitter<UpdateLocalNativeAdState> emit,
  ) {
    emit(state.copyWith(subtitle: event.subtitle));
  }

  void _onImageUrlChanged(
    UpdateLocalNativeAdImageUrlChanged event,
    Emitter<UpdateLocalNativeAdState> emit,
  ) {
    emit(state.copyWith(imageUrl: event.imageUrl));
  }

  void _onTargetUrlChanged(
    UpdateLocalNativeAdTargetUrlChanged event,
    Emitter<UpdateLocalNativeAdState> emit,
  ) {
    emit(state.copyWith(targetUrl: event.targetUrl));
  }

  void _onStatusChanged(
    UpdateLocalNativeAdStatusChanged event,
    Emitter<UpdateLocalNativeAdState> emit,
  ) {
    emit(state.copyWith(contentStatus: event.status));
  }

  Future<void> _onSubmitted(
    UpdateLocalNativeAdSubmitted event,
    Emitter<UpdateLocalNativeAdState> emit,
  ) async {
    if (!state.isFormValid || !state.isDirty) return;

    emit(state.copyWith(status: UpdateLocalNativeAdStatus.submitting));
    try {
      final now = DateTime.now();
      final updatedLocalNativeAd = state.initialAd!.copyWith(
        title: state.title,
        subtitle: state.subtitle,
        imageUrl: state.imageUrl,
        targetUrl: state.targetUrl,
        updatedAt: now,
        status: state.contentStatus,
      );

      await _localAdsRepository.update(
        id: _id,
        item: updatedLocalNativeAd,
      );
      emit(
        state.copyWith(
          status: UpdateLocalNativeAdStatus.success,
          updatedAd: updatedLocalNativeAd,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(status: UpdateLocalNativeAdStatus.failure, exception: e),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: UpdateLocalNativeAdStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }
}
