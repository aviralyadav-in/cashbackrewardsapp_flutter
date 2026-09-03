import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/country.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/phone_input_field.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _mainFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();

  Country _selectedCountry = Country.defaultCountry;
  bool _isPhoneMode = true;
  bool _isLoading = false;
  bool _isOtpSent = false;

  String _targetDisplay = '';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
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

  void _showSnackBar(String message, {bool isError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// Handles initial submit when user clicks Continue
  Future<void> _handleInitialSubmit() async {
    if (!_mainFormKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isPhoneMode) {
        final formattedPhone = _formatPhoneNumber(_phoneController.text);
        _targetDisplay = formattedPhone;
        await _requestMockPhoneOtp(formattedPhone);
      } else {
        final email = _emailController.text.trim();
        _targetDisplay = email;
        await _requestMockEmailOtp(email);
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

  /// Requests Mock Phone OTP
  Future<void> _requestMockPhoneOtp(String phone) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() {
      _isOtpSent = true;
    });
    _showSnackBar('OTP sent to $phone.', isError: false);
  }

  /// Requests Mock Email OTP
  Future<void> _requestMockEmailOtp(String email) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() {
      _isOtpSent = true;
    });
    _showSnackBar('OTP sent to $email.', isError: false);
  }

  /// Verifies entered OTP and directly redirects to HomeScreen
  Future<void> _verifyEnteredOtp() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      _showSnackBar('Please enter the OTP');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final name = _nameController.text.trim().isNotEmpty
          ? _nameController.text.trim()
          : (_emailController.text.trim().isNotEmpty
              ? _emailController.text.trim().split('@').first
              : 'CashKaro User');
      final email = _emailController.text.trim();
      final phone = _phoneController.text.trim().isNotEmpty
          ? _formatPhoneNumber(_phoneController.text)
          : '';

      await userProvider.setInitialUserProfile(
        uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
        fullName: name,
        email: email,
        phoneNumber: phone,
      );

      if (!mounted) return;
      _showSnackBar('Logged in successfully!', isError: false);

      // Direct redirection to Home screen
      Navigator.of(context).pushNamedAndRemoveUntil(
        HomeScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      _showSnackBar('Verification failed: $e');
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
        fontSize: 14,
      ),
      hintStyle: TextStyle(
        color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
        fontSize: 14,
      ),
      filled: true,
      fillColor: isDark ? AppColors.darkCard : AppColors.cardBackground,
      prefixIcon: Icon(
        icon,
        color: isDark ? AppColors.darkTextSecondary : AppColors.primaryBrown,
        size: 20,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.mainBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App Logo (Circle Icon)
                Center(
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? AppColors.darkCard : AppColors.beigeSurface,
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 38,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'CashKaro',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fraunces(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Login or Sign Up to continue',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 28),

                // Mode Selector Tabs (Phone / Email)
                if (!_isOtpSent)
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.beigeSurface,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isPhoneMode = true;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _isPhoneMode ? AppColors.primaryBrown : Colors.transparent,
                                borderRadius: BorderRadius.circular(AppDimensions.radiusCard - 2),
                              ),
                              child: Text(
                                'Phone Number',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.buttonText(
                                  color: _isPhoneMode
                                      ? AppColors.cardBackground
                                      : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isPhoneMode = false;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: !_isPhoneMode ? AppColors.primaryBrown : Colors.transparent,
                                borderRadius: BorderRadius.circular(AppDimensions.radiusCard - 2),
                              ),
                              child: Text(
                                'Email',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.buttonText(
                                  color: !_isPhoneMode
                                      ? AppColors.cardBackground
                                      : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),

                Form(
                  key: _mainFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!_isOtpSent) ...[
                        if (_isPhoneMode) ...[
                          TextFormField(
                            key: const ValueKey('main_name_input'),
                            controller: _nameController,
                            style: TextStyle(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                              fontSize: 15,
                            ),
                            decoration: _buildInputDecoration(
                              label: 'Full Name',
                              icon: Icons.person_outline_rounded,
                              hint: 'Enter your full name',
                              isDark: isDark,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          PhoneInputWithCountrySelector(
                            inputKey: const ValueKey('main_phone_input'),
                            controller: _phoneController,
                            selectedCountry: _selectedCountry,
                            onCountryChanged: (country) {
                              setState(() {
                                _selectedCountry = country;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your phone number';
                              }
                              final clean = value.replaceAll(RegExp(r'\D'), '');
                              if (clean.length != 10) {
                                return 'Please enter valid 10-digit phone number';
                              }
                              return null;
                            },
                          ),
                        ] else
                          TextFormField(
                            key: const ValueKey('main_email_input'),
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                              fontSize: 16,
                            ),
                            decoration: _buildInputDecoration(
                              label: 'Email Address',
                              icon: Icons.email_outlined,
                              hint: 'user@example.com',
                              isDark: isDark,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email';
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
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            key: const ValueKey('main_continue_btn'),
                            onPressed: _isLoading ? null : _handleInitialSubmit,
                            style: _buildButtonStyle(),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Continue',
                                    style: AppTextStyles.buttonText(
                                      color: AppColors.cardBackground,
                                    ).copyWith(fontSize: 15),
                                  ),
                          ),
                        ),
                      ] else ...[
                        // OTP Verification State
                        Text(
                          'OTP sent to $_targetDisplay',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.fraunces(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 20),
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
                            fontSize: 24,
                            letterSpacing: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: _buildInputDecoration(
                            label: 'Enter 6-Digit OTP',
                            icon: Icons.lock_clock_outlined,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            key: const ValueKey('main_verify_otp_btn'),
                            onPressed: _isLoading ? null : _verifyEnteredOtp,
                            style: _buildButtonStyle(),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Verify OTP',
                                    style: AppTextStyles.buttonText(
                                      color: AppColors.cardBackground,
                                    ).copyWith(fontSize: 15),
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
                                _isPhoneMode ? 'Change Number' : 'Change Email',
                                style: AppTextStyles.caption(
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      if (_isPhoneMode) {
                                        _requestMockPhoneOtp(_targetDisplay);
                                      } else {
                                        _requestMockEmailOtp(_targetDisplay);
                                      }
                                    },
                              child: Text(
                                'Resend OTP',
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
        ),
      ),
    );
  }
}
