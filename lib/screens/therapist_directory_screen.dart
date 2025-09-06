import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/therapist_provider.dart';
import '../widgets/therapist_card.dart';

class TherapistDirectoryScreen extends StatefulWidget {
  const TherapistDirectoryScreen({super.key});

  @override
  State<TherapistDirectoryScreen> createState() => _TherapistDirectoryScreenState();
}

class _TherapistDirectoryScreenState extends State<TherapistDirectoryScreen> {
  final _searchController = TextEditingController();
  List<String> _selectedFilters = [];
  final List<String> _filterOptions = [
    'Anxiety',
    'Depression',
    'Stress Management',
    'Relationship Counseling',
    'Trauma Therapy',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TherapistProvider>().loadTherapists();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Therapist'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search therapists...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filterOptions.length,
                    itemBuilder: (context, index) {
                      final filter = _filterOptions[index];
                      final isSelected = _selectedFilters.contains(filter);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedFilters.add(filter);
                              } else {
                                _selectedFilters.remove(filter);
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<TherapistProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filteredTherapists = provider.searchTherapists(
                  _searchController.text,
                  _selectedFilters,
                );

                if (filteredTherapists.isEmpty) {
                  return const Center(
                    child: Text('No therapists found'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredTherapists.length,
                  itemBuilder: (context, index) {
                    final therapist = filteredTherapists[index];
                    return TherapistCard(therapist: therapist);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}