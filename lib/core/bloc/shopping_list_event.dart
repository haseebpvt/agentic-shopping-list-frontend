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

class MarkItemPurchased extends ShoppingListEvent {
  final String userId;
  final int itemId;
  final bool isPurchased;

  const MarkItemPurchased({
    required this.userId,
    required this.itemId,
    required this.isPurchased,
  });

  @override
  List<Object> get props => [userId, itemId, isPurchased];
}
