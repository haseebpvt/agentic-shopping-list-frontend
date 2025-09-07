part of 'preference_list_bloc.dart';

abstract class PreferenceListEvent extends Equatable {
  const PreferenceListEvent();

  @override
  List<Object> get props => [];
}

class LoadPreferenceList extends PreferenceListEvent {
  final String userId;

  const LoadPreferenceList({required this.userId});

  @override
  List<Object> get props => [userId];
}

class RefreshPreferenceList extends PreferenceListEvent {
  final String userId;

  const RefreshPreferenceList({required this.userId});

  @override
  List<Object> get props => [userId];
}

class SearchPreferences extends PreferenceListEvent {
  final String userId;
  final String searchQuery;

  const SearchPreferences({
    required this.userId,
    required this.searchQuery,
  });

  @override
  List<Object> get props => [userId, searchQuery];
}

class ClearSearch extends PreferenceListEvent {
  final String userId;

  const ClearSearch({required this.userId});

  @override
  List<Object> get props => [userId];
}
