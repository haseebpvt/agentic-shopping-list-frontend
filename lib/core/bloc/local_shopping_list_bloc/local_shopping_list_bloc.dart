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

class LoadLocalShoppingListWithAnimation extends LocalShoppingListEvent {}

class SelectLocalShoppingListItem extends LocalShoppingListEvent {
  final int id;

  const SelectLocalShoppingListItem({required this.id});

  @override
  List<Object?> get props => [id];
}

class DeselectLocalShoppingListItem extends LocalShoppingListEvent {
  final int id;

  const DeselectLocalShoppingListItem({required this.id});

  @override
  List<Object?> get props => [id];
}

class ClearLocalItemSelection extends LocalShoppingListEvent {}

class DeleteSelectedLocalItems extends LocalShoppingListEvent {}


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
  final Set<int> selectedItemIds;

  const LocalShoppingListLoaded({
    required this.items,
    this.selectedItemIds = const {},
  });

  @override
  List<Object?> get props => [items, selectedItemIds];
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
  final Set<int> selectedItemIds;

  const LocalShoppingListItemUpdating({
    required this.items,
    required this.updatingItemId,
    this.selectedItemIds = const {},
  });

  @override
  List<Object?> get props => [items, updatingItemId, selectedItemIds];
}

class LocalShoppingListReordering extends LocalShoppingListState {
  final List<LocalShoppingListItem> oldItems;
  final List<LocalShoppingListItem> newItems;
  final Set<int> selectedItemIds;

  const LocalShoppingListReordering({
    required this.oldItems,
    required this.newItems,
    this.selectedItemIds = const {},
  });

  @override
  List<Object?> get props => [oldItems, newItems, selectedItemIds];
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
    on<LoadLocalShoppingListWithAnimation>(_onLoadLocalShoppingListWithAnimation);
    on<SelectLocalShoppingListItem>(_onSelectLocalShoppingListItem);
    on<DeselectLocalShoppingListItem>(_onDeselectLocalShoppingListItem);
    on<ClearLocalItemSelection>(_onClearLocalItemSelection);
    on<DeleteSelectedLocalItems>(_onDeleteSelectedLocalItems);
  }

  /// Callback method for when categories are updated in the background
  void _onCategoryUpdated() {
    // Use the event system instead of calling emit directly
    add(LoadLocalShoppingListWithAnimation());
  }

  /// Groups items by category name for comparison
  Map<String, List<LocalShoppingListItem>> _groupItemsByCategory(List<LocalShoppingListItem> items) {
    final Map<String, List<LocalShoppingListItem>> groupedItems = {};
    
    for (final item in items) {
      final categoryName = item.categoryName;
      if (groupedItems[categoryName] == null) {
        groupedItems[categoryName] = [];
      }
      groupedItems[categoryName]!.add(item);
    }
    
    return groupedItems;
  }

  /// Checks if there's significant reordering that warrants animation
  bool _hasSignificantReordering(
    Map<String, List<LocalShoppingListItem>> oldGrouping,
    Map<String, List<LocalShoppingListItem>> newGrouping,
  ) {
    // Check if any items changed categories
    for (final item in oldGrouping.values.expand((list) => list)) {
      final oldCategory = item.categoryName;
      
      // Find this item in new grouping
      String? newCategory;
      for (final entry in newGrouping.entries) {
        if (entry.value.any((newItem) => newItem.id == item.id)) {
          newCategory = entry.key;
          break;
        }
      }
      
      if (newCategory != null && newCategory != oldCategory) {
        return true; // Item changed category
      }
    }
    
    return false;
  }

  /// Helper method to get current selected item IDs from state
  Set<int> _getCurrentSelectedIds() {
    final currentState = state;
    if (currentState is LocalShoppingListLoaded) {
      return currentState.selectedItemIds;
    } else if (currentState is LocalShoppingListItemUpdating) {
      return currentState.selectedItemIds;
    } else if (currentState is LocalShoppingListReordering) {
      return currentState.selectedItemIds;
    }
    return {};
  }

  Future<void> _onSelectLocalShoppingListItem(
    SelectLocalShoppingListItem event,
    Emitter<LocalShoppingListState> emit,
  ) async {
    final currentState = state;
    if (currentState is LocalShoppingListLoaded) {
      final newSelectedIds = Set<int>.from(currentState.selectedItemIds)..add(event.id);
      emit(LocalShoppingListLoaded(
        items: currentState.items,
        selectedItemIds: newSelectedIds,
      ));
    }
  }

  Future<void> _onDeselectLocalShoppingListItem(
    DeselectLocalShoppingListItem event,
    Emitter<LocalShoppingListState> emit,
  ) async {
    final currentState = state;
    if (currentState is LocalShoppingListLoaded) {
      final newSelectedIds = Set<int>.from(currentState.selectedItemIds)..remove(event.id);
      emit(LocalShoppingListLoaded(
        items: currentState.items,
        selectedItemIds: newSelectedIds,
      ));
    }
  }

  Future<void> _onClearLocalItemSelection(
    ClearLocalItemSelection event,
    Emitter<LocalShoppingListState> emit,
  ) async {
    final currentState = state;
    if (currentState is LocalShoppingListLoaded) {
      emit(LocalShoppingListLoaded(
        items: currentState.items,
        selectedItemIds: {},
      ));
    }
  }

  Future<void> _onDeleteSelectedLocalItems(
    DeleteSelectedLocalItems event,
    Emitter<LocalShoppingListState> emit,
  ) async {
    try {
      final selectedIds = _getCurrentSelectedIds();
      if (selectedIds.isEmpty) return;

      // Delete all selected items
      for (final id in selectedIds) {
        await _service.deleteItem(id);
      }
      
      // Reload the list and clear selection
      final items = await _service.getAllItems();
      emit(LocalShoppingListLoaded(
        items: items,
        selectedItemIds: {},
      ));
    } catch (e) {
      emit(LocalShoppingListError(message: e.toString()));
    }
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
      final selectedIds = _getCurrentSelectedIds();
      
      if (state is LocalShoppingListLoaded) {
        final currentItems = (state as LocalShoppingListLoaded).items;
        emit(LocalShoppingListItemUpdating(
          items: currentItems,
          updatingItemId: event.id,
          selectedItemIds: selectedIds,
        ));
      }

      await _service.togglePurchased(event.id, event.isPurchased);
      final items = await _service.getAllItems();
      emit(LocalShoppingListLoaded(
        items: items,
        selectedItemIds: selectedIds,
      ));
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

  Future<void> _onLoadLocalShoppingListWithAnimation(
    LoadLocalShoppingListWithAnimation event,
    Emitter<LocalShoppingListState> emit,
  ) async {
    final currentState = state;
    if (currentState is LocalShoppingListLoaded) {
      try {
        final newItems = await _service.getAllItems();
        final selectedIds = currentState.selectedItemIds;
        
        // Only emit reordering state if items actually changed positions
        final oldGrouping = _groupItemsByCategory(currentState.items);
        final newGrouping = _groupItemsByCategory(newItems);
        
        // Check if category grouping has changed
        bool hasReordering = _hasSignificantReordering(oldGrouping, newGrouping);
        
        if (hasReordering) {
          // Emit reordering state to trigger smooth animations
          emit(LocalShoppingListReordering(
            oldItems: currentState.items,
            newItems: newItems,
            selectedItemIds: selectedIds,
          ));
          
          // After a brief delay, emit the final loaded state
          await Future.delayed(const Duration(milliseconds: 600));
          emit(LocalShoppingListLoaded(
            items: newItems,
            selectedItemIds: selectedIds,
          ));
        } else {
          // No significant changes, just update directly
          emit(LocalShoppingListLoaded(
            items: newItems,
            selectedItemIds: selectedIds,
          ));
        }
      } catch (e) {
        // On error, just reload normally
        emit(LocalShoppingListError(message: e.toString()));
      }
    } else {
      // Not in loaded state, just reload normally
      final items = await _service.getAllItems();
      emit(LocalShoppingListLoaded(items: items));
    }
  }

  @override
  Future<void> close() {
    _categoryService.dispose();
    return super.close();
  }
}
