part of 'shopping_list_bloc.dart';

abstract class ShoppingListState extends Equatable {
  const ShoppingListState();

  @override
  List<Object> get props => [];
}

class ShoppingListInitial extends ShoppingListState {}

class ShoppingListLoading extends ShoppingListState {}

class ShoppingListLoaded extends ShoppingListState {
  final List<ShoppingListItem> items;

  const ShoppingListLoaded({required this.items});

  @override
  List<Object> get props => [items];
}

class ShoppingListError extends ShoppingListState {
  final String message;

  const ShoppingListError({required this.message});

  @override
  List<Object> get props => [message];
}

class ShoppingListItemUpdating extends ShoppingListState {
  final List<ShoppingListItem> items;
  final int updatingItemId;

  const ShoppingListItemUpdating({
    required this.items,
    required this.updatingItemId,
  });

  @override
  List<Object> get props => [items, updatingItemId];
}
