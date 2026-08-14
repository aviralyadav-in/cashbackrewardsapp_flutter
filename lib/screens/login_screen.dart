import 'package:flutter/material.dart';
import '../models/country.dart';
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
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _handleInitialSubmit() async {
    if (!_mainFormKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isPhoneMode) {
        // Flow 2 / Flow 3: Send OTP directly to phone number.
        // DO NOT read Firestore before authentication to prevent permission-denied.
        final phone = _formatPhoneNumber(_phoneController.text);
        _targetPhone = phone;
        await _requestPhoneOtp(phone);
      } else {
        // Flow 1: New User with Email or Existing Email user
        final email = _emailController.text.trim().toLowerCase();

        setState(() {
          _isLoading = false;
        });

        // Prompt for Full Name & Phone Number in Bottom Sheet to perform OTP verification
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

  Future<void> _requestPhoneOtp(String phone) async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 400));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isOtpSent = true;
      });
      _showSnackBar('OTP sent successfully to $phone', isError: false);
    }
  }

  Future<void> _verifyEnteredOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length < 6) {
      _showSnackBar('Please enter valid 6-digit OTP');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    }
  }



  // ==========================================
  // BOTTOM SHEET: Flow 1 (New User with Email)
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF161618),
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

              await Future.delayed(const Duration(milliseconds: 400));

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

              await Future.delayed(const Duration(milliseconds: 500));

              if (context.mounted) {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
              }
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
                            color: Colors.grey.shade700,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Complete Registration',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Registering with: $email',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (!isOtpSentInSheet) ...[
                        TextFormField(
                          key: const ValueKey('sheet_name_input'),
                          controller: nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: _buildInputDecoration(
                            label: 'Full Name',
                            icon: Icons.person_outline,
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
                            color: Colors.redAccent,
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            letterSpacing: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: _buildInputDecoration(
                            label: 'Enter 6-digit OTP',
                            icon: Icons.lock_clock_outlined,
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
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: Colors.grey.shade400),
      hintStyle: TextStyle(color: Colors.grey.shade600),
      filled: true,
      fillColor: const Color(0xFF1A1A1A),
      prefixIcon: Icon(icon, color: Colors.grey.shade400),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF2E2E2E)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF2E2E2E)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 2,
        ),
      ),
    );
  }

  ButtonStyle _buildButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.redAccent,
      foregroundColor: Colors.white,
      elevation: 6,
      shadowColor: Colors.red.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF000000),
              Color(0xFF180000),
              Color(0xFF000000),
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
                  // App Logo
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF121212),
                        border: Border.all(
                          color: Colors.redAccent.withValues(alpha: 0.8),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withValues(alpha: 0.4),
                            blurRadius: 30,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.card_giftcard,
                        size: 50,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'CashKaro',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'HandwrittenItalic',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Login or Sign Up to continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Mode Selector Tabs (Phone / Email)
                  if (!_isOtpSent)
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF2E2E2E)),
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
                                  color: _isPhoneMode
                                      ? Colors.redAccent
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  'Phone Number',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: _isPhoneMode
                                        ? FontWeight.bold
                                        : FontWeight.normal,
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
                                  color: !_isPhoneMode
                                      ? Colors.redAccent
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  'Email',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: !_isPhoneMode
                                        ? FontWeight.bold
                                        : FontWeight.normal,
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
                          if (_isPhoneMode)
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
                            )
                          else
                            TextFormField(
                              key: const ValueKey('main_email_input'),
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              decoration: _buildInputDecoration(
                                label: 'Email Address',
                                icon: Icons.email_outlined,
                                hint: 'user@example.com',
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
                              color: Colors.redAccent,
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              letterSpacing: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: _buildInputDecoration(
                              label: 'Enter 6-Digit OTP',
                              icon: Icons.lock_clock_outlined,
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
                                child: const Text(
                                  'Change Number',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              TextButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        _requestPhoneOtp(_targetPhone);
                                      },
                                child: const Text(
                                  'Resend OTP',
                                  style: TextStyle(
                                    color: Colors.redAccent,
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
