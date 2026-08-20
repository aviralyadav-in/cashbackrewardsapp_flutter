import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/country.dart';
import '../providers/user_provider.dart';
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
        backgroundColor: isError ? const Color(0xFFEF4444) : Colors.green,
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
        // Mock Phone OTP flow: switch to OTP screen state
        final phone = _formatPhoneNumber(_phoneController.text);
        _targetPhone = phone;
        await _requestMockPhoneOtp(phone);
      } else {
        // Email flow: Open registration bottom sheet
        final email = _emailController.text.trim().toLowerCase();
        setState(() {
          _isLoading = false;
        });
        _showEmailRegistrationBottomSheet(email);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('An error occurred: ${e.toString()}');
      }
    }
  }

  /// Simulates requesting OTP for phone number
  Future<void> _requestMockPhoneOtp(String phone) async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isOtpSent = true;
      });
      _showSnackBar('OTP sent successfully to $phone', isError: false);
    }
  }

  /// Verifies entered 6-digit mock OTP for phone mode
  Future<void> _verifyEnteredOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length < 6) {
      _showSnackBar('Please enter valid 6-digit OTP');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 400));

    if (mounted) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final authUser = FirebaseAuth.instance.currentUser;
      final uid = authUser?.uid ?? 'user_${DateTime.now().millisecondsSinceEpoch}';

      final enteredName = _nameController.text.trim();
      final userName = enteredName.isNotEmpty
          ? enteredName
          : (userProvider.fullName.isNotEmpty ? userProvider.fullName : 'Cashback User');

      await userProvider.setInitialUserProfile(
        uid: uid,
        fullName: userName,
        email: userProvider.email,
        phoneNumber: _targetPhone,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showSnackBar('OTP verified successfully!', isError: false);
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    }
  }

  // ==========================================
  // BOTTOM SHEET: Email Registration Flow
  // ==========================================
  void _showEmailRegistrationBottomSheet(String email) {
    final sheetFormKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final otpSheetController = TextEditingController();

    Country sheetSelectedCountry = _selectedCountry;
    bool isSendingOtp = false;
    bool isOtpSentInSheet = false;
    String sheetFormattedPhone = '';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF161618) : Colors.white,
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

              sheetFormattedPhone = _formatPhoneNumber(phoneController.text, sheetSelectedCountry);

              await Future.delayed(const Duration(milliseconds: 300));

              setSheetState(() {
                isSendingOtp = false;
                isOtpSentInSheet = true;
              });
              _showSnackBar('OTP sent to $sheetFormattedPhone', isError: false);
            }

            Future<void> verifySheetOtpAndRegister() async {
              final otp = otpSheetController.text.trim();
              if (otp.length < 6) {
                _showSnackBar('Please enter valid 6-digit OTP');
                return;
              }

              setSheetState(() {
                isSendingOtp = true;
              });

              await Future.delayed(const Duration(milliseconds: 400));

              if (!context.mounted) return;

              final userProvider = Provider.of<UserProvider>(context, listen: false);
              final authUser = FirebaseAuth.instance.currentUser;
              final uid = authUser?.uid ?? 'user_${DateTime.now().millisecondsSinceEpoch}';

              await userProvider.setInitialUserProfile(
                uid: uid,
                fullName: nameController.text.trim(),
                email: email,
                phoneNumber: sheetFormattedPhone,
              );

              if (!context.mounted) return;

              _showSnackBar('OTP verified successfully!', isError: false);
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
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
                            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Complete Registration',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Registering with: $email',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (!isOtpSentInSheet) ...[
                        TextFormField(
                          key: const ValueKey('sheet_name_input'),
                          controller: nameController,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                          decoration: _buildInputDecoration(
                            label: 'Full Name',
                            icon: Icons.person_outline,
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
                            if (clean.length < 7 || clean.length > 15) {
                              return 'Enter valid phone number';
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
                                : const Text(
                                    'Send OTP & Verify',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ] else ...[
                        Text(
                          'OTP sent to $sheetFormattedPhone',
                          style: const TextStyle(
                            color: Color(0xFF1E90FF),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const ValueKey('sheet_otp_input'),
                          controller: otpSheetController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
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
                                : const Text(
                                    'Verify & Register',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
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
        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        fontSize: 14,
      ),
      hintStyle: TextStyle(
        color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
        fontSize: 14,
      ),
      filled: true,
      fillColor: isDark ? const Color(0xFF151D2A) : Colors.white,
      prefixIcon: Icon(
        icon,
        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        size: 20,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE5E5EA),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE5E5EA),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFF1E90FF),
          width: 2,
        ),
      ),
    );
  }

  ButtonStyle _buildButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF1E90FF),
      foregroundColor: Colors.white,
      elevation: 4,
      shadowColor: const Color(0xFF1E90FF).withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D0D0D) : const Color(0xFFFFFFFF),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [
                    Color(0xFF0D0D0D),
                    Color(0xFF151D2A),
                    Color(0xFF0D0D0D),
                  ]
                : const [
                    Color(0xFFFFFFFF),
                    Color(0xFFF0F7FF),
                    Color(0xFFFFFFFF),
                  ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Logo (No Glow)
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? const Color(0xFF151D2A) : Colors.white,
                        border: Border.all(
                          color: const Color(0xFF1E90FF),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.card_giftcard,
                        size: 50,
                        color: Color(0xFF1E90FF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'CashKaro',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'HandwrittenItalic',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                      letterSpacing: 3.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Login or Sign Up to continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Mode Selector Tabs (Phone / Email)
                  if (!_isOtpSent)
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF151D2A) : const Color(0xFFF0F2F5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE5E5EA),
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
                                  color: _isPhoneMode ? const Color(0xFF1E90FF) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  'Phone Number',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: _isPhoneMode
                                        ? Colors.white
                                        : (isDark ? Colors.white : const Color(0xFF1F2937)),
                                    fontWeight:
                                        _isPhoneMode ? FontWeight.bold : FontWeight.normal,
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
                                  color: !_isPhoneMode ? const Color(0xFF1E90FF) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  'Email',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: !_isPhoneMode
                                        ? Colors.white
                                        : (isDark ? Colors.white : const Color(0xFF1F2937)),
                                    fontWeight:
                                        !_isPhoneMode ? FontWeight.bold : FontWeight.normal,
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
                                color: isDark ? Colors.white : Colors.black87,
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
                                if (clean.length < 7 || clean.length > 15) {
                                  return 'Please enter valid phone number';
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
                                color: isDark ? Colors.white : Colors.black87,
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
                            height: 52,
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
                                  : const Text(
                                      'Continue',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ] else ...[
                          // OTP Verification State
                          Text(
                            'OTP sent to $_targetPhone',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF1E90FF),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            key: const ValueKey('main_otp_input'),
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
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
                            height: 52,
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
                                  : const Text(
                                      'Verify OTP',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                                  style: TextStyle(
                                    color: isDark ? Colors.grey : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        _requestMockPhoneOtp(_targetPhone);
                                      },
                                child: const Text(
                                  'Resend OTP',
                                  style: TextStyle(
                                    color: Color(0xFF1E90FF),
                                    fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
