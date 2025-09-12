import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:advanced_shopping_list_frontend/core/models/model/local_shopping_list/local_shopping_list.dart';
import 'package:advanced_shopping_list_frontend/core/services/local_shopping_list_service.dart';
import 'package:advanced_shopping_list_frontend/core/services/category_identification_service.dart';
import 'package:advanced_shopping_list_frontend/core/services/api_service.dart';

// Events
abstract class LocalShoppingListEvent extends Equatable {
  const LocalShoppingListEvent();

  @override
  List<Object?> get props => [];
}

class LoadLocalShoppingList extends LocalShoppingListEvent {}

class AddLocalShoppingListItem extends LocalShoppingListEvent {
  final LocalShoppingListItem item;

  const AddLocalShoppingListItem({required this.item});

  @override
  List<Object?> get props => [item];
}

class UpdateLocalShoppingListItem extends LocalShoppingListEvent {
  final LocalShoppingListItem item;

  const UpdateLocalShoppingListItem({required this.item});

  @override
  List<Object?> get props => [item];
}

class DeleteLocalShoppingListItem extends LocalShoppingListEvent {
  final int id;

  const DeleteLocalShoppingListItem({required this.id});

  @override
  List<Object?> get props => [id];
}

class ToggleLocalItemPurchased extends LocalShoppingListEvent {
  final int id;
  final bool isPurchased;

  const ToggleLocalItemPurchased({required this.id, required this.isPurchased});

  @override
  List<Object?> get props => [id, isPurchased];
}

class ClearPurchasedLocalItems extends LocalShoppingListEvent {}

class IdentifyUncategorizedItems extends LocalShoppingListEvent {}


// States
abstract class LocalShoppingListState extends Equatable {
  const LocalShoppingListState();

  @override
  List<Object?> get props => [];
}

class LocalShoppingListInitial extends LocalShoppingListState {}

class LocalShoppingListLoading extends LocalShoppingListState {}

class LocalShoppingListLoaded extends LocalShoppingListState {
  final List<LocalShoppingListItem> items;

  const LocalShoppingListLoaded({required this.items});

  @override
  List<Object?> get props => [items];
}

class LocalShoppingListError extends LocalShoppingListState {
  final String message;

  const LocalShoppingListError({required this.message});

  @override
  List<Object?> get props => [message];
}

class LocalShoppingListItemUpdating extends LocalShoppingListState {
  final List<LocalShoppingListItem> items;
  final int updatingItemId;

  const LocalShoppingListItemUpdating({
    required this.items,
    required this.updatingItemId,
  });

  @override
  List<Object?> get props => [items, updatingItemId];
}

// Bloc
class LocalShoppingListBloc extends Bloc<LocalShoppingListEvent, LocalShoppingListState> {
  final LocalShoppingListService _service;
  late final CategoryIdentificationService _categoryService;

  LocalShoppingListBloc({
    required LocalShoppingListService service,
    required ApiService apiService,
  })  : _service = service,
        super(LocalShoppingListInitial()) {
    // Create category identification service with callback
    _categoryService = CategoryIdentificationService(
      apiService: apiService,
      localService: service,
      onCategoryUpdated: _onCategoryUpdated,
    );
    on<LoadLocalShoppingList>(_onLoadLocalShoppingList);
    on<AddLocalShoppingListItem>(_onAddLocalShoppingListItem);
    on<UpdateLocalShoppingListItem>(_onUpdateLocalShoppingListItem);
    on<DeleteLocalShoppingListItem>(_onDeleteLocalShoppingListItem);
    on<ToggleLocalItemPurchased>(_onToggleLocalItemPurchased);
    on<ClearPurchasedLocalItems>(_onClearPurchasedLocalItems);
    on<IdentifyUncategorizedItems>(_onIdentifyUncategorizedItems);
  }

  /// Callback method for when categories are updated in the background
  void _onCategoryUpdated() {
    add(LoadLocalShoppingList());
  }

  Future<void> _onLoadLocalShoppingList(
    LoadLocalShoppingList event,
    Emitter<LocalShoppingListState> emit,
  ) async {
    try {
      emit(LocalShoppingListLoading());
      final items = await _service.getAllItems();
      emit(LocalShoppingListLoaded(items: items));
    } catch (e) {
      emit(LocalShoppingListError(message: e.toString()));
    }
  }

  Future<void> _onAddLocalShoppingListItem(
    AddLocalShoppingListItem event,
    Emitter<LocalShoppingListState> emit,
  ) async {
    try {
      final insertedItem = await _service.insertItem(event.item);
      final items = await _service.getAllItems();
      emit(LocalShoppingListLoaded(items: items));
      
      // Trigger category identification for new items without categories
      if (insertedItem.categoryId == null) {
        _categoryService.identifyItemCategory(insertedItem);
      }
    } catch (e) {
      emit(LocalShoppingListError(message: e.toString()));
    }
  }

  Future<void> _onUpdateLocalShoppingListItem(
    UpdateLocalShoppingListItem event,
    Emitter<LocalShoppingListState> emit,
  ) async {
    try {
      await _service.updateItem(event.item);
      final items = await _service.getAllItems();
      emit(LocalShoppingListLoaded(items: items));
    } catch (e) {
      emit(LocalShoppingListError(message: e.toString()));
    }
  }

  Future<void> _onDeleteLocalShoppingListItem(
    DeleteLocalShoppingListItem event,
    Emitter<LocalShoppingListState> emit,
  ) async {
    try {
      await _service.deleteItem(event.id);
      final items = await _service.getAllItems();
      emit(LocalShoppingListLoaded(items: items));
    } catch (e) {
      emit(LocalShoppingListError(message: e.toString()));
    }
  }

  Future<void> _onToggleLocalItemPurchased(
    ToggleLocalItemPurchased event,
    Emitter<LocalShoppingListState> emit,
  ) async {
    try {
      if (state is LocalShoppingListLoaded) {
        final currentItems = (state as LocalShoppingListLoaded).items;
        emit(LocalShoppingListItemUpdating(
          items: currentItems,
          updatingItemId: event.id,
        ));
      }

      await _service.togglePurchased(event.id, event.isPurchased);
      final items = await _service.getAllItems();
      emit(LocalShoppingListLoaded(items: items));
    } catch (e) {
      emit(LocalShoppingListError(message: e.toString()));
    }
  }

  Future<void> _onClearPurchasedLocalItems(
    ClearPurchasedLocalItems event,
    Emitter<LocalShoppingListState> emit,
  ) async {
    try {
      await _service.clearPurchasedItems();
      final items = await _service.getAllItems();
      emit(LocalShoppingListLoaded(items: items));
    } catch (e) {
      emit(LocalShoppingListError(message: e.toString()));
    }
  }

  Future<void> _onIdentifyUncategorizedItems(
    IdentifyUncategorizedItems event,
    Emitter<LocalShoppingListState> emit,
  ) async {
    try {
      // Trigger identification for all uncategorized items
      await _categoryService.identifyAllUncategorizedItems();
      // Note: UI will be updated via the callback mechanism when categories are identified
    } catch (e) {
      // Don't emit error state for this background operation
      print("❌ Error identifying uncategorized items: $e");
    }
  }

  @override
  Future<void> close() {
    _categoryService.dispose();
    return super.close();
  }
}
