import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traver/app/router/routes.dart';
import 'package:traver/core/constants/app_constants.dart';
import 'package:traver/core/services/local_storage.dart';
import 'package:traver/core/theme/theme.dart';
import 'package:traver/core/widgets/primary_button.dart';
import '../../data/user_model.dart';
import '../session_provider.dart';

class FavoriteCategoryItem {
  final String id;
  final String name;
  final String imagePath;

  const FavoriteCategoryItem({
    required this.id,
    required this.name,
    required this.imagePath,
  });
}

class FavoritePlacesScreen extends ConsumerStatefulWidget {
  const FavoritePlacesScreen({super.key});

  @override
  ConsumerState<FavoritePlacesScreen> createState() => _FavoritePlacesScreenState();
}

class _FavoritePlacesScreenState extends ConsumerState<FavoritePlacesScreen> {
  static const List<FavoriteCategoryItem> _availableCategories = [
    FavoriteCategoryItem(
      id: 'beach',
      name: 'Beach',
      imagePath: 'assets/images/categories/beach.png',
    ),
    FavoriteCategoryItem(
      id: 'mountain',
      name: 'Mountain',
      imagePath: 'assets/images/categories/mountain.png',
    ),
    FavoriteCategoryItem(
      id: 'forest',
      name: 'Forest',
      imagePath: 'assets/images/categories/forest.png',
    ),
    FavoriteCategoryItem(
      id: 'ocean',
      name: 'Ocean',
      imagePath: 'assets/images/categories/ocean.png',
    ),
    FavoriteCategoryItem(
      id: 'camping',
      name: 'Camping',
      imagePath: 'assets/images/categories/camping.png',
    ),
    FavoriteCategoryItem(
      id: 'fishing',
      name: 'Fishing',
      imagePath: 'assets/images/categories/fishing.png',
    ),
  ];

  // Default selected categories matching Screen 13
  late final Set<String> _selectedCategoryIds;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedCategoryIds = {'mountain', 'forest'};
  }

  void _toggleCategory(String id) {
    setState(() {
      if (_selectedCategoryIds.contains(id)) {
        _selectedCategoryIds.remove(id);
      } else {
        _selectedCategoryIds.add(id);
      }
    });
  }

  Future<void> _handleNext() async {
    setState(() => _isLoading = true);

    final selectedList = _selectedCategoryIds.toList();
    final storage = ref.read(localStorageProvider);

    // 1. Save selected favorites directly in LocalStorage
    await storage.setJson(StorageKeys.favoritePlaces, selectedList);

    // 2. Synchronize with session / user model
    final sessionNotifier = ref.read(sessionProvider.notifier);
    final sessionState = ref.read(sessionProvider);

    if (sessionState.isLoggedIn) {
      await sessionNotifier.updateFavorites(selectedList);
    } else {
      final usersRaw = storage.getJson(StorageKeys.users);
      if (usersRaw is List && usersRaw.isNotEmpty) {
        final lastUserMap = usersRaw.last as Map<String, dynamic>;
        final user = UserModel.fromJson(lastUserMap);
        await sessionNotifier.login(user);
        await sessionNotifier.updateFavorites(selectedList);
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
      // Navigate to Home screen
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Title (Left-aligned, bold)
                      Text(
                        'Where is your favorite\nplace to explore?',
                        style: GoogleFonts.urbanist(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          height: 1.25,
                          letterSpacing: -0.3,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 2x3 Grid of Categories
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.94,
                        ),
                        itemCount: _availableCategories.length,
                        itemBuilder: (context, index) {
                          final item = _availableCategories[index];
                          final isSelected = _selectedCategoryIds.contains(item.id);

                          return GestureDetector(
                            onTap: () => _toggleCategory(item.id),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF0FB880)
                                      : const Color(0xFFF0F0F0),
                                  width: isSelected ? 2.0 : 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // Selected Green Checkmark Badge at top-right
                                  if (isSelected)
                                    Positioned(
                                      top: 12,
                                      right: 12,
                                      child: Container(
                                        width: 22,
                                        height: 22,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF0FB880),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),

                                  // Center Category Icon & Label
                                  Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          item.imagePath,
                                          width: 68,
                                          height: 68,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          item.name,
                                          style: GoogleFonts.urbanist(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom "Next" Button
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: PrimaryButton(
                    text: 'Next',
                    height: 56,
                    borderRadius: BorderRadius.circular(16),
                    isLoading: _isLoading,
                    onPressed: _handleNext,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
