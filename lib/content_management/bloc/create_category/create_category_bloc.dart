import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ht_data_repository/ht_data_repository.dart';
import 'package:ht_shared/ht_shared.dart';

part 'create_category_event.dart';
part 'create_category_state.dart';

/// A BLoC to manage the state of creating a new category.
class CreateCategoryBloc
    extends Bloc<CreateCategoryEvent, CreateCategoryState> {
  /// {@macro create_category_bloc}
  CreateCategoryBloc({
    required HtDataRepository<Category> categoriesRepository,
  }) : _categoriesRepository = categoriesRepository,
       super(const CreateCategoryState()) {
    on<CreateCategoryNameChanged>(_onNameChanged);
    on<CreateCategoryDescriptionChanged>(_onDescriptionChanged);
    on<CreateCategoryIconUrlChanged>(_onIconUrlChanged);
    on<CreateCategoryStatusChanged>(_onStatusChanged);
    on<CreateCategorySubmitted>(_onSubmitted);
  }

  final HtDataRepository<Category> _categoriesRepository;

  void _onNameChanged(
    CreateCategoryNameChanged event,
    Emitter<CreateCategoryState> emit,
  ) {
    emit(
      state.copyWith(
        name: event.name,
        status: CreateCategoryStatus.initial,
      ),
    );
  }

  void _onDescriptionChanged(
    CreateCategoryDescriptionChanged event,
    Emitter<CreateCategoryState> emit,
  ) {
    emit(
      state.copyWith(
        description: event.description,
        status: CreateCategoryStatus.initial,
      ),
    );
  }

  void _onIconUrlChanged(
    CreateCategoryIconUrlChanged event,
    Emitter<CreateCategoryState> emit,
  ) {
    emit(
      state.copyWith(
        iconUrl: event.iconUrl,
        status: CreateCategoryStatus.initial,
      ),
    );
  }

  void _onStatusChanged(
    CreateCategoryStatusChanged event,
    Emitter<CreateCategoryState> emit,
  ) {
    emit(
      state.copyWith(
        contentStatus: event.status,
        status: CreateCategoryStatus.initial,
      ),
    );
  }

  Future<void> _onSubmitted(
    CreateCategorySubmitted event,
    Emitter<CreateCategoryState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: CreateCategoryStatus.submitting));
    try {
      final now = DateTime.now();
      final newCategory = Category(
        name: state.name,
        description: state.description.isNotEmpty ? state.description : null,
        iconUrl: state.iconUrl.isNotEmpty ? state.iconUrl : null,
        status: state.contentStatus,
        createdAt: now,
        updatedAt: now,
      );

      await _categoriesRepository.create(item: newCategory);
      emit(
        state.copyWith(
          status: CreateCategoryStatus.success,
          createdCategory: newCategory,
        ),
      );
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          status: CreateCategoryStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateCategoryStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
