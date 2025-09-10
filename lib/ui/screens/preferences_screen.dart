import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:advanced_shopping_list_frontend/core/core.dart';
import 'package:advanced_shopping_list_frontend/ui/widgets/widgets.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final String _userId = "8"; // For testing purposes, you can make this dynamic later

  @override
  void initState() {
    super.initState();
    // Load preference list when screen initializes
    context.read<PreferenceListBloc>().add(LoadPreferenceList(userId: _userId));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    // Clear search if active and refresh
    if (_searchController.text.isNotEmpty) {
      _searchController.clear();
      context.read<PreferenceListBloc>().add(ClearSearch(userId: _userId));
    } else {
      context.read<PreferenceListBloc>().add(RefreshPreferenceList(userId: _userId));
    }
  }

  void _onSearchChanged(String query) {
    context.read<PreferenceListBloc>().add(
      SearchPreferences(userId: _userId, searchQuery: query),
    );
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<PreferenceListBloc>().add(ClearSearch(userId: _userId));
  }

  void _editPreference(PreferenceItem item) {
    final bloc = context.read<PreferenceListBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => BlocProvider.value(
        value: bloc,
        child: EditPreferenceBottomSheet(
          item: item,
          userId: _userId,
        ),
      ),
    );
  }

  Widget _buildPreferenceList(List<PreferenceItem> items, bool isSearching, String searchQuery, {int? operationItemId}) {
    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSearching ? Icons.search_off : Icons.psychology_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isSearching 
                        ? 'No preferences found for "$searchQuery"'
                        : 'No preferences available',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isSearching
                        ? 'Try a different search term'
                        : 'Pull down to refresh',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Column(
        children: [
          // Search result info
          if (isSearching)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              child: Text(
                'Found ${items.length} result${items.length == 1 ? '' : 's'} for "$searchQuery"',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          // List
          Expanded(
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isOperationInProgress = operationItemId == item.id;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: Stack(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: const Icon(
                            Icons.psychology,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          item.text,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.3,
                            color: isOperationInProgress ? Colors.grey : null,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '#${item.id}',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.edit,
                              color: Colors.grey.shade400,
                              size: 16,
                            ),
                          ],
                        ),
                        contentPadding: const EdgeInsets.all(16),
                        onTap: isOperationInProgress ? null : () => _editPreference(item),
                      ),
                      // Loading overlay for operation in progress
                      if (isOperationInProgress)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search field
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search preferences...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),
          // Content
          Expanded(
            child: BlocConsumer<PreferenceListBloc, PreferenceListState>(
              listener: (context, state) {
                if (state is PreferenceOperationError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is PreferenceListLoading) {
                  return const PreferenceListShimmer();
                } else if (state is PreferenceListSearching) {
                  return const SearchShimmer();
                } else if (state is PreferenceOperationInProgress) {
                  // Show the list with a loading overlay on the specific item
                  return _buildPreferenceList(state.items, state.isSearching, state.searchQuery, operationItemId: state.itemId);
                } else if (state is PreferenceOperationError) {
                  // Show the list normally (error is handled in listener)
                  return _buildPreferenceList(state.items, state.isSearching, state.searchQuery);
                } else if (state is PreferenceListError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${state.message}',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.read<PreferenceListBloc>().add(
                            LoadPreferenceList(userId: _userId),
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (state is PreferenceListLoaded) {
                  return _buildPreferenceList(state.items, state.isSearching, state.searchQuery);
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
