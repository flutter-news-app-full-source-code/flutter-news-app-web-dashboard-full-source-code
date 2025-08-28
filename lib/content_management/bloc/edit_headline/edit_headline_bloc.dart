import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'edit_headline_event.dart';
part 'edit_headline_state.dart';

/// A BLoC to manage the state of editing a single headline.
class EditHeadlineBloc extends Bloc<EditHeadlineEvent, EditHeadlineState> {
  /// {@macro edit_headline_bloc}
  EditHeadlineBloc({
    required DataRepository<Headline> headlinesRepository,
    required String headlineId,
  }) : _headlinesRepository = headlinesRepository,
       super(
         EditHeadlineState(
           headlineId: headlineId,
           status: EditHeadlineStatus.loading,
         ),
       ) {
    on<EditHeadlineLoaded>(_onEditHeadlineLoaded);
    on<EditHeadlineTitleChanged>(_onTitleChanged);
    on<EditHeadlineExcerptChanged>(_onExcerptChanged);
    on<EditHeadlineUrlChanged>(_onUrlChanged);
    on<EditHeadlineImageUrlChanged>(_onImageUrlChanged);
    on<EditHeadlineSourceChanged>(_onSourceChanged);
    on<EditHeadlineTopicChanged>(_onTopicChanged);
    on<EditHeadlineCountryChanged>(_onCountryChanged);
    on<EditHeadlineStatusChanged>(_onStatusChanged);
    on<EditHeadlineSubmitted>(_onSubmitted);

    add(const EditHeadlineLoaded());
  }

  final DataRepository<Headline> _headlinesRepository;

  Future<void> _onEditHeadlineLoaded(
    EditHeadlineLoaded event,
    Emitter<EditHeadlineState> emit,
  ) async {
    try {
      final headline = await _headlinesRepository.read(id: state.headlineId);
      emit(
        state.copyWith(
          status: EditHeadlineStatus.initial,
          title: headline.title,
          excerpt: headline.excerpt,
          url: headline.url,
          imageUrl: headline.imageUrl,
          source: () => headline.source,
          topic: () => headline.topic,
          eventCountry: () => headline.eventCountry,
          contentStatus: headline.status,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: EditHeadlineStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: EditHeadlineStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  void _onTitleChanged(
    EditHeadlineTitleChanged event,
    Emitter<EditHeadlineState> emit,
  ) {
    emit(
      state.copyWith(title: event.title, status: EditHeadlineStatus.initial),
    );
  }

  void _onExcerptChanged(
    EditHeadlineExcerptChanged event,
    Emitter<EditHeadlineState> emit,
  ) {
    emit(
      state.copyWith(
        excerpt: event.excerpt,
        status: EditHeadlineStatus.initial,
      ),
    );
  }

  void _onUrlChanged(
    EditHeadlineUrlChanged event,
    Emitter<EditHeadlineState> emit,
  ) {
    emit(state.copyWith(url: event.url, status: EditHeadlineStatus.initial));
  }

  void _onImageUrlChanged(
    EditHeadlineImageUrlChanged event,
    Emitter<EditHeadlineState> emit,
  ) {
    emit(
      state.copyWith(
        imageUrl: event.imageUrl,
        status: EditHeadlineStatus.initial,
      ),
    );
  }

  void _onSourceChanged(
    EditHeadlineSourceChanged event,
    Emitter<EditHeadlineState> emit,
  ) {
    emit(
      state.copyWith(
        source: () => event.source,
        status: EditHeadlineStatus.initial,
      ),
    );
  }

  void _onTopicChanged(
    EditHeadlineTopicChanged event,
    Emitter<EditHeadlineState> emit,
  ) {
    emit(
      state.copyWith(
        topic: () => event.topic,
        status: EditHeadlineStatus.initial,
      ),
    );
  }

  void _onCountryChanged(
    EditHeadlineCountryChanged event,
    Emitter<EditHeadlineState> emit,
  ) {
    emit(
      state.copyWith(
        eventCountry: () => event.country,
        status: EditHeadlineStatus.initial,
      ),
    );
  }

  void _onStatusChanged(
    EditHeadlineStatusChanged event,
    Emitter<EditHeadlineState> emit,
  ) {
    emit(
      state.copyWith(
        contentStatus: event.status,
        status: EditHeadlineStatus.initial,
      ),
    );
  }

  Future<void> _onSubmitted(
    EditHeadlineSubmitted event,
    Emitter<EditHeadlineState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: EditHeadlineStatus.submitting));
    try {
      final originalHeadline =
          await _headlinesRepository.read(id: state.headlineId);
      final updatedHeadline = originalHeadline.copyWith(
        title: state.title,
        excerpt: state.excerpt,
        url: state.url,
        imageUrl: state.imageUrl,
        source: state.source,
        topic: state.topic,
        eventCountry: state.eventCountry,
        status: state.contentStatus,
        updatedAt: DateTime.now(),
      );

      await _headlinesRepository.update(
        id: state.headlineId,
        item: updatedHeadline,
      );
      emit(
        state.copyWith(
          status: EditHeadlineStatus.success,
          updatedHeadline: updatedHeadline,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: EditHeadlineStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: EditHeadlineStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }
}
