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

class InsertData extends ShoppingListEvent {
  final String userId;
  final String userText;

  const InsertData({
    required this.userId,
    required this.userText,
  });

  @override
  List<Object> get props => [userId, userText];
}

class DeleteShoppingListItem extends ShoppingListEvent {
  final String userId;
  final int itemId;

  const DeleteShoppingListItem({
    required this.userId,
    required this.itemId,
  });

  @override
  List<Object> get props => [userId, itemId];
}
