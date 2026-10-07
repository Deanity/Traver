import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traver/app/router/routes.dart';
import 'package:traver/core/theme/theme.dart';
import 'package:traver/core/widgets/app_text_field.dart';
import 'package:traver/core/widgets/primary_button.dart';
import '../../data/auth_repository.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String? email;

  const ResetPasswordScreen({
    super.key,
    this.email,
  });

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  bool _obscurePassword1 = true;
  bool _obscurePassword2 = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController(text: 'demo1234@');
    _confirmPasswordController = TextEditingController(text: 'demo1234@');
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    setState(() => _errorMessage = null);

    final pass1 = _passwordController.text;
    final pass2 = _confirmPasswordController.text;

    if (pass1.isEmpty || pass2.isEmpty) {
      setState(() => _errorMessage = 'Please fill in both password fields');
      return;
    }

    if (pass1.length < 8) {
      setState(() => _errorMessage = 'Password must be 8 or more characters long');
      return;
    }

    if (pass1 != pass2) {
      setState(() => _errorMessage = 'Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final email = widget.email ?? 'pristia@gmail.com';
      await ref.read(authRepositoryProvider).updatePassword(
            email: email,
            newPassword: pass1,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Password updated successfully!',
              style: GoogleFonts.urbanist(fontWeight: FontWeight.w600),
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        context.go(AppRoutes.login);
      }
    } on AuthException catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.message);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = 'Failed to update password. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Back button
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.textPrimary,
                              size: 24,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              if (Navigator.of(context).canPop()) {
                                context.pop();
                              } else {
                                context.go(AppRoutes.login);
                              }
                            },
                          ),

                          const SizedBox(height: 36),

                          // Eyebrow subtitle
                          Text(
                            'Forgot Password',
                            style: GoogleFonts.urbanist(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF8A8A8A),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Heading
                          Text(
                            'Create New Password',
                            style: GoogleFonts.urbanist(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              height: 1.2,
                              letterSpacing: -0.3,
                            ),
                          ),

                          const SizedBox(height: 48),

                          // Password Field 1
                          AppTextField(
                            controller: _passwordController,
                            labelText: 'Password',
                            obscureText: _obscurePassword1,
                            borderRadius: BorderRadius.circular(16),
                            fillColor: Colors.transparent,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword1
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFF1A1A1A),
                                size: 22,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword1 = !_obscurePassword1;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Password Field 2
                          AppTextField(
                            controller: _confirmPasswordController,
                            labelText: 'Password',
                            obscureText: _obscurePassword2,
                            borderRadius: BorderRadius.circular(16),
                            fillColor: Colors.transparent,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword2
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFF1A1A1A),
                                size: 22,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword2 = !_obscurePassword2;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Requirement hint
                          Text(
                            'Your password must include at least one symbol and be 8 or more characters long.',
                            style: GoogleFonts.urbanist(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFA0A0A0),
                              height: 1.45,
                            ),
                          ),

                          if (_errorMessage != null) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _errorMessage!,
                                style: GoogleFonts.urbanist(
                                  color: AppColors.error,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom Action Button (docked at navbar location, rises above keyboard)
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
                      text: 'Save',
                      height: 56,
                      borderRadius: BorderRadius.circular(16),
                      isLoading: _isLoading,
                      onPressed: _handleSave,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
