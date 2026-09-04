import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../theme/app_theme.dart';

class AccountSettingsScreen extends StatefulWidget {
  static const String routeName = '/account-settings';

  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _nameController = TextEditingController(text: userProvider.fullName);
    _emailController = TextEditingController(text: userProvider.email);

    // Extract 10-digit national number from stored phone (strips +91 if present)
    final rawPhone = userProvider.phoneNumber;
    var initialDigits = rawPhone.replaceAll(RegExp(r'\D'), '');
    if (initialDigits.startsWith('91') && initialDigits.length > 10) {
      initialDigits = initialDigits.substring(2);
    }
    if (initialDigits.length > 10) {
      initialDigits = initialDigits.substring(initialDigits.length - 10);
    }
    _phoneController = TextEditingController(text: initialDigits);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
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

  Future<void> _handleSaveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final phoneDigits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    final cleanPhone = phoneDigits.isNotEmpty ? '+91$phoneDigits' : '';

    final success = await userProvider.updateUserProfile(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: cleanPhone,
    );

    if (!mounted) return;

    if (success) {
      _showSnackBar('Profile updated successfully!', isError: false);
      Navigator.of(context).pop();
    } else {
      _showSnackBar(
        userProvider.errorMessage ?? 'Failed to save changes. Please try again.',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.mainBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.mainBackground,
        foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Edit Profile',
          style: AppTextStyles.screenHeading(
            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Title Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.border,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark
                                  ? AppColors.primaryBrown.withValues(alpha: 0.25)
                                  : AppColors.beigeSurface,
                            ),
                            child: Icon(
                              Icons.manage_accounts_rounded,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Edit Profile Information',
                                  style: AppTextStyles.sectionHeading(
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                                  ).copyWith(fontSize: 15),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Update your personal details below. Changes reflect across your profile.',
                                  style: AppTextStyles.caption(
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Full Name Field
                    Text(
                      'Full Name',
                      style: AppTextStyles.cardTitle(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ).copyWith(fontSize: 13.5),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      style: AppTextStyles.input(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                      decoration: _buildInputDecoration(
                        label: 'Enter your full name',
                        icon: Icons.person_outline_rounded,
                        isDark: isDark,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your full name';
                        }
                        if (value.trim().length < 2) {
                          return 'Name must be at least 2 characters long';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Email Address Field
                    Text(
                      'Email Address',
                      style: AppTextStyles.cardTitle(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ).copyWith(fontSize: 13.5),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: AppTextStyles.input(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                      decoration: _buildInputDecoration(
                        label: 'Enter your email address',
                        icon: Icons.email_outlined,
                        isDark: isDark,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email address';
                        }
                        final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegExp.hasMatch(value.trim())) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Phone Number Field
                    Text(
                      'Phone Number',
                      style: AppTextStyles.cardTitle(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ).copyWith(fontSize: 13.5),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      maxLength: 10,
                      buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                      style: AppTextStyles.input(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                      decoration: _buildInputDecoration(
                        label: 'Enter 10-digit phone number',
                        icon: Icons.phone_outlined,
                        isDark: isDark,
                        prefixText: '+91 ',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your phone number';
                        }
                        final clean = value.replaceAll(RegExp(r'\D'), '');
                        if (clean.length != 10) {
                          return 'Phone number must be exactly 10 digits';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // Save Changes Button
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: userProvider.isLoading ? null : _handleSaveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBrown,
                          foregroundColor: AppColors.cardBackground,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                          ),
                        ),
                        child: userProvider.isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Save Changes',
                                style: AppTextStyles.buttonText(
                                  color: AppColors.cardBackground,
                                ).copyWith(fontSize: 15),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
    required bool isDark,
    String? prefixText,
  }) {
    return InputDecoration(
      hintText: label,
      hintStyle: AppTextStyles.hint(
        color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
      ),
      filled: true,
      fillColor: isDark ? AppColors.darkCard : AppColors.cardBackground,
      prefixText: prefixText,
      prefixStyle: AppTextStyles.input(
        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
      ).copyWith(fontWeight: FontWeight.w600),
      prefixIcon: Icon(
        icon,
        color: isDark ? AppColors.darkTextSecondary : AppColors.primaryBrown,
        size: 20,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
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
        borderSide: BorderSide(
          color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
          width: 1.5,
        ),
      ),
    );
  }
}
