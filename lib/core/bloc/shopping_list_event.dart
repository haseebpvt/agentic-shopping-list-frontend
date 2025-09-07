part of 'shopping_list_bloc.dart';

abstract class ShoppingListEvent extends Equatable {
  const ShoppingListEvent();

  @override
  List<Object> get props => [];
}

class LoadShoppingList extends ShoppingListEvent {
  final String userId;

  const LoadShoppingList({required this.userId});

  @override
  List<Object> get props => [userId];
}

class RefreshShoppingList extends ShoppingListEvent {
  final String userId;

  const RefreshShoppingList({required this.userId});

  @override
  List<Object> get props => [userId];
}
