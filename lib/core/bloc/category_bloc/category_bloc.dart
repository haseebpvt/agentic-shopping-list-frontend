import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:advanced_shopping_list_frontend/core/models/model/category/category.dart';
import 'package:advanced_shopping_list_frontend/core/services/api_service.dart';
import 'package:advanced_shopping_list_frontend/core/services/category_service.dart';

// Events
abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadCategories extends CategoryEvent {
  const LoadCategories();
}

class RefreshCategories extends CategoryEvent {
  const RefreshCategories();
}

// States
abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;

  const CategoryLoaded({required this.categories});

  @override
  List<Object> get props => [categories];
}

class CategoryError extends CategoryState {
  final String error;

  const CategoryError({required this.error});

  @override
  List<Object> get props => [error];
}

// Bloc
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final ApiService apiService;
  final CategoryService categoryService;

  CategoryBloc({
    required this.apiService,
    required this.categoryService,
  }) : super(const CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<RefreshCategories>(_onRefreshCategories);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    print("🔄 CategoryBloc: Loading categories...");
    emit(const CategoryLoading());

    try {
      // First, try to load from local database
      print("🔄 CategoryBloc: Checking local database...");
      List<Category> categories = await categoryService.getAllCategories();
      print("🔄 CategoryBloc: Found ${categories.length} local categories");
      
      if (categories.isNotEmpty) {
        print("✅ CategoryBloc: Using local categories");
        emit(CategoryLoaded(categories: categories));
        
        // Load from API in background to update local data
        _loadFromApiInBackground();
      } else {
        // If no local data, load from API
        print("🔄 CategoryBloc: No local data, loading from API...");
        categories = await _loadFromApi();
        print("✅ CategoryBloc: Loaded ${categories.length} categories from API");
        emit(CategoryLoaded(categories: categories));
      }
    } catch (e) {
      print("❌ CategoryBloc: Error loading categories: $e");
      emit(CategoryError(error: e.toString()));
    }
  }

  Future<void> _onRefreshCategories(
    RefreshCategories event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      final categories = await _loadFromApi();
      emit(CategoryLoaded(categories: categories));
    } catch (e) {
      // If refresh fails, try to load from local database
      try {
        final localCategories = await categoryService.getAllCategories();
        if (localCategories.isNotEmpty) {
          emit(CategoryLoaded(categories: localCategories));
        } else {
          emit(CategoryError(error: e.toString()));
        }
      } catch (localError) {
        emit(CategoryError(error: e.toString()));
      }
    }
  }

  Future<List<Category>> _loadFromApi() async {
    print("🌐 CategoryBloc: Calling API service...");
    final response = await apiService.getCategories();
    print("✅ CategoryBloc: API response received with ${response.data.length} categories");
    print("🔄 CategoryBloc: Saving to local database...");
    await categoryService.saveCategories(response.data);
    print("✅ CategoryBloc: Categories saved to local database");
    return response.data;
  }

  Future<void> _loadFromApiInBackground() async {
    try {
      await _loadFromApi();
      // Note: Cannot emit from here as we don't have access to emit outside of event handlers
    } catch (e) {
      // Ignore errors in background updates
      print("Background category update failed: $e");
    }
  }
}
