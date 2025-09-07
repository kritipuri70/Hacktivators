import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../services/firestore_service.dart';
import '../../models/user_models.dart';
import '../../widgets/custom_widgets.dart';
import '../therapist/therapist_detail_screen.dart';

class TherapistDirectoryScreen extends StatefulWidget {
  const TherapistDirectoryScreen({super.key});

  @override
  State<TherapistDirectoryScreen> createState() => _TherapistDirectoryScreenState();
}

class _TherapistDirectoryScreenState extends State<TherapistDirectoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSpecialty = '';
  String _sortBy = 'rating';
  List<Therapist> _filteredTherapists = [];

  final List<String> _specialties = [
    'All Specialties',
    'Anxiety & Depression',
    'PTSD & Trauma Therapy',
    'Relationship Counseling',
    'Addiction Recovery',
    'Child & Adolescent Therapy',
  ];

  final List<String> _sortOptions = [
    'rating',
    'experience',
    'name',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFilteredList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateFilteredList() {
    final firestoreService = context.read<FirestoreService>();
    var therapists = firestoreService.therapists;

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      therapists = firestoreService.searchTherapists(_searchController.text);
    }

    // Apply specialty filter
    if (_selectedSpecialty.isNotEmpty && _selectedSpecialty != 'All Specialties') {
      therapists = firestoreService.filterTherapistsBySpecialty(_selectedSpecialty);
    }

    // Apply sorting
    therapists = firestoreService.sortTherapists(therapists, _sortBy);

    setState(() {
      _filteredTherapists = therapists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Therapists'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showFilterBottomSheet,
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          _buildSearchBar(),

          // Filter Chips
          _buildFilterChips(),

          // Therapist List
          Expanded(
            child: _buildTherapistList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => _updateFilteredList(),
        decoration: InputDecoration(
          hintText: 'Search therapists by name, specialty...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            onPressed: () {
              _searchController.clear();
              _updateFilteredList();
            },
            icon: const Icon(Icons.clear),
          )
              : null,
          filled: true,
          fillColor: AppTheme.lightGray,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 300))
        .slideY(begin: -0.2, end: 0);
  }

  Widget _buildFilterChips() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Specialty Filter
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _specialties.map((specialty) {
                  final isSelected = _selectedSpecialty == specialty ||
                      (_selectedSpecialty.isEmpty && specialty == 'All Specialties');

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(specialty),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedSpecialty = specialty == 'All Specialties' ? '' : specialty;
                        });
                        _updateFilteredList();
                      },
                      backgroundColor: AppTheme.lightGray,
                      selectedColor: AppTheme.softBlue,
                      checkmarkColor: AppTheme.primaryBlue,
                      labelStyle: TextStyle(
                        color: isSelected ? AppTheme.primaryBlue : AppTheme.darkGray,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Sort Button
          Container(
            margin: const EdgeInsets.only(left: 8),
            child: PopupMenuButton<String>(
              onSelected: (value) {
                setState(() {
                  _sortBy = value;
                });
                _updateFilteredList();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'rating',
                  child: Row(
                    children: [
                      Icon(Icons.star_outline, size: 20),
                      SizedBox(width: 8),
                      Text('Highest Rated'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'experience',
                  child: Row(
                    children: [
                      Icon(Icons.work_outline, size: 20),
                      SizedBox(width: 8),
                      Text('Most Experience'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'name',
                  child: Row(
                    children: [
                      Icon(Icons.sort_by_alpha, size: 20),
                      SizedBox(width: 8),
                      Text('Alphabetical'),
                    ],
                  ),
                ),
              ],
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.lightGray,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.sort, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      _getSortLabel(_sortBy),
                      style: AppTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 200), duration: const Duration(milliseconds: 300))
        .slideY(begin: -0.1, end: 0);
  }

  Widget _buildTherapistList() {
    return Consumer<FirestoreService>(
      builder: (context, firestoreService, child) {
        if (firestoreService.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
            ),
          );
        }

        if (firestoreService.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppTheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading therapists',
                  style: AppTheme.headingSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  firestoreService.errorMessage!,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.mediumGray,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => firestoreService.fetchTherapists(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (_filteredTherapists.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.lightGray,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.search_off,
                    size: 48,
                    color: AppTheme.mediumGray,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'No therapists found',
                  style: AppTheme.headingSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Try adjusting your search or filters',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.mediumGray,
                  ),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _selectedSpecialty = '';
                      _sortBy = 'rating';
                    });
                    _updateFilteredList();
                  },
                  child: const Text('Clear Filters'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await firestoreService.fetchTherapists();
            _updateFilteredList();
          },
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: _filteredTherapists.length,
            itemBuilder: (context, index) {
              final therapist = _filteredTherapists[index];

              return TherapistCard(
                id: therapist.id,
                name: therapist.name,
                specialty: therapist.specialty,
                qualification: therapist.qualification,
                yearsOfExperience: therapist.yearsOfExperience,
                rating: therapist.rating,
                reviewCount: therapist.reviewCount,
                profileImageUrl: therapist.profileImageUrl,
                isAvailable: therapist.isAvailable,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TherapistDetailScreen(therapist: therapist),
                    ),
                  );
                },
              )
                  .animate()
                  .fadeIn(
                delay: Duration(milliseconds: 100 * index),
                duration: const Duration(milliseconds: 300),
              )
                  .slideX(begin: 0.2, end: 0);
            },
          ),
        );
      },
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter & Sort',
                    style: AppTheme.headingSmall,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'Specialty',
                style: AppTheme.bodyLarge,
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _specialties.map((specialty) {
                  final isSelected = _selectedSpecialty == specialty ||
                      (_selectedSpecialty.isEmpty && specialty == 'All Specialties');

                  return FilterChip(
                    label: Text(specialty),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedSpecialty = specialty == 'All Specialties' ? '' : specialty;
                      });
                      _updateFilteredList();
                    },
                    backgroundColor: AppTheme.lightGray,
                    selectedColor: AppTheme.softBlue,
                    checkmarkColor: AppTheme.primaryBlue,
                    labelStyle: TextStyle(
                      color: isSelected ? AppTheme.primaryBlue : AppTheme.darkGray,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedSpecialty = '';
                          _sortBy = 'rating';
                        });
                        _updateFilteredList();
                        Navigator.pop(context);
                      },
                      child: const Text('Clear All'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),

              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        );
      },
    );
  }

  String _getSortLabel(String sortBy) {
    switch (sortBy) {
      case 'rating':
        return 'Rating';
      case 'experience':
        return 'Experience';
      case 'name':
        return 'Name';
      default:
        return 'Rating';
    }
  }
}