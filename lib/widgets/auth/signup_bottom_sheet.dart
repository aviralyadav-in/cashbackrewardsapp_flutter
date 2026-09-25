import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/country.dart';
import '../../providers/user_provider.dart';
import '../../screens/home/home_screen.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';

class SignupBottomSheet extends StatefulWidget {
  final String formattedPhone;
  final Country country;
  final String? initialReferralCode;

  const SignupBottomSheet({
    super.key,
    required this.formattedPhone,
    required this.country,
    this.initialReferralCode,
  });

  @override
  State<SignupBottomSheet> createState() => _SignupBottomSheetState();
}

class _SignupBottomSheetState extends State<SignupBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _referralController = TextEditingController();
  final _otpController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _isOtpSent = false;
  String _developmentOtp = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialReferralCode != null &&
        widget.initialReferralCode!.trim().isNotEmpty) {
      _referralController.text = widget.initialReferralCode!.trim();
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _referralController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// Step 1: Validates details and sends OTP to the pre-filled phone number
  Future<void> _handleDetailsSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final cleanEmail = _emailController.text.trim().toLowerCase();

      // Check if email already exists in backend
      if (cleanEmail.isNotEmpty) {
        final emailCheck = await _authService.checkIdentifier(cleanEmail);
        if (emailCheck['isRegistered'] == true) {
          _showSnackBar('An account with this email address already exists.');
          return;
        }
      }

      // Send OTP to the pre-filled phone number
      final otpRes = await _authService.sendOtp(widget.formattedPhone);

      if (!mounted) return;

      if (otpRes['success'] == true) {
        final dummyOtp = otpRes['otp']?.toString() ?? '';
        setState(() {
          _isOtpSent = true;
          _developmentOtp = dummyOtp;
        });
        if (dummyOtp.isNotEmpty) {
          _otpController.text = dummyOtp;
        }
        _showSnackBar(
          'Security code sent to ${widget.formattedPhone}',
          isError: false,
        );
      } else {
        _showSnackBar(otpRes['message'] ?? 'Failed to send security code.');
      }
    } catch (e) {
      _showSnackBar('Error sending code: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Resend OTP
  Future<void> _resendOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authService.sendOtp(widget.formattedPhone);
      if (!mounted) return;

      if (result['success'] == true) {
        final dummyOtp = result['otp']?.toString() ?? '';
        setState(() {
          _developmentOtp = dummyOtp;
        });
        if (dummyOtp.isNotEmpty) {
          _otpController.text = dummyOtp;
        }
        _showSnackBar('New code sent! (Test OTP: $dummyOtp)', isError: false);
      } else {
        _showSnackBar(result['message'] ?? 'Failed to resend code.');
      }
    } catch (e) {
      _showSnackBar(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Step 2: Verifies OTP and creates user account in backend
  Future<void> _verifyOtpAndCreateAccount() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty || otp.length != 6) {
      _showSnackBar('Please enter the 6-digit code');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Verify OTP with backend
      final verifyRes = await _authService.verifyOtp(
        identifier: widget.formattedPhone,
        otp: otp,
      );

      if (!mounted) return;

      if (verifyRes['success'] != true) {
        _showSnackBar(verifyRes['message'] ?? 'Invalid or expired code.');
        return;
      }

      // 2. Combine First Name & Last Name (optional)
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final fullName = lastName.isNotEmpty ? '$firstName $lastName' : firstName;
      final cleanEmail = _emailController.text.trim().toLowerCase();
      final refCode = _referralController.text.trim();

      // 3. Register user with PostgreSQL Backend
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final signupRes = await userProvider.signup(
        name: fullName,
        email: cleanEmail.isNotEmpty ? cleanEmail : null,
        phoneNumber: widget.formattedPhone,
        referralCode: refCode.isNotEmpty ? refCode : null,
      );

      if (!mounted) return;

      if (signupRes['success'] == true) {
        _showSnackBar('Account created! Welcome to KashIQ', isError: false);
        // Dismiss bottom sheet and navigate to Home Screen
        Navigator.of(context).pop();
        Navigator.of(context).pushNamedAndRemoveUntil(
          HomeScreen.routeName,
          (route) => false,
        );
      } else {
        _showSnackBar(
          signupRes['message'] ?? 'Registration failed. Please try again.',
        );
      }
    } catch (e) {
      _showSnackBar('Verification error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
    String? hint,
    Widget? suffix,
    bool isDark = true,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixIcon: suffix,
      labelStyle: TextStyle(
        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        fontSize: 13.5,
      ),
      hintStyle: TextStyle(
        color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
        fontSize: 13,
      ),
      filled: true,
      fillColor: isDark ? AppColors.darkCard : AppColors.cardBackground,
      prefixIcon: Icon(
        icon,
        color: isDark ? AppColors.darkTextSecondary : AppColors.primaryBrown,
        size: 19,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        borderSide: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        borderSide: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        borderSide: const BorderSide(
          color: AppColors.primaryBrown,
          width: 1.5,
        ),
      ),
    );
  }

  ButtonStyle _buildButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryBrown,
      foregroundColor: AppColors.cardBackground,
      elevation: 1.5,
      shadowColor: AppColors.primaryBrown.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final keyboardBottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.mainBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: keyboardBottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Drag Handle & Close button bar
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
                child: Row(
                  children: [
                    const Spacer(),
                    Container(
                      width: 42,
                      height: 4.5,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkBorder
                            : const Color(0xFFD4C2B4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                        size: 20,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),

              // Scrollable Form Content
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Text
                      Text(
                        _isOtpSent ? 'Verify Security Code' : 'Complete Your Profile',
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.deepBrown,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isOtpSent
                            ? 'Enter the 6-digit code sent to ${widget.formattedPhone}'
                            : 'Set up your account to start earning instant cashbacks and rewards.',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (!_isOtpSent) ...[
                        // PRE-FILLED, NON-EDITABLE PHONE NUMBER CARD
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkCard.withValues(alpha: 0.8)
                                : const Color(0xFFF5EEE8),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : const Color(0xFFE2D3C7),
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                widget.country.flag,
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                widget.formattedPhone,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.deepBrown,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBrown.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.lock_rounded,
                                      size: 13,
                                      color: AppColors.primaryBrown,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Phone locked',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? AppColors.darkPrimary
                                            : AppColors.primaryBrown,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // USER DETAILS FORM
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // FIRST NAME (REQUIRED)
                              TextFormField(
                                key: const ValueKey('signup_first_name_input'),
                                controller: _firstNameController,
                                textCapitalization: TextCapitalization.words,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.textPrimary,
                                  fontSize: 14,
                                ),
                                decoration: _buildInputDecoration(
                                  label: 'First Name *',
                                  icon: Icons.person_outline_rounded,
                                  hint: 'Enter your first name',
                                  isDark: isDark,
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your first name';
                                  }
                                  if (value.trim().length < 2) {
                                    return 'Name must be at least 2 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),

                              // LAST NAME (OPTIONAL)
                              TextFormField(
                                key: const ValueKey('signup_last_name_input'),
                                controller: _lastNameController,
                                textCapitalization: TextCapitalization.words,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.textPrimary,
                                  fontSize: 14,
                                ),
                                decoration: _buildInputDecoration(
                                  label: 'Last Name (Optional)',
                                  icon: Icons.badge_outlined,
                                  hint: 'Enter your last name',
                                  isDark: isDark,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // EMAIL ADDRESS (VALIDATED)
                              TextFormField(
                                key: const ValueKey('signup_email_input'),
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.textPrimary,
                                  fontSize: 14,
                                ),
                                decoration: _buildInputDecoration(
                                  label: 'Email Address *',
                                  icon: Icons.email_outlined,
                                  hint: 'you@example.com',
                                  isDark: isDark,
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your email address';
                                  }
                                  final email = value.trim();
                                  final isValid = RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                  ).hasMatch(email);
                                  if (!isValid) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),

                              // REFERRAL CODE (OPTIONAL)
                              TextFormField(
                                key: const ValueKey('signup_referral_input'),
                                controller: _referralController,
                                textCapitalization: TextCapitalization.characters,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                ),
                                decoration: _buildInputDecoration(
                                  label: 'Referral Code (Optional)',
                                  icon: Icons.card_giftcard_rounded,
                                  hint: 'e.g. KASH10',
                                  suffix: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      '+₹10 Bonus',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.success,
                                      ),
                                    ),
                                  ),
                                  isDark: isDark,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // SUBMIT BUTTON
                              SizedBox(
                                height: 48,
                                child: ElevatedButton(
                                  key: const ValueKey('signup_submit_btn'),
                                  onPressed: _isLoading ? null : _handleDetailsSubmit,
                                  style: _buildButtonStyle(),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Continue & Send Code',
                                              style: AppTextStyles.buttonText(
                                                color: AppColors.cardBackground,
                                              ).copyWith(fontSize: 15),
                                            ),
                                            const SizedBox(width: 8),
                                            const Icon(
                                              Icons.arrow_forward_rounded,
                                              size: 18,
                                              color: AppColors.cardBackground,
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ] else ...[
                        // OTP VERIFICATION VIEW
                        if (_developmentOtp.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBrown.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Test Security Code: $_developmentOtp',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.primaryBrown,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                        TextFormField(
                          key: const ValueKey('signup_sheet_otp_input'),
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          buildCounter: (
                            context, {
                            required currentLength,
                            required isFocused,
                            maxLength,
                          }) =>
                              null,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.deepBrown,
                            fontSize: 22,
                            letterSpacing: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: _buildInputDecoration(
                            label: 'Enter 6-Digit Code',
                            icon: Icons.lock_clock_outlined,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            key: const ValueKey('signup_verify_otp_btn'),
                            onPressed: _isLoading ? null : _verifyOtpAndCreateAccount,
                            style: _buildButtonStyle(),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.verified_user_rounded,
                                        size: 18,
                                        color: AppColors.cardBackground,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Verify & Complete Registration',
                                        style: AppTextStyles.buttonText(
                                          color: AppColors.cardBackground,
                                        ).copyWith(fontSize: 15),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isOtpSent = false;
                                  _otpController.clear();
                                });
                              },
                              child: Text(
                                'Edit Details',
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textMuted,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: _isLoading ? null : _resendOtp,
                              child: Text(
                                'Resend Code',
                                style: AppTextStyles.buttonText(
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.primaryBrown,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
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
