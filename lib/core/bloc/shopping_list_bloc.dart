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
}
