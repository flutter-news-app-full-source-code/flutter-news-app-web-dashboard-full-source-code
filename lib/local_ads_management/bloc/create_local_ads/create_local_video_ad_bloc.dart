import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

part 'create_local_video_ad_event.dart';
part 'create_local_video_ad_state.dart';

/// A BLoC to manage the state of creating a new local video ad.
class CreateLocalVideoAdBloc
    extends Bloc<CreateLocalVideoAdEvent, CreateLocalVideoAdState> {
  /// {@macro create_local_video_ad_bloc}
  CreateLocalVideoAdBloc({
    required DataRepository<LocalAd> localAdsRepository,
  }) : _localAdsRepository = localAdsRepository,
       super(const CreateLocalVideoAdState()) {
    on<CreateLocalVideoAdVideoUrlChanged>(_onVideoUrlChanged);
    on<CreateLocalVideoAdTargetUrlChanged>(_onTargetUrlChanged);
    on<CreateLocalVideoAdSavedAsDraft>(_onSavedAsDraft);
    on<CreateLocalVideoAdPublished>(_onPublished);
  }

  final DataRepository<LocalAd> _localAdsRepository;
  final _uuid = const Uuid();

  void _onVideoUrlChanged(
    CreateLocalVideoAdVideoUrlChanged event,
    Emitter<CreateLocalVideoAdState> emit,
  ) {
    emit(state.copyWith(videoUrl: event.videoUrl));
  }

  void _onTargetUrlChanged(
    CreateLocalVideoAdTargetUrlChanged event,
    Emitter<CreateLocalVideoAdState> emit,
  ) {
    emit(state.copyWith(targetUrl: event.targetUrl));
  }

  /// Handles saving the local video ad as a draft.
  Future<void> _onSavedAsDraft(
    CreateLocalVideoAdSavedAsDraft event,
    Emitter<CreateLocalVideoAdState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: CreateLocalVideoAdStatus.submitting));
    try {
      final now = DateTime.now();
      final newLocalVideoAd = LocalVideoAd(
        id: _uuid.v4(),
        videoUrl: state.videoUrl,
        targetUrl: state.targetUrl,
        createdAt: now,
        updatedAt: now,
        status: ContentStatus.draft,
      );

      await _localAdsRepository.create(item: newLocalVideoAd);
      emit(
        state.copyWith(
          status: CreateLocalVideoAdStatus.success,
          createdLocalVideoAd: newLocalVideoAd,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          status: CreateLocalVideoAdStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateLocalVideoAdStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  /// Handles publishing the local video ad.
  Future<void> _onPublished(
    CreateLocalVideoAdPublished event,
    Emitter<CreateLocalVideoAdState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: CreateLocalVideoAdStatus.submitting));
    try {
      final now = DateTime.now();
      final newLocalVideoAd = LocalVideoAd(
        id: _uuid.v4(),
        videoUrl: state.videoUrl,
        targetUrl: state.targetUrl,
        createdAt: now,
        updatedAt: now,
        status: ContentStatus.active,
      );

      await _localAdsRepository.create(item: newLocalVideoAd);
      emit(
        state.copyWith(
          status: CreateLocalVideoAdStatus.success,
          createdLocalVideoAd: newLocalVideoAd,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          status: CreateLocalVideoAdStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateLocalVideoAdStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }
}
