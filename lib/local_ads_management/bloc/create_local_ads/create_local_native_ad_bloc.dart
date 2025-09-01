import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

part 'create_local_native_ad_event.dart';
part 'create_local_native_ad_state.dart';

/// A BLoC to manage the state of creating a new local native ad.
class CreateLocalNativeAdBloc
    extends Bloc<CreateLocalNativeAdEvent, CreateLocalNativeAdState> {
  /// {@macro create_local_native_ad_bloc}
  CreateLocalNativeAdBloc({
    required DataRepository<LocalAd> localAdsRepository,
  }) : _localAdsRepository = localAdsRepository,
       super(const CreateLocalNativeAdState()) {
    on<CreateLocalNativeAdTitleChanged>(_onTitleChanged);
    on<CreateLocalNativeAdSubtitleChanged>(_onSubtitleChanged);
    on<CreateLocalNativeAdImageUrlChanged>(_onImageUrlChanged);
    on<CreateLocalNativeAdTargetUrlChanged>(_onTargetUrlChanged);
    on<CreateLocalNativeAdStatusChanged>(_onStatusChanged);
    on<CreateLocalNativeAdSubmitted>(_onSubmitted);
  }

  final DataRepository<LocalAd> _localAdsRepository;
  final _uuid = const Uuid();

  void _onTitleChanged(
    CreateLocalNativeAdTitleChanged event,
    Emitter<CreateLocalNativeAdState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  void _onSubtitleChanged(
    CreateLocalNativeAdSubtitleChanged event,
    Emitter<CreateLocalNativeAdState> emit,
  ) {
    emit(state.copyWith(subtitle: event.subtitle));
  }

  void _onImageUrlChanged(
    CreateLocalNativeAdImageUrlChanged event,
    Emitter<CreateLocalNativeAdState> emit,
  ) {
    emit(state.copyWith(imageUrl: event.imageUrl));
  }

  void _onTargetUrlChanged(
    CreateLocalNativeAdTargetUrlChanged event,
    Emitter<CreateLocalNativeAdState> emit,
  ) {
    emit(state.copyWith(targetUrl: event.targetUrl));
  }

  void _onStatusChanged(
    CreateLocalNativeAdStatusChanged event,
    Emitter<CreateLocalNativeAdState> emit,
  ) {
    emit(
      state.copyWith(
        contentStatus: event.status,
        status: CreateLocalNativeAdStatus.initial,
      ),
    );
  }

  Future<void> _onSubmitted(
    CreateLocalNativeAdSubmitted event,
    Emitter<CreateLocalNativeAdState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: CreateLocalNativeAdStatus.submitting));
    try {
      final now = DateTime.now();
      final newLocalNativeAd = LocalNativeAd(
        id: _uuid.v4(),
        title: state.title,
        subtitle: state.subtitle,
        imageUrl: state.imageUrl,
        targetUrl: state.targetUrl,
        createdAt: now,
        updatedAt: now,
        status: state.contentStatus,
      );

      await _localAdsRepository.create(item: newLocalNativeAd);
      emit(
        state.copyWith(
          status: CreateLocalNativeAdStatus.success,
          createdLocalNativeAd: newLocalNativeAd,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          status: CreateLocalNativeAdStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateLocalNativeAdStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }
}
