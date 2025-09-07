import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:advanced_shopping_list_frontend/core/models/models.dart';
import 'package:advanced_shopping_list_frontend/core/services/services.dart';

part 'preference_list_event.dart';
part 'preference_list_state.dart';

class PreferenceListBloc extends Bloc<PreferenceListEvent, PreferenceListState> {
  final ApiService _apiService;
  Timer? _debounceTimer;

  PreferenceListBloc({required ApiService apiService})
      : _apiService = apiService,
        super(PreferenceListInitial()) {
    on<LoadPreferenceList>(_onLoadPreferenceList);
    on<RefreshPreferenceList>(_onRefreshPreferenceList);
    on<SearchPreferences>(_onSearchPreferences);
    on<ClearSearch>(_onClearSearch);
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  Future<void> _onLoadPreferenceList(
    LoadPreferenceList event,
    Emitter<PreferenceListState> emit,
  ) async {
    emit(PreferenceListLoading());
    
    try {
      final response = await _apiService.getPreferenceList(event.userId);
      
      if (response.success) {
        emit(PreferenceListLoaded(
          items: response.data,
          isSearching: false,
          searchQuery: '',
        ));
      } else {
        emit(PreferenceListError(message: response.error ?? 'Unknown error'));
      }
    } catch (e) {
      emit(PreferenceListError(message: e.toString()));
    }
  }

  Future<void> _onRefreshPreferenceList(
    RefreshPreferenceList event,
    Emitter<PreferenceListState> emit,
  ) async {
    try {
      final response = await _apiService.getPreferenceList(event.userId);
      
      if (response.success) {
        emit(PreferenceListLoaded(
          items: response.data,
          isSearching: false,
          searchQuery: '',
        ));
      } else {
        emit(PreferenceListError(message: response.error ?? 'Unknown error'));
      }
    } catch (e) {
      emit(PreferenceListError(message: e.toString()));
    }
  }

  void _onSearchPreferences(
    SearchPreferences event,
    Emitter<PreferenceListState> emit,
  ) {
    // Cancel previous timer
    _debounceTimer?.cancel();
    
    // If search query is empty, load all preferences
    if (event.searchQuery.trim().isEmpty) {
      add(ClearSearch(userId: event.userId));
      return;
    }
    
    // Set searching state immediately
    emit(PreferenceListSearching(searchQuery: event.searchQuery));
    
    // Set up debounce timer
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(event.userId, event.searchQuery, emit);
    });
  }

  Future<void> _performSearch(
    String userId,
    String searchQuery,
    Emitter<PreferenceListState> emit,
  ) async {
    try {
      final response = await _apiService.getPreferenceList(
        userId,
        semanticSearchText: searchQuery,
      );
      
      if (response.success) {
        emit(PreferenceListLoaded(
          items: response.data,
          isSearching: true,
          searchQuery: searchQuery,
        ));
      } else {
        emit(PreferenceListError(message: response.error ?? 'Search failed'));
      }
    } catch (e) {
      emit(PreferenceListError(message: e.toString()));
    }
  }

  void _onClearSearch(
    ClearSearch event,
    Emitter<PreferenceListState> emit,
  ) {
    _debounceTimer?.cancel();
    add(LoadPreferenceList(userId: event.userId));
  }
}
