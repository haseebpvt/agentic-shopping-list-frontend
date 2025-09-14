import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:advanced_shopping_list_frontend/core/models/models.dart';
import 'package:advanced_shopping_list_frontend/core/services/services.dart';

part 'shopping_list_event.dart';
part 'shopping_list_state.dart';

class ShoppingListBloc extends Bloc<ShoppingListEvent, ShoppingListState> {
  final ApiService _apiService;

  ShoppingListBloc({required ApiService apiService})
      : _apiService = apiService,
        super(ShoppingListInitial()) {
    on<LoadShoppingList>(_onLoadShoppingList);
    on<RefreshShoppingList>(_onRefreshShoppingList);
    on<MarkItemPurchased>(_onMarkItemPurchased);
    on<InsertData>(_onInsertData);
    on<DeleteShoppingListItem>(_onDeleteShoppingListItem);
  }

  Future<void> _onLoadShoppingList(
    LoadShoppingList event,
    Emitter<ShoppingListState> emit,
  ) async {
    emit(ShoppingListLoading());
    
    try {
      final response = await _apiService.getShoppingList(event.userId);
      
      if (response.success) {
        emit(ShoppingListLoaded(items: response.data));
      } else {
        emit(ShoppingListError(message: response.error ?? 'Unknown error'));
      }
    } catch (e) {
      emit(ShoppingListError(message: e.toString()));
    }
  }

  Future<void> _onRefreshShoppingList(
    RefreshShoppingList event,
    Emitter<ShoppingListState> emit,
  ) async {
    try {
      final response = await _apiService.getShoppingList(event.userId);
      
      if (response.success) {
        emit(ShoppingListLoaded(items: response.data));
      } else {
        emit(ShoppingListError(message: response.error ?? 'Unknown error'));
      }
    } catch (e) {
      emit(ShoppingListError(message: e.toString()));
    }
  }

  Future<void> _onMarkItemPurchased(
    MarkItemPurchased event,
    Emitter<ShoppingListState> emit,
  ) async {
    final currentState = state;
    if (currentState is ShoppingListLoaded) {
      // Show updating state
      emit(ShoppingListItemUpdating(
        items: currentState.items,
        updatingItemId: event.itemId,
      ));

      try {
        // Call the API to mark item as purchased
        await _apiService.markItemPurchased(
          event.userId,
          event.itemId,
          event.isPurchased,
        );

        // Update the local state immediately for better UX
        final updatedItems = currentState.items.map((item) {
          if (item.id == event.itemId) {
            return item.copyWith(isPurchased: event.isPurchased);
          }
          return item;
        }).toList();

        emit(ShoppingListLoaded(items: updatedItems));
      } catch (e) {
        // Revert to previous state on error
        emit(ShoppingListLoaded(items: currentState.items));
        emit(ShoppingListError(message: 'Failed to update item: ${e.toString()}'));
        
        // Return to loaded state after showing error briefly
        await Future.delayed(const Duration(seconds: 2));
        emit(ShoppingListLoaded(items: currentState.items));
      }
    }
  }

  Future<void> _onInsertData(
    InsertData event,
    Emitter<ShoppingListState> emit,
  ) async {
    final currentState = state;
    if (currentState is ShoppingListLoaded) {
      // Show inserting state
      emit(ShoppingListInserting(items: currentState.items));

      try {
        // Call the API to insert data
        await _apiService.insertData(event.userId, event.userText);

        // Refresh the shopping list after successful insertion
        final response = await _apiService.getShoppingList(event.userId);
        
        if (response.success) {
          emit(ShoppingListLoaded(items: response.data));
        } else {
          emit(ShoppingListError(message: response.error ?? 'Failed to refresh shopping list'));
        }
      } catch (e) {
        // Revert to previous state on error
        emit(ShoppingListLoaded(items: currentState.items));
        emit(ShoppingListError(message: 'Failed to insert data: ${e.toString()}'));
        
        // Return to loaded state after showing error briefly
        await Future.delayed(const Duration(seconds: 2));
        emit(ShoppingListLoaded(items: currentState.items));
      }
    }
  }

  Future<void> _onDeleteShoppingListItem(
    DeleteShoppingListItem event,
    Emitter<ShoppingListState> emit,
  ) async {
    final currentState = state;
    if (currentState is ShoppingListLoaded) {
      // Show updating state
      emit(ShoppingListItemUpdating(
        items: currentState.items,
        updatingItemId: event.itemId,
      ));

      try {
        // Call the API to delete item
        await _apiService.deleteShoppingListItem(event.itemId);

        // Remove the item from the local state immediately for better UX
        final updatedItems = currentState.items.where((item) => item.id != event.itemId).toList();

        emit(ShoppingListLoaded(items: updatedItems));
      } catch (e) {
        // Revert to previous state on error
        emit(ShoppingListLoaded(items: currentState.items));
        emit(ShoppingListError(message: 'Failed to delete item: ${e.toString()}'));
        
        // Return to loaded state after showing error briefly
        await Future.delayed(const Duration(seconds: 2));
        emit(ShoppingListLoaded(items: currentState.items));
      }
    }
  }
}
