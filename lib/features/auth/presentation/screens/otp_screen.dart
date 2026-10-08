import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traver/app/router/routes.dart';
import 'package:traver/core/theme/theme.dart';
import 'package:traver/core/widgets/primary_button.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String? email;
  final String? name;

  const OtpScreen({
    super.key,
    this.email,
    this.name,
  });

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final int _codeLength = 4;
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  Timer? _countdownTimer;
  int _secondsRemaining = 203; // 03:23 in seconds matching Figma design
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Default values matching Screen 11: 1, 3, 5, 4
    final initialDigits = ['1', '3', '5', '4'];
    _controllers = List.generate(
      _codeLength,
      (index) => TextEditingController(text: initialDigits[index]),
    );
    _focusNodes = List.generate(_codeLength, (index) => FocusNode());

    for (int i = 0; i < _codeLength; i++) {
      _focusNodes[i].addListener(() => setState(() {}));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNodes[0].requestFocus();
      }
    });

    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        if (mounted) {
          setState(() {
            _secondsRemaining--;
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _timerFormatted {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _onDigitChanged(int index, String value) {
    setState(() => _errorMessage = null);

    if (value.length > 1) {
      // If user pasted multiple characters
      _controllers[index].text = value.substring(value.length - 1);
      _controllers[index].selection = TextSelection.collapsed(offset: 1);
    }

    if (value.isNotEmpty && index < _codeLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  Future<void> _handleSubmit() async {
    setState(() => _errorMessage = null);

    final otpCode = _controllers.map((c) => c.text.trim()).join();
    if (otpCode.length < _codeLength) {
      setState(() => _errorMessage = 'Please enter the complete 4-digit verification code');
      return;
    }

    setState(() => _isLoading = true);

    // Simulate verification
    await Future.delayed(const Duration(milliseconds: 400));

    if (mounted) {
      setState(() => _isLoading = false);
      // Navigate to Account Created success screen (Screen 12)
      context.push(AppRoutes.accountCreated);
    }
  }

  void _handleResend() {
    if (_secondsRemaining == 0) {
      setState(() {
        _secondsRemaining = 120; // 2 minutes on resend
        _errorMessage = null;
      });
      _startCountdown();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'A new verification code has been sent!',
            style: GoogleFonts.urbanist(fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back Arrow
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
                              context.go(AppRoutes.register);
                            }
                          },
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

                        // Title
                        Text(
                          'OTP Verification',
                          style: GoogleFonts.urbanist(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            height: 1.2,
                            letterSpacing: -0.3,
                          ),
                        ),

                        const SizedBox(height: 48),

                        // 4 OTP Boxes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(_codeLength, (index) {
                            return Focus(
                              onKeyEvent: (node, event) {
                                if (event is KeyDownEvent &&
                                    event.logicalKey == LogicalKeyboardKey.backspace &&
                                    _controllers[index].text.isEmpty &&
                                    index > 0) {
                                  _focusNodes[index - 1].requestFocus();
                                  return KeyEventResult.handled;
                                }
                                return KeyEventResult.ignored;
                              },
                              child: SizedBox(
                                width: 72,
                                height: 64,
                                child: TextField(
                                  controller: _controllers[index],
                                  focusNode: _focusNodes[index],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(1),
                                  ],
                                  style: GoogleFonts.urbanist(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                  decoration: InputDecoration(
                                    filled: false,
                                    fillColor: Colors.transparent,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                                    counterText: '',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFE8E8E8),
                                        width: 1.2,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFE8E8E8),
                                        width: 1.2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: AppColors.primary,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                  onChanged: (val) => _onDigitChanged(index, val),
                                ),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 28),

                        // Resend timer row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Send code reload in',
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF8A8A8A),
                              ),
                            ),
                            if (_secondsRemaining > 0)
                              Text(
                                _timerFormatted,
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF8A8A8A),
                                ),
                              )
                            else
                              GestureDetector(
                                onTap: _handleResend,
                                child: Text(
                                  'Resend Code',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        if (_errorMessage != null) ...[
                          const SizedBox(height: 20),
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

                // Full-width progress bar (100% active line for Screen 11)
                Container(
                  width: double.infinity,
                  height: 3,
                  color: AppColors.textPrimary,
                ),

                const SizedBox(height: 16),

                // Submit Button
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
                      text: 'Submit',
                      height: 56,
                      borderRadius: BorderRadius.circular(16),
                      isLoading: _isLoading,
                      onPressed: _handleSubmit,
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
