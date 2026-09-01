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

  String _targetPhone = '';

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
        _targetPhone = formattedPhone;
        await _requestMockPhoneOtp(formattedPhone);
      } else {
        await _handleEmailFlow(_emailController.text.trim());
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
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() {
      _isOtpSent = true;
    });
    _showSnackBar('OTP sent to $phone.', isError: false);
  }

  /// Verifies entered OTP for main phone flow
  Future<void> _verifyEnteredOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6 || !RegExp(r'^\d{6}$').hasMatch(otp)) {
      _showSnackBar('Please enter valid 6-digit OTP');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final name = _nameController.text.trim().isNotEmpty
          ? _nameController.text.trim()
          : 'CashKaro User';

      await userProvider.setInitialUserProfile(
        uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
        fullName: name,
        email: '',
        phoneNumber: _targetPhone,
      );

      if (!mounted) return;
      _showSnackBar('Logged in successfully!', isError: false);
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
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

  /// Handles email verification / registration flow
  Future<void> _handleEmailFlow(String email) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Mock search for user by email
    await Future.delayed(const Duration(milliseconds: 800));

    if (userProvider.user != null && userProvider.user?.email == email) {
      _showSnackBar('Welcome back!', isError: false);
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } else {
      // Prompt user to complete registration via bottom sheet
      if (!mounted) return;
      _showRegistrationBottomSheet(email);
    }
  }

  /// Registration Bottom Sheet for Email flow
  void _showRegistrationBottomSheet(String email) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetFormKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final otpSheetController = TextEditingController();

    Country sheetSelectedCountry = Country.defaultCountry;
    bool isOtpSentInSheet = false;
    String sheetFormattedPhone = '';
    bool isSendingOtp = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            Future<void> sendSheetOtp() async {
              if (!sheetFormKey.currentState!.validate()) return;

              setSheetState(() {
                isSendingOtp = true;
              });

              final cleanPhone = _formatPhoneNumber(
                phoneController.text,
                sheetSelectedCountry,
              );
              sheetFormattedPhone = cleanPhone;

              await Future.delayed(const Duration(seconds: 1));

              setSheetState(() {
                isSendingOtp = false;
                isOtpSentInSheet = true;
              });

              _showSnackBar('OTP sent to $cleanPhone.', isError: false);
            }

            Future<void> verifySheetOtpAndRegister() async {
              final otp = otpSheetController.text.trim();
              if (otp.length != 6 || !RegExp(r'^\d{6}$').hasMatch(otp)) {
                _showSnackBar('Please enter valid 6-digit OTP');
                return;
              }

              final userProvider = Provider.of<UserProvider>(context, listen: false);
              final nav = Navigator.of(context);
              final sheetNav = Navigator.of(ctx);

              await userProvider.setInitialUserProfile(
                uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
                fullName: nameController.text.trim(),
                phoneNumber: sheetFormattedPhone,
                email: email,
              );

              if (!mounted) return;
              sheetNav.pop();
              _showSnackBar('Registration successful!', isError: false);
              nav.pushReplacementNamed(HomeScreen.routeName);
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: sheetFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkBorder : AppColors.border,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Complete Registration',
                        style: GoogleFonts.fraunces(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Registering with: $email',
                        style: AppTextStyles.caption(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (!isOtpSentInSheet) ...[
                        TextFormField(
                          key: const ValueKey('sheet_name_input'),
                          controller: nameController,
                          style: TextStyle(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                          decoration: _buildInputDecoration(
                            label: 'Full Name',
                            icon: Icons.person_outline_rounded,
                            isDark: isDark,
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        PhoneInputWithCountrySelector(
                          inputKey: const ValueKey('sheet_phone_input'),
                          controller: phoneController,
                          selectedCountry: sheetSelectedCountry,
                          onCountryChanged: (country) {
                            setSheetState(() {
                              sheetSelectedCountry = country;
                            });
                          },
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Please enter phone number';
                            }
                            final clean = val.replaceAll(RegExp(r'\D'), '');
                            if (clean.length != 10) {
                              return 'Enter valid 10-digit phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isSendingOtp ? null : sendSheetOtp,
                            style: _buildButtonStyle(),
                            child: isSendingOtp
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Send OTP & Verify',
                                    style: AppTextStyles.buttonText(
                                      color: AppColors.cardBackground,
                                    ),
                                  ),
                          ),
                        ),
                      ] else ...[
                        Text(
                          'OTP sent to $sheetFormattedPhone',
                          style: GoogleFonts.fraunces(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const ValueKey('sheet_otp_input'),
                          controller: otpSheetController,
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
                            label: 'Enter 6-digit OTP',
                            icon: Icons.lock_clock_outlined,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isSendingOtp ? null : verifySheetOtpAndRegister,
                            style: _buildButtonStyle(),
                            child: isSendingOtp
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Verify & Register',
                                    style: AppTextStyles.buttonText(
                                      color: AppColors.cardBackground,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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
                          'OTP sent to $_targetPhone',
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
                                'Change Number',
                                style: AppTextStyles.caption(
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      _requestMockPhoneOtp(_targetPhone);
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
