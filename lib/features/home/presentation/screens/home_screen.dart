import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traver/app/router/routes.dart';
import 'package:traver/core/theme/theme.dart';
import 'package:traver/core/widgets/widgets.dart';
import 'package:traver/features/destination/data/destination_model.dart';
import 'package:traver/features/destination/data/destination_repository.dart';
import 'package:traver/features/home/data/category_model.dart';
import 'package:traver/features/home/data/category_repository.dart';
import 'package:traver/features/home/presentation/widgets/home_header.dart';
import 'package:traver/features/home/presentation/widgets/home_search_bar.dart';
import 'package:traver/features/home/presentation/widgets/section_header.dart';
import 'package:traver/features/wishlist/data/wishlist_repository.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final destinationsAsync = ref.watch(destinationsProvider);
    final wishlist = ref.watch(wishlistProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // 1. Header (Avatar, Greeting, Notification)
              const HomeHeader(),

              const SizedBox(height: 24),

              // 2. Exploration Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Where do you\nwant to explore today?',
                  style: GoogleFonts.urbanist(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 3. Search Bar
              const HomeSearchBar(),

              const SizedBox(height: 28),

              // 4. Choose Category Section
              SectionHeader(
                title: 'Choose Category',
                actionText: 'See All',
                onAction: () => context.push(AppRoutes.categoryPath(_selectedCategoryId ?? 'beach')),
              ),

              const SizedBox(height: 14),

              // Horizontal Category List
              categoriesAsync.when(
                data: (categories) => _buildCategoryList(categories),
                loading: () => _buildCategorySkeleton(),
                error: (_, _) => const SizedBox.shrink(),
              ),

              const SizedBox(height: 28),

              // 5. Favorite Place Section
              SectionHeader(
                title: 'Favorite Place',
                actionText: 'Explore',
                onAction: () => context.push(AppRoutes.search),
              ),

              const SizedBox(height: 14),

              // Horizontal Favorite Places Slider
              destinationsAsync.when(
                data: (destinations) => _buildFavoritePlaces(destinations, wishlist),
                loading: () => _buildFavoritePlacesSkeleton(),
                error: (_, _) => const SizedBox.shrink(),
              ),

              const SizedBox(height: 28),

              // 6. Popular Package Section
              SectionHeader(
                title: 'Popular Package',
                actionText: 'See All',
                onAction: () => context.push(AppRoutes.search),
              ),

              const SizedBox(height: 14),

              // Vertical Popular Package List
              destinationsAsync.when(
                data: (destinations) => _buildPopularPackages(destinations, wishlist),
                loading: () => _buildPopularPackagesSkeleton(),
                error: (_, _) => const SizedBox.shrink(),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // --- Category List ---
  Widget _buildCategoryList(List<CategoryModel> categories) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategoryId == category.id;

          return CategoryChip(
            category: category,
            isSelected: isSelected,
            onTap: () {
              setState(() {
                if (_selectedCategoryId == category.id) {
                  _selectedCategoryId = null;
                } else {
                  _selectedCategoryId = category.id;
                }
              });
            },
          );
        },
      ),
    );
  }

  // --- Favorite Places Horizontal Slider ---
  Widget _buildFavoritePlaces(
    List<DestinationModel> destinations,
    Set<String> wishlist,
  ) {
    // Filter by selected category if any, else prioritize scenic destinations (dest_001, dest_002, etc.)
    var list = destinations;
    if (_selectedCategoryId != null) {
      final filtered = destinations
          .where((d) => d.category.toLowerCase() == _selectedCategoryId!.toLowerCase())
          .toList();
      if (filtered.isNotEmpty) {
        list = filtered;
      }
    }

    // Filter to place destinations (avoid showing resorts in favorite places if we have them)
    final favoriteCards = list.where((d) => !d.name.toLowerCase().contains('resort')).toList();
    final displayList = favoriteCards.isNotEmpty ? favoriteCards : list;

    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: displayList.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final destination = displayList[index];
          final isFav = wishlist.contains(destination.id);

          return DestinationCard(
            destination: destination,
            isFavorite: isFav,
            onFavoriteToggle: () {
              ref.read(wishlistProvider.notifier).toggle(destination.id);
            },
            onTap: () {
              context.push(AppRoutes.destinationDetailPath(destination.id));
            },
          );
        },
      ),
    );
  }

  // --- Popular Packages Vertical List ---
  Widget _buildPopularPackages(
    List<DestinationModel> destinations,
    Set<String> wishlist,
  ) {
    // Filter items for Popular Package (resorts or items flagged isPopular)
    var packages = destinations.where((d) => d.name.toLowerCase().contains('resort') || d.isPopular).toList();

    // Ensure resorts are sorted first as shown in Homepage.png
    packages.sort((a, b) {
      final aIsResort = a.name.toLowerCase().contains('resort');
      final bIsResort = b.name.toLowerCase().contains('resort');
      if (aIsResort && !bIsResort) return -1;
      if (!aIsResort && bIsResort) return 1;
      return 0;
    });

    if (_selectedCategoryId != null) {
      final filtered = packages
          .where((d) => d.category.toLowerCase() == _selectedCategoryId!.toLowerCase())
          .toList();
      if (filtered.isNotEmpty) {
        packages = filtered;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: packages.map((destination) {
          final isFav = wishlist.contains(destination.id);
          return PopularPackageCard(
            destination: destination,
            isFavorite: isFav,
            onFavoriteToggle: () {
              ref.read(wishlistProvider.notifier).toggle(destination.id);
            },
            onTap: () {
              context.push(AppRoutes.destinationDetailPath(destination.id));
            },
          );
        }).toList(),
      ),
    );
  }

  // --- Skeletons for Loading State ---
  Widget _buildCategorySkeleton() {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, _) => Container(
          width: 110,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F3),
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoritePlacesSkeleton() {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 2,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (_, _) => Container(
          width: 186,
          height: 240,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F3),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildPopularPackagesSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(
          2,
          (_) => Container(
            height: 120,
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
