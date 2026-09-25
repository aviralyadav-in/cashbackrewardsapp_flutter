import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/country.dart';
import '../../providers/user_provider.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/auth/auth_banner_carousel.dart';
import '../../widgets/auth/signup_bottom_sheet.dart';
import '../../widgets/auth/phone_input_field.dart';
import '../home/home_screen.dart';
import '../profile/privacy_policy_screen.dart';

/// Dedicated Mobile-Only Authentication Screen.
///
/// Authentication Flow:
/// 1. User enters Mobile Number with Country selector and taps "Continue".
/// 2. Checks backend API (/api/auth/check-phone).
/// 3. If User Exists:
///    - Backend sends OTP.
///    - UI transitions to inline 6-digit OTP verification.
///    - On OTP verify -> logs in via UserProvider and navigates to HomeScreen.
/// 4. If User Does Not Exist:
///    - Does NOT send OTP.
///    - Smoothly slides up SignupBottomSheet with the mobile number pre-filled & locked.
///    - User fills First Name, Last Name (opt), Email, Referral (opt).
///    - User verifies OTP in sheet and registers account.
class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  final String? initialPhone;
  final String? initialEmail;
  final bool isSignUp;

  const LoginScreen({
    super.key,
    this.initialPhone,
    this.initialEmail,
    this.isSignUp = false,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _mainFormKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  final AuthService _authService = AuthService();

  Country _selectedCountry = Country.defaultCountry;
  bool _isLoading = false;
  bool _isOtpSent = false;

  String _targetDisplay = '';
  String _developmentOtp = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialPhone != null && widget.initialPhone!.isNotEmpty) {
      _phoneController.text = widget.initialPhone!;
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  /// Normalizes phone number into strict E.164 format (+91XXXXXXXXXX).
  String _formatPhoneNumber(String raw, [Country? country]) {
    final activeCountry = country ?? _selectedCountry;
    var clean = raw.trim().replaceAll(RegExp(r'\D'), '');

    final dialDigits = activeCountry.dialCode.replaceAll(RegExp(r'\D'), '');
    if (clean.startsWith(dialDigits) && clean.length > dialDigits.length + 5) {
      clean = clean.substring(dialDigits.length);
    }
    while (clean.startsWith('0')) {
      clean = clean.substring(1);
    }
    return '${activeCountry.dialCode}$clean';
  }

  void _showSnackBar(String message, {bool isError = true, SnackBarAction? action}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: action,
      ),
    );
  }

  /// Opens the Signup Bottom Sheet with pre-filled & locked mobile number
  void _openSignupSheet(String formattedPhone) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (ctx) => SignupBottomSheet(
        formattedPhone: formattedPhone,
        country: _selectedCountry,
      ),
    );
  }

  /// Handles "Continue" button press to verify phone existence in backend
  Future<void> _handleLoginSubmit() async {
    if (!_mainFormKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final formattedPhone = _formatPhoneNumber(_phoneController.text);
      _targetDisplay = formattedPhone;

      // 1. Check if mobile number is registered in PostgreSQL database
      final checkRes = await _authService.checkPhone(formattedPhone);

      if (!mounted) return;

      if (checkRes['success'] == false) {
        _showSnackBar(checkRes['message'] ?? 'Unable to connect to server. Please check your network.');
        return;
      }

      if (checkRes['isRegistered'] == true) {
        // User exists -> Send OTP using existing backend API
        final otpRes = await _authService.sendOtp(formattedPhone);
        if (otpRes['success'] == true) {
          final dummyOtp = otpRes['otp']?.toString() ?? '';
          setState(() {
            _isOtpSent = true;
            _developmentOtp = dummyOtp;
          });
          if (dummyOtp.isNotEmpty) {
            _otpController.text = dummyOtp;
          }
          _showSnackBar('Security code sent to $formattedPhone', isError: false);
        } else {
          _showSnackBar(otpRes['message'] ?? 'Failed to send security code.');
        }
      } else {
        // User does NOT exist -> Do NOT send OTP.
        // Open Signup screen as a Bottom Sheet sliding smoothly from bottom.
        _openSignupSheet(formattedPhone);
      }
    } catch (e) {
      _showSnackBar('Network error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Resends the OTP
  Future<void> _resendOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authService.sendOtp(_targetDisplay);
      if (!mounted) return;

      if (result['success'] == true) {
        final dummyOtp = result['otp']?.toString() ?? '';
        setState(() {
          _developmentOtp = dummyOtp;
        });
        if (dummyOtp.isNotEmpty) {
          _otpController.text = dummyOtp;
        }
        _showSnackBar('New security code sent! (Test OTP: $dummyOtp)', isError: false);
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

  /// Verifies entered OTP and logs the existing user in
  Future<void> _verifyEnteredOtp() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty || otp.length != 6) {
      _showSnackBar('Please enter the 6-digit code');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final verifyRes = await _authService.verifyOtp(
        identifier: _targetDisplay,
        otp: otp,
      );

      if (!mounted) return;

      if (verifyRes['success'] != true) {
        _showSnackBar(verifyRes['message'] ?? 'Invalid or expired code.');
        return;
      }

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final loginRes = await userProvider.login(phoneNumber: _targetDisplay);

      if (!mounted) return;

      if (loginRes['success'] == true) {
        _showSnackBar('Welcome back!', isError: false);
        Navigator.of(context).pushNamedAndRemoveUntil(
          HomeScreen.routeName,
          (route) => false,
        );
      } else {
        _showSnackBar(loginRes['message'] ?? 'Login failed. Please try again.');
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
    bool isDark = true,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
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
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.mainBackground,
      // Pinned bottom bar: Terms & Privacy and Sign Up link
      bottomNavigationBar: isKeyboardOpen
          ? null
          : SafeArea(
              top: false,
              child: Container(
                color: isDark ? AppColors.darkBackground : AppColors.mainBackground,
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [


                    // Legal Terms & Privacy notice
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'By continuing, you agree to KashIQ\'s ',
                              style: TextStyle(
                                fontSize: 13.0,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(PrivacyPolicyScreen.routeName);
                              },
                              child: Text(
                                'Terms of Service',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            Text(
                              ' and ',
                              style: TextStyle(
                                fontSize: 13.0,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(PrivacyPolicyScreen.routeName);
                              },
                              child: Text(
                                'Privacy Policy',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            Text(
                              '.',
                              style: TextStyle(
                                fontSize: 13.0,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Auto-sliding Banner Carousel
              AuthBannerCarousel(
                height: 250,
                isDark: isDark,
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Form Header Text
                    Text(
                      _isOtpSent ? 'Verify Security Code' : 'Welcome to KashIQ',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isOtpSent
                          ? 'Enter the 6-digit code sent to $_targetDisplay'
                          : 'Enter your mobile number to log in or create an account',
                      style: AppTextStyles.body(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ).copyWith(fontSize: 13),
                    ),
                    const SizedBox(height: 18),

                    // Form content
                    Form(
                      key: _mainFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (!_isOtpSent) ...[
                            // STRICTLY MOBILE NUMBER INPUT WITH COUNTRY SELECTOR
                            PhoneInputWithCountrySelector(
                              inputKey: const ValueKey('main_phone_input'),
                              controller: _phoneController,
                              selectedCountry: _selectedCountry,
                              onCountryChanged: (country) {
                                setState(() {
                                  _selectedCountry = country;
                                  final clean = _phoneController.text.replaceAll(RegExp(r'\D'), '');
                                  if (clean.length > country.maxDigits) {
                                    _phoneController.text = clean.substring(0, country.maxDigits);
                                  }
                                });
                              },
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your mobile number';
                                }
                                if (!_selectedCountry.isValidLength(value)) {
                                  return _selectedCountry.validationErrorText;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),

                            // CONTINUE BUTTON
                            SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                key: const ValueKey('main_continue_btn'),
                                onPressed: _isLoading ? null : _handleLoginSubmit,
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
                                            'Continue',
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
                            const SizedBox(height: 24),

                            // PREMIUM UNIFIED TRUST & BENEFITS CARD
                            _buildTrustCard(isDark),
                            const SizedBox(height: 24),
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
                                    color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                            TextFormField(
                              key: const ValueKey('main_otp_input'),
                              controller: _otpController,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6),
                              ],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
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
                            const SizedBox(height: 14),
                            SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                key: const ValueKey('main_verify_otp_btn'),
                                onPressed: _isLoading ? null : _verifyEnteredOtp,
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
                                            'Verify Code & Log In',
                                            style: AppTextStyles.buttonText(
                                              color: AppColors.cardBackground,
                                            ).copyWith(fontSize: 15),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            const SizedBox(height: 10),
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
                                    'Change Mobile Number',
                                    style: AppTextStyles.caption(
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: _isLoading ? null : _resendOtp,
                                  child: Text(
                                    'Resend Code',
                                    style: AppTextStyles.buttonText(
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrustCard(bool isDark) {
    final borderColor = isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);
    final cardBg = isDark
        ? const Color(0xFF132247)
        : const Color(0xFFFAF6F2);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Verified Badge
          Row(
            children: [
              Icon(
                Icons.verified_user_rounded,
                size: 16,
                color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
              ),
              const SizedBox(width: 6),
              Text(
                'WHY KASHIQ?',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.primaryBrown,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.darkSuccess : AppColors.success).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 11,
                      color: isDark ? AppColors.darkSuccess : AppColors.success,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '100% Verified',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkSuccess : AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(
            color: borderColor.withValues(alpha: 0.7),
            height: 1,
            thickness: 0.8,
          ),
          const SizedBox(height: 12),

          // Benefit 1: Security
          _buildAssuranceRow(
            icon: Icons.lock_outline_rounded,
            iconBg: isDark ? const Color(0xFF1B382B) : const Color(0xFFE8F5E9),
            iconColor: isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32),
            title: '100% Safe & Secure',
            subtitle: 'Bank-grade 256-bit encryption & privacy',
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          // Benefit 2: Tracking
          _buildAssuranceRow(
            icon: Icons.bolt_rounded,
            iconBg: isDark ? const Color(0xFF3E2D1A) : const Color(0xFFFFF3E0),
            iconColor: isDark ? const Color(0xFFFFB74D) : const Color(0xFFE65100),
            title: 'Fast Cashback Tracking',
            subtitle: 'Automatically synced directly to wallet',
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          // Benefit 3: Free & Real Money
          _buildAssuranceRow(
            icon: Icons.account_balance_wallet_outlined,
            iconBg: isDark ? const Color(0xFF1C2D5A) : const Color(0xFFF1F5F9),
            iconColor: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
            title: 'Free Forever & Real Cash',
            subtitle: 'Zero fees, transfer directly to UPI or Bank',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildAssuranceRow({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 19, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : const Color(0xFF2B1B16),
                ),
              ),
              const SizedBox(height: 1.5),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
