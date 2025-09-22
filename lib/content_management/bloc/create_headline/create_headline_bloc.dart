import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

part 'create_headline_event.dart';
part 'create_headline_state.dart';

/// A BLoC to manage the state of creating a new headline.
class CreateHeadlineBloc
    extends Bloc<CreateHeadlineEvent, CreateHeadlineState> {
  /// {@macro create_headline_bloc}
  CreateHeadlineBloc({
    required DataRepository<Headline> headlinesRepository,
  }) : _headlinesRepository = headlinesRepository,
       super(const CreateHeadlineState()) {
    on<CreateHeadlineTitleChanged>(_onTitleChanged);
    on<CreateHeadlineExcerptChanged>(_onExcerptChanged);
    on<CreateHeadlineUrlChanged>(_onUrlChanged);
    on<CreateHeadlineImageUrlChanged>(_onImageUrlChanged);
    on<CreateHeadlineSourceChanged>(_onSourceChanged);
    on<CreateHeadlineTopicChanged>(_onTopicChanged);
    on<CreateHeadlineCountryChanged>(_onCountryChanged);
    on<CreateHeadlineSavedAsDraft>(_onSavedAsDraft);
    on<CreateHeadlinePublished>(_onPublished);
  }

  final DataRepository<Headline> _headlinesRepository;

  final _uuid = const Uuid();

  void _onTitleChanged(
    CreateHeadlineTitleChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  void _onExcerptChanged(
    CreateHeadlineExcerptChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    emit(state.copyWith(excerpt: event.excerpt));
  }

  void _onUrlChanged(
    CreateHeadlineUrlChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    emit(state.copyWith(url: event.url));
  }

  void _onImageUrlChanged(
    CreateHeadlineImageUrlChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    emit(state.copyWith(imageUrl: event.imageUrl));
  }

  void _onSourceChanged(
    CreateHeadlineSourceChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    emit(state.copyWith(source: () => event.source));
  }

  void _onTopicChanged(
    CreateHeadlineTopicChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    emit(state.copyWith(topic: () => event.topic));
  }

  void _onCountryChanged(
    CreateHeadlineCountryChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    emit(state.copyWith(eventCountry: () => event.country));
  }

  /// Handles saving the headline as a draft.
  Future<void> _onSavedAsDraft(
    CreateHeadlineSavedAsDraft event,
    Emitter<CreateHeadlineState> emit,
  ) async {
    if (!state.isFormValid) {
      emit(
        state.copyWith(
          status: CreateHeadlineStatus.failure,
          exception: const InvalidInputException(
            'Form is not valid. Please complete all required fields.',
          ),
        ),
      );
      return;
    }

    emit(state.copyWith(status: CreateHeadlineStatus.submitting));
    try {
      final now = DateTime.now();
      final newHeadline = Headline(
        id: _uuid.v4(),
        title: state.title,
        excerpt: state.excerpt,
        url: state.url,
        imageUrl: state.imageUrl,
        source: state.source!,
        eventCountry: state.eventCountry!,
        topic: state.topic!,
        createdAt: now,
        updatedAt: now,
        status: ContentStatus.draft,
      );

      await _headlinesRepository.create(item: newHeadline);
      emit(
        state.copyWith(
          status: CreateHeadlineStatus.success,
          createdHeadline: newHeadline,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: CreateHeadlineStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateHeadlineStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  /// Handles publishing the headline.
  Future<void> _onPublished(
    CreateHeadlinePublished event,
    Emitter<CreateHeadlineState> emit,
  ) async {
    if (!state.isFormValid) {
      emit(
        state.copyWith(
          status: CreateHeadlineStatus.failure,
          exception: const InvalidInputException(
            'Form is not valid. Please complete all required fields.',
          ),
        ),
      );
      return;
    }

    emit(state.copyWith(status: CreateHeadlineStatus.submitting));
    try {
      final now = DateTime.now();
      final newHeadline = Headline(
        id: _uuid.v4(),
        title: state.title,
        excerpt: state.excerpt,
        url: state.url,
        imageUrl: state.imageUrl,
        source: state.source!,
        eventCountry: state.eventCountry!,
        topic: state.topic!,
        createdAt: now,
        updatedAt: now,
        status: ContentStatus.active,
      );

      await _headlinesRepository.create(item: newHeadline);
      emit(
        state.copyWith(
          status: CreateHeadlineStatus.success,
          createdHeadline: newHeadline,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: CreateHeadlineStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateHeadlineStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }
}
