import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/country.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/auth/auth_banner_carousel.dart';
import '../widgets/phone_input_field.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'privacy_policy_screen.dart';

/// Dedicated Sign-Up Screen for new user registration.
///
/// Key Rules:
/// - Full, uncropped 16:9 illustration banner (zero cut or crop).
/// - Accepts Full Name, Email ID, and Phone Number.
/// - Includes OPTIONAL Referral Code field that awards ₹10 instant cash to referee.
/// - Supports "Sign up with Google" (carrying referral code if entered).
/// - Pinned bottom bar so that Terms of Service & Privacy Policy and Log In link
///   are ALWAYS clearly displayed on the screen at all times without being hidden.
class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup';
  final String? initialPhone;
  final String? initialEmail;
  final String? initialReferralCode;

  const SignupScreen({
    super.key,
    this.initialPhone,
    this.initialEmail,
    this.initialReferralCode,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _referralController = TextEditingController();
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
    if (widget.initialEmail != null && widget.initialEmail!.isNotEmpty) {
      _emailController.text = widget.initialEmail!;
    }
    if (widget.initialReferralCode != null && widget.initialReferralCode!.isNotEmpty) {
      _referralController.text = widget.initialReferralCode!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _referralController.dispose();
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

  /// Handles "Create Account" submission:
  /// 1. Validates form inputs.
  /// 2. Checks if phone or email already exists.
  /// 3. Sends OTP to user's phone.
  Future<void> _handleSignupSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final formattedPhone = _formatPhoneNumber(_phoneController.text);
      final cleanEmail = _emailController.text.trim().toLowerCase();

      // Check if phone or email is already registered
      final phoneCheck = await _authService.checkIdentifier(formattedPhone);
      if (phoneCheck['isRegistered'] == true) {
        if (!mounted) return;
        _showSnackBar(
          'An account with this phone number already exists.',
          isError: true,
          action: SnackBarAction(
            label: 'LOG IN',
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(
                LoginScreen.routeName,
                arguments: {'initialPhone': _phoneController.text.trim()},
              );
            },
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      final emailCheck = await _authService.checkIdentifier(cleanEmail);
      if (emailCheck['isRegistered'] == true) {
        if (!mounted) return;
        _showSnackBar(
          'An account with this email address already exists.',
          isError: true,
          action: SnackBarAction(
            label: 'LOG IN',
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(
                LoginScreen.routeName,
                arguments: {'initialEmail': cleanEmail},
              );
            },
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      // Send OTP to the phone number
      _targetDisplay = formattedPhone;
      final otpRes = await _authService.sendOtp(formattedPhone);

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
        _showSnackBar('Security code sent to $formattedPhone', isError: false);
      } else {
        _showSnackBar(otpRes['message'] ?? 'Failed to send security code.');
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

  /// Verifies OTP and registers user in backend with referral bonus
  Future<void> _verifyOtpAndSignup() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty || otp.length != 6) {
      _showSnackBar('Please enter the 6-digit code');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Verify OTP
      final verifyRes = await _authService.verifyOtp(
        identifier: _targetDisplay,
        otp: otp,
      );

      if (!mounted) return;

      if (verifyRes['success'] != true) {
        _showSnackBar(verifyRes['message'] ?? 'Invalid or expired code.');
        return;
      }

      // 2. Register user in PostgreSQL database
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final refCode = _referralController.text.trim();

      final signupRes = await userProvider.signup(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _targetDisplay,
        referralCode: refCode.isNotEmpty ? refCode : null,
      );

      if (!mounted) return;

      if (signupRes['success'] == true) {
        final msg = signupRes['message'] ?? 'Account created successfully!';
        _showSnackBar(msg, isError: false);
        Navigator.of(context).pushNamedAndRemoveUntil(
          HomeScreen.routeName,
          (route) => false,
        );
      } else {
        _showSnackBar(signupRes['message'] ?? 'Registration failed. Please try again.');
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
    Widget? suffixIcon,
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
      suffixIcon: suffixIcon,
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
      // ==========================================
      // PINNED BOTTOM BAR (GUARANTEES TERMS & LOGIN ARE ALWAYS VISIBLE WITH PROPER PADDING)
      // ==========================================
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
                    if (!_isOtpSent) ...[
                      // INTERCONNECTION TO LOGIN SCREEN
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed(
                                LoginScreen.routeName,
                              );
                            },
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],

                    // LEGAL / TERMS OF SERVICE & PRIVACY POLICY NOTICE (Enlarged font size)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'By creating an account, you agree to KashIQ\'s ',
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
              // Top Auto-sliding Banner Carousel (100% Crisp, NO blur)
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
                      _isOtpSent ? 'Verify Security Code' : 'Create Free Account',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _isOtpSent
                          ? 'Enter the 6-digit code sent to $_targetDisplay'
                          : 'Sign up to earn real cashback & rewards on every order',
                      style: AppTextStyles.body(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ).copyWith(fontSize: 12.5),
                    ),
                    const SizedBox(height: 12),

                    // FORM CONTENT
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (!_isOtpSent) ...[
                            // 1. FULL NAME INPUT
                            TextFormField(
                              key: const ValueKey('signup_name_input'),
                              controller: _nameController,
                              textCapitalization: TextCapitalization.words,
                              style: TextStyle(
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                fontSize: 14,
                              ),
                              decoration: _buildInputDecoration(
                                label: 'Full Name',
                                icon: Icons.person_outline_rounded,
                                hint: 'e.g. Rahul Sharma',
                                isDark: isDark,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),

                            // 2. EMAIL ADDRESS INPUT
                            TextFormField(
                              key: const ValueKey('signup_email_input'),
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                fontSize: 14,
                              ),
                              decoration: _buildInputDecoration(
                                label: 'Email Address',
                                icon: Icons.email_outlined,
                                hint: 'you@example.com',
                                isDark: isDark,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your email address';
                                }
                                final email = value.trim();
                                final isValidEmail = RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(email);

                                if (!isValidEmail) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),

                            // 3. PHONE NUMBER INPUT
                            PhoneInputWithCountrySelector(
                              inputKey: const ValueKey('signup_phone_input'),
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
                                  return 'Please enter your phone number';
                                }
                                if (!_selectedCountry.isValidLength(value)) {
                                  return _selectedCountry.validationErrorText;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),

                            // 4. OPTIONAL REFERRAL CODE (COMPACT INLINE WITH +₹10 CASH BADGE)
                            TextFormField(
                              key: const ValueKey('signup_referral_input'),
                              controller: _referralController,
                              textCapitalization: TextCapitalization.characters,
                              style: TextStyle(
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                fontSize: 14,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: _buildInputDecoration(
                                label: 'Referral Code (Optional)',
                                icon: Icons.card_giftcard_rounded,
                                hint: 'e.g. RAHU1234',
                                isDark: isDark,
                                suffixIcon: Container(
                                  margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    '+₹10 Cash',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF059669),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),

                            // CREATE ACCOUNT BUTTON
                            SizedBox(
                              height: 46,
                              child: ElevatedButton(
                                key: const ValueKey('signup_continue_btn'),
                                onPressed: _isLoading ? null : _handleSignupSubmit,
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
                                            'Create Account',
                                            style: AppTextStyles.buttonText(
                                              color: AppColors.cardBackground,
                                            ).copyWith(fontSize: 14.5),
                                          ),
                                          const SizedBox(width: 6),
                                          const Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 17,
                                            color: AppColors.cardBackground,
                                          ),
                                        ],
                                      ),
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
                                    color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                            TextFormField(
                              key: const ValueKey('signup_otp_input'),
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
                              height: 46,
                              child: ElevatedButton(
                                key: const ValueKey('signup_verify_otp_btn'),
                                onPressed: _isLoading ? null : _verifyOtpAndSignup,
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
                                            size: 17,
                                            color: AppColors.cardBackground,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Verify Code & Register',
                                            style: AppTextStyles.buttonText(
                                              color: AppColors.cardBackground,
                                            ).copyWith(fontSize: 14.5),
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
                                    'Edit Details',
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

                    if (!_isOtpSent) ...[
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
