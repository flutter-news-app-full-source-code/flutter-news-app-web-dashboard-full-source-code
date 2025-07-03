import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ht_data_repository/ht_data_repository.dart';
import 'package:ht_shared/ht_shared.dart';

part 'edit_category_event.dart';
part 'edit_category_state.dart';

/// A BLoC to manage the state of editing a single category.
class EditCategoryBloc extends Bloc<EditCategoryEvent, EditCategoryState> {
  /// {@macro edit_category_bloc}
  EditCategoryBloc({
    required HtDataRepository<Category> categoriesRepository,
    required String categoryId,
  }) : _categoriesRepository = categoriesRepository,
       _categoryId = categoryId,
       super(const EditCategoryState()) {
    on<EditCategoryLoaded>(_onLoaded);
    on<EditCategoryNameChanged>(_onNameChanged);
    on<EditCategoryDescriptionChanged>(_onDescriptionChanged);
    on<EditCategoryIconUrlChanged>(_onIconUrlChanged);
    on<EditCategoryStatusChanged>(_onStatusChanged);
    on<EditCategorySubmitted>(_onSubmitted);
  }

  final HtDataRepository<Category> _categoriesRepository;
  final String _categoryId;

  Future<void> _onLoaded(
    EditCategoryLoaded event,
    Emitter<EditCategoryState> emit,
  ) async {
    emit(state.copyWith(status: EditCategoryStatus.loading));
    try {
      final category = await _categoriesRepository.read(id: _categoryId);
      emit(
        state.copyWith(
          status: EditCategoryStatus.initial,
          initialCategory: category,
          name: category.name,
          description: category.description ?? '',
          iconUrl: category.iconUrl ?? '',
          contentStatus: category.status,
        ),
      );
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          status: EditCategoryStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EditCategoryStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onNameChanged(
    EditCategoryNameChanged event,
    Emitter<EditCategoryState> emit,
  ) {
    emit(
      state.copyWith(
        name: event.name,
        // Reset status to allow for re-submission after a failure.
        status: EditCategoryStatus.initial,
      ),
    );
  }

  void _onDescriptionChanged(
    EditCategoryDescriptionChanged event,
    Emitter<EditCategoryState> emit,
  ) {
    emit(
      state.copyWith(
        description: event.description,
        status: EditCategoryStatus.initial,
      ),
    );
  }

  void _onIconUrlChanged(
    EditCategoryIconUrlChanged event,
    Emitter<EditCategoryState> emit,
  ) {
    emit(
      state.copyWith(
        iconUrl: event.iconUrl,
        status: EditCategoryStatus.initial,
      ),
    );
  }

  void _onStatusChanged(
    EditCategoryStatusChanged event,
    Emitter<EditCategoryState> emit,
  ) {
    emit(
      state.copyWith(
        contentStatus: event.status,
        status: EditCategoryStatus.initial,
      ),
    );
  }

  Future<void> _onSubmitted(
    EditCategorySubmitted event,
    Emitter<EditCategoryState> emit,
  ) async {
    if (!state.isFormValid) return;

    // Safely access the initial category to prevent null errors.
    final initialCategory = state.initialCategory;
    if (initialCategory == null) {
      emit(
        state.copyWith(
          status: EditCategoryStatus.failure,
          errorMessage: 'Cannot update: Original category data not loaded.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: EditCategoryStatus.submitting));
    try {
      // Use null for empty optional fields, which is cleaner for APIs.
      final updatedCategory = initialCategory.copyWith(
        name: state.name,
        description: state.description.isNotEmpty ? state.description : null,
        iconUrl: state.iconUrl.isNotEmpty ? state.iconUrl : null,
        status: state.contentStatus,
        updatedAt: DateTime.now(),
      );

      await _categoriesRepository.update(
        id: _categoryId,
        item: updatedCategory,
      );
      emit(
        state.copyWith(
          status: EditCategoryStatus.success,
          updatedCategory: updatedCategory,
        ),
      );
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          status: EditCategoryStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EditCategoryStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
