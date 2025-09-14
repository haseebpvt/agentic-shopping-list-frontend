part of 'preference_list_bloc.dart';

abstract class PreferenceListState extends Equatable {
  const PreferenceListState();

  @override
  List<Object> get props => [];
}

class PreferenceListInitial extends PreferenceListState {}

class PreferenceListLoading extends PreferenceListState {}

class PreferenceListSearching extends PreferenceListState {
  final String searchQuery;

  const PreferenceListSearching({required this.searchQuery});

  @override
  List<Object> get props => [searchQuery];
}

class PreferenceListLoaded extends PreferenceListState {
  final List<PreferenceItem> items;
  final bool isSearching;
  final String searchQuery;

  const PreferenceListLoaded({
    required this.items,
    required this.isSearching,
    required this.searchQuery,
  });

  @override
  List<Object> get props => [items, isSearching, searchQuery];
}

class PreferenceListError extends PreferenceListState {
  final String message;

  const PreferenceListError({required this.message});

  @override
  List<Object> get props => [message];
}

class PreferenceOperationInProgress extends PreferenceListState {
  final List<PreferenceItem> items;
  final bool isSearching;
  final String searchQuery;
  final String operationType; // "update" or "delete"
  final int itemId;

  const PreferenceOperationInProgress({
    required this.items,
    required this.isSearching,
    required this.searchQuery,
    required this.operationType,
    required this.itemId,
  });

  @override
  List<Object> get props => [items, isSearching, searchQuery, operationType, itemId];
}

class PreferenceOperationSuccess extends PreferenceListState {
  final String message;

  const PreferenceOperationSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class PreferenceOperationError extends PreferenceListState {
  final String message;
  final List<PreferenceItem> items;
  final bool isSearching;
  final String searchQuery;

  const PreferenceOperationError({
    required this.message,
    required this.items,
    required this.isSearching,
    required this.searchQuery,
  });

  @override
  List<Object> get props => [message, items, isSearching, searchQuery];
}
