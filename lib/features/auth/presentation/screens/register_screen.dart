import 'package:flutter/cupertino.dart';
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

class RegisterScreen extends ConsumerStatefulWidget {
  final int initialStep;

  const RegisterScreen({
    super.key,
    this.initialStep = 0,
  });

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late int _currentStep;

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  bool _obscurePassword = true;
  bool _receiveMarketing = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep;
    _firstNameController = TextEditingController(text: 'Pristia');
    _lastNameController = TextEditingController(text: 'Candra');
    _emailController = TextEditingController(text: 'pristia@gmail.com');
    _passwordController = TextEditingController(text: 'demo1234@');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleBack() {
    setState(() => _errorMessage = null);
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      if (Navigator.of(context).canPop()) {
        context.pop();
      } else {
        context.go(AppRoutes.login);
      }
    }
  }

  Future<void> _handleNext() async {
    setState(() => _errorMessage = null);

    if (_currentStep == 0) {
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();

      if (firstName.isEmpty) {
        setState(() => _errorMessage = 'Please enter your first name');
        return;
      }
      if (lastName.isEmpty) {
        setState(() => _errorMessage = 'Please enter your last name');
        return;
      }

      setState(() => _currentStep = 1);
    } else if (_currentStep == 1) {
      final email = _emailController.text.trim();

      if (email.isEmpty) {
        setState(() => _errorMessage = 'Please enter your email');
        return;
      }
      if (!email.contains('@') || !email.contains('.')) {
        setState(() => _errorMessage = 'Please enter a valid email address');
        return;
      }

      setState(() => _currentStep = 2);
    } else if (_currentStep == 2) {
      final password = _passwordController.text;

      if (password.isEmpty) {
        setState(() => _errorMessage = 'Please enter a password');
        return;
      }
      if (password.length < 8) {
        setState(() => _errorMessage = 'Password must be 8 or more characters long');
        return;
      }

      setState(() => _isLoading = true);

      try {
        await ref.read(authRepositoryProvider).register(
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              email: _emailController.text.trim(),
              password: password,
            );

        if (mounted) {
          setState(() => _isLoading = false);
          context.push(
            AppRoutes.otp,
            extra: {
              'email': _emailController.text.trim(),
              'name': '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
            },
          );
        }
      } on AuthException catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = e.message;
          });
        }
      } catch (_) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Registration failed. Please try again.';
          });
        }
      }
    }
  }

  double get _progressFraction {
    switch (_currentStep) {
      case 0:
        return 0.25;
      case 1:
        return 0.50;
      case 2:
        return 0.75;
      default:
        return 0.25;
    }
  }

  String get _buttonText {
    switch (_currentStep) {
      case 0:
        return 'Input Email';
      case 1:
        return 'Create Password';
      case 2:
        return 'Verification';
      default:
        return 'Continue';
    }
  }

  String get _stepTitle {
    switch (_currentStep) {
      case 0:
        return "What's is your name?";
      case 1:
        return 'And, your email?';
      case 2:
        return 'Create a password';
      default:
        return "What's is your name?";
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
                          // Back Button
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.textPrimary,
                              size: 24,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: _handleBack,
                          ),

                          const SizedBox(height: 36),

                          // Subtitle Eyebrow
                          Text(
                            'Create Your Account',
                            style: GoogleFonts.urbanist(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF8A8A8A),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Step Title
                          Text(
                            _stepTitle,
                            style: GoogleFonts.urbanist(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              height: 1.2,
                              letterSpacing: -0.3,
                            ),
                          ),

                          const SizedBox(height: 44),

                          // Step-specific fields
                          if (_currentStep == 0) ..._buildNameStep(),
                          if (_currentStep == 1) ..._buildEmailStep(),
                          if (_currentStep == 2) ..._buildPasswordStep(),

                          if (_errorMessage != null) ...[
                            const SizedBox(height: 18),
                            Container(
                              width: double.infinity,
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

                // Bottom Step Progress Line Indicator (Flush with edges)
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      width: double.infinity,
                      height: 3,
                      color: const Color(0xFFF2F2F2),
                      alignment: Alignment.centerLeft,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: constraints.maxWidth * _progressFraction,
                        height: 3,
                        color: AppColors.textPrimary,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Action Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
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
                      text: _buttonText,
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
      ),
    );
  }

  List<Widget> _buildNameStep() {
    return [
      AppTextField(
        controller: _firstNameController,
        labelText: 'First Name',
        textCapitalization: TextCapitalization.words,
        keyboardType: TextInputType.name,
        borderRadius: BorderRadius.circular(16),
        fillColor: Colors.transparent,
      ),
      const SizedBox(height: 20),
      AppTextField(
        controller: _lastNameController,
        labelText: 'Last Name',
        textCapitalization: TextCapitalization.words,
        keyboardType: TextInputType.name,
        borderRadius: BorderRadius.circular(16),
        fillColor: Colors.transparent,
      ),
    ];
  }

  List<Widget> _buildEmailStep() {
    return [
      AppTextField(
        controller: _emailController,
        labelText: 'Email',
        keyboardType: TextInputType.emailAddress,
        borderRadius: BorderRadius.circular(16),
        fillColor: Colors.transparent,
      ),
      const SizedBox(height: 24),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              "I'd like to received marketing and policy communication from traver and its partners.",
              style: GoogleFonts.urbanist(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF8A8A8A),
                height: 1.35,
              ),
            ),
          ),
          const SizedBox(width: 16),
          CupertinoSwitch(
            value: _receiveMarketing,
            activeTrackColor: AppColors.textPrimary,
            onChanged: (val) {
              setState(() {
                _receiveMarketing = val;
              });
            },
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildPasswordStep() {
    return [
      AppTextField(
        controller: _passwordController,
        labelText: 'Password',
        obscureText: _obscurePassword,
        borderRadius: BorderRadius.circular(16),
        fillColor: Colors.transparent,
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: const Color(0xFF1A1A1A),
            size: 22,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
      const SizedBox(height: 16),
      Text(
        'Your password must include at least one symbol and be 8 or more characters long.',
        style: GoogleFonts.urbanist(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF8A8A8A),
          height: 1.4,
        ),
      ),
    ];
  }
}
