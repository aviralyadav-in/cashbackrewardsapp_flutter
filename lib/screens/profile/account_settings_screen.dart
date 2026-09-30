import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';
import '../auth/login_screen.dart';

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

  /// Currently displayed avatar URL (network/asset) or null if local file is picked.
  String? _currentAvatarUrl;

  /// Locally picked image file (not yet uploaded).
  File? _pickedImageFile;

  bool _isUploadingPhoto = false;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _nameController = TextEditingController(text: userProvider.fullName);
    _emailController = TextEditingController(text: userProvider.email);

    final av = userProvider.avatarUrl;
    _currentAvatarUrl = (av.isNotEmpty && !av.startsWith('assets/'))
        ? av
        : null; // null means show default asset

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

  /// Opens a bottom sheet to let user pick photo from gallery or camera.
  void _showImagePickerSheet(bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Update Profile Photo',
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Choose a photo from your gallery or take one with your camera.',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                _buildPickerOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Choose from Gallery',
                  subtitle: 'Pick an existing photo',
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(sheetCtx);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 12),
                _buildPickerOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Take a Photo',
                  subtitle: 'Use your camera',
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(sheetCtx);
                    _pickImage(ImageSource.camera);
                  },
                ),
                if (_currentAvatarUrl != null || _pickedImageFile != null) ...[
                  const SizedBox(height: 12),
                  _buildPickerOption(
                    icon: Icons.delete_outline_rounded,
                    label: 'Remove Photo',
                    subtitle: 'Use default avatar',
                    isDark: isDark,
                    isDestructive: true,
                    onTap: () {
                      Navigator.pop(sheetCtx);
                      setState(() {
                        _pickedImageFile = null;
                        _currentAvatarUrl = null;
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive
        ? AppColors.error
        : (isDark ? AppColors.darkPrimary : AppColors.accentBlue);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: isDestructive
                          ? AppColors.error
                          : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 800,
        maxHeight: 800,
      );
      if (picked == null) return;

      // Read bytes using XFile.readAsBytes() — works on ALL platforms
      // (Android, iOS, Desktop, Web) without needing dart:io directly.
      final bytes = await picked.readAsBytes();
      final mimeType = picked.mimeType ?? 'image/jpeg';
      final fileName = picked.name.isNotEmpty ? picked.name : 'avatar.jpg';

      if (!mounted) return;
      setState(() {
        _pickedImageFile = File(picked.path);
      });

      // Upload right away with bytes
      await _uploadPickedImage(bytes, mimeType, fileName);
    } catch (e) {
      _showSnackBar('Could not access photos. Check permissions.', isError: true);
    }
  }

  Future<void> _uploadPickedImage(
    List<int> imageBytes,
    String mimeType,
    String fileName,
  ) async {
    if (!mounted) return;
    setState(() => _isUploadingPhoto = true);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final url = await userProvider.uploadAvatarImage(
      imageBytes: imageBytes,
      mimeType: mimeType,
      fileName: fileName,
    );

    if (!mounted) return;
    setState(() => _isUploadingPhoto = false);

    if (url != null) {
      setState(() {
        _currentAvatarUrl = url;
        _pickedImageFile = null; // backend URL is now canonical
      });
      _showSnackBar('Profile photo updated!', isError: false);
    } else {
      setState(() => _pickedImageFile = null);
      _showSnackBar(
        userProvider.errorMessage ?? 'Photo upload failed. Please try again.',
        isError: true,
      );
    }
  }

  Future<void> _handleSaveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Phone number cannot be changed by the user; preserve existing phone number
    final existingPhone = userProvider.phoneNumber;

    // Avatar URL: if user removed it, pass null (or empty); otherwise the current URL
    final String? avatarToSave = _currentAvatarUrl;

    final success = await userProvider.updateUserProfile(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: existingPhone,
      avatarUrl: avatarToSave,
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

  void _showDeleteAccountSheet(bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => _DeleteAccountSheet(isDark: isDark),
    );
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
                    // ── Profile Photo Section ────────────────────────────────
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _isUploadingPhoto
                                ? null
                                : () => _showImagePickerSheet(isDark),
                            child: Stack(
                              children: [
                                // Avatar Circle
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isDark
                                          ? AppColors.darkPrimary.withValues(alpha: 0.6)
                                          : AppColors.accentBlue.withValues(alpha: 0.45),
                                      width: 2.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.10),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: _buildAvatarImage(isDark),
                                  ),
                                ),
                                // Upload indicator overlay
                                if (_isUploadingPhoto)
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black.withValues(alpha: 0.45),
                                      ),
                                      child: const Center(
                                        child: SizedBox(
                                          width: 28,
                                          height: 28,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                // Camera edit badge
                                if (!_isUploadingPhoto)
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isDark ? AppColors.darkPrimary : AppColors.accentBlue,
                                        border: Border.all(
                                          color: isDark ? AppColors.darkBackground : Colors.white,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.2),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton.icon(
                            onPressed: _isUploadingPhoto
                                ? null
                                : () => _showImagePickerSheet(isDark),
                            icon: Icon(
                              Icons.edit_rounded,
                              size: 14,
                              color: isDark ? AppColors.darkPrimary : AppColors.accentBlue,
                            ),
                            label: Text(
                              _isUploadingPhoto ? 'Uploading...' : 'Change Profile Photo',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.darkPrimary : AppColors.accentBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Divider ──────────────────────────────────────────────
                    Divider(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                      thickness: 0.8,
                    ),

                    const SizedBox(height: 24),

                    // ── Full Name Field ──────────────────────────────────────
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

                    // ── Email Address Field ──────────────────────────────────
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

                    // ── Phone Number Field (Disabled / Read-only) ─────────────
                    Row(
                      children: [
                        Text(
                          'Phone Number',
                          style: AppTextStyles.cardTitle(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ).copyWith(fontSize: 13.5),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.lock_rounded,
                          size: 13,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    IgnorePointer(
                      ignoring: true,
                      child: TextFormField(
                        controller: _phoneController,
                        readOnly: true,
                        enableInteractiveSelection: false,
                        keyboardType: TextInputType.phone,
                        style: AppTextStyles.input(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                        decoration: _buildInputDecoration(
                          label: 'No phone number registered',
                          icon: Icons.phone_outlined,
                          isDark: isDark,
                          prefixText: _phoneController.text.isNotEmpty ? '+91 ' : null,
                          suffixIcon: Tooltip(
                            message: 'Phone number cannot be changed',
                            child: Icon(
                              Icons.lock_outline_rounded,
                              size: 18,
                              color: isDark
                                  ? AppColors.darkTextSecondary.withValues(alpha: 0.6)
                                  : AppColors.textMuted,
                            ),
                          ),
                          isEnabled: false,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 4),
                      child: Text(
                        'Phone number is linked to your account and cannot be changed.',
                        style: AppTextStyles.caption(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                        ).copyWith(fontSize: 11.5),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Save Changes Button ──────────────────────────────────
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: (userProvider.isLoading || _isUploadingPhoto)
                            ? null
                            : _handleSaveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? AppColors.darkPrimary : AppColors.accentBlue,
                          foregroundColor: Colors.white,
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
                                  color: Colors.white,
                                ).copyWith(fontSize: 15),
                              ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Danger Zone: Delete Account ──────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.error.withValues(alpha: 0.06)
                            : const Color(0xFFFFF5F5),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: isDark ? 0.3 : 0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                size: 18,
                                color: AppColors.error,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Danger Zone',
                                style: AppTextStyles.cardTitle(
                                  color: AppColors.error,
                                ).copyWith(fontSize: 13.5),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Permanently delete your account, wallet balance, and order history.',
                            style: AppTextStyles.caption(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            ).copyWith(fontSize: 12),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: OutlinedButton.icon(
                              onPressed: () => _showDeleteAccountSheet(isDark),
                              icon: const Icon(Icons.delete_forever_rounded, size: 18),
                              label: const Text('Delete My Account'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.error,
                                side: BorderSide(
                                  color: AppColors.error.withValues(alpha: 0.5),
                                  width: 1.2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Renders the avatar: local picked file > network URL > default asset.
  Widget _buildAvatarImage(bool isDark) {
    if (_pickedImageFile != null) {
      return Image.file(
        _pickedImageFile!,
        fit: BoxFit.cover,
        width: 100,
        height: 100,
        errorBuilder: (context, error, stackTrace) => _defaultAvatarWidget(isDark),
      );
    }
    if (_currentAvatarUrl != null && _currentAvatarUrl!.isNotEmpty) {
      return Image.network(
        _currentAvatarUrl!,
        fit: BoxFit.cover,
        width: 100,
        height: 100,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: progress.expectedTotalBytes != null
                  ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
              color: isDark ? AppColors.darkPrimary : AppColors.accentBlue,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _defaultAvatarWidget(isDark),
      );
    }
    return Image.asset(
      'assets/avatars/avatar.png',
      fit: BoxFit.cover,
      width: 100,
      height: 100,
      errorBuilder: (context, error, stackTrace) => _defaultAvatarWidget(isDark),
    );
  }

  Widget _defaultAvatarWidget(bool isDark) {
    return Container(
      color: isDark ? const Color(0xFF1E1A33) : const Color(0xFFF3F6FE),
      child: Icon(
        Icons.person_rounded,
        size: 52,
        color: isDark ? AppColors.darkPrimary : AppColors.accentBlue,
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
    required bool isDark,
    String? prefixText,
    Widget? suffixIcon,
    bool isEnabled = true,
  }) {
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    return InputDecoration(
      hintText: label,
      hintStyle: AppTextStyles.hint(
        color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
      ),
      filled: true,
      fillColor: !isEnabled
          ? (isDark
              ? AppColors.darkCard.withValues(alpha: 0.5)
              : const Color(0xFFF3F4F6))
          : (isDark ? AppColors.darkCard : AppColors.cardBackground),
      prefixText: prefixText,
      prefixStyle: AppTextStyles.input(
        color: !isEnabled
            ? (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary)
            : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
      ).copyWith(fontWeight: FontWeight.w600),
      prefixIcon: Icon(
        icon,
        color: !isEnabled
            ? (isDark
                ? AppColors.darkTextSecondary.withValues(alpha: 0.6)
                : AppColors.textMuted)
            : (isDark ? AppColors.darkTextSecondary : AppColors.primaryBrown),
        size: 20,
      ),
      suffixIcon: suffixIcon,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        borderSide: BorderSide(
          color: !isEnabled
              ? (isDark
                  ? AppColors.darkBorder.withValues(alpha: 0.5)
                  : AppColors.border.withValues(alpha: 0.6))
              : borderColor,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        borderSide: BorderSide(
          color: !isEnabled
              ? (isDark
                  ? AppColors.darkBorder.withValues(alpha: 0.5)
                  : AppColors.border.withValues(alpha: 0.6))
              : borderColor,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        borderSide: BorderSide(
          color: isDark
              ? AppColors.darkBorder.withValues(alpha: 0.5)
              : AppColors.border.withValues(alpha: 0.6),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        borderSide: BorderSide(
          color: isDark ? AppColors.darkPrimary : AppColors.accentBlue,
          width: 1.5,
        ),
      ),
    );
  }
}

/// Bottom Sheet for Account Deletion with reason selection and warnings
class _DeleteAccountSheet extends StatefulWidget {
  final bool isDark;

  const _DeleteAccountSheet({required this.isDark});

  @override
  State<_DeleteAccountSheet> createState() => _DeleteAccountSheetState();
}

class _DeleteAccountSheetState extends State<_DeleteAccountSheet> {
  final List<String> _reasons = const [
    'I have another account',
    'Not getting enough cashback / deals',
    'Privacy or security concerns',
    'Facing technical issues with the app',
    'Too many notifications or messages',
    'Other reason',
  ];

  String? _selectedReason = 'I have another account';
  final _feedbackController = TextEditingController();
  bool _confirmAcknowledge = false;
  bool _isDeleting = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _handleDelete() async {
    if (!_confirmAcknowledge) return;

    setState(() => _isDeleting = true);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final reasonText = _selectedReason ?? 'Other';
    final feedbackText = _selectedReason == 'Other reason'
        ? _feedbackController.text.trim()
        : null;

    final result = await userProvider.deleteAccount(
      reason: reasonText,
      feedback: feedbackText,
    );

    if (!mounted) return;

    if (result['success'] == true) {
      Navigator.of(context).pop(); // Close bottom sheet
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your account has been permanently deleted.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } else {
      setState(() => _isDeleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Failed to delete account. Please try again.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Title Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_forever_rounded,
                      color: AppColors.error,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delete Account',
                          style: AppTextStyles.cardTitle(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ).copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'This action cannot be undone',
                          style: AppTextStyles.caption(
                            color: AppColors.error,
                          ).copyWith(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Reason description
              Text(
                'Why do you want to delete your account?',
                style: AppTextStyles.cardTitle(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ).copyWith(fontSize: 14),
              ),
              const SizedBox(height: 6),
              Text(
                'Please select a reason so we can improve our services:',
                style: AppTextStyles.caption(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                ).copyWith(fontSize: 12),
              ),
              const SizedBox(height: 12),

              // Reasons Radio Tiles
              ..._reasons.map((reason) {
                final isSelected = _selectedReason == reason;
                return InkWell(
                  onTap: _isDeleting
                      ? null
                      : () => setState(() => _selectedReason = reason),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark
                              ? AppColors.error.withValues(alpha: 0.12)
                              : const Color(0xFFFFF1F1))
                          : (isDark ? AppColors.darkCard : Colors.grey.shade50),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.error.withValues(alpha: 0.6)
                            : (isDark ? AppColors.darkBorder : AppColors.border),
                        width: isSelected ? 1.2 : 0.8,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          size: 18,
                          color: isSelected ? AppColors.error : Colors.grey,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            reason,
                            style: AppTextStyles.body(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ).copyWith(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              // If 'Other reason' is selected, show optional feedback input
              if (_selectedReason == 'Other reason') ...[
                const SizedBox(height: 8),
                TextField(
                  controller: _feedbackController,
                  enabled: !_isDeleting,
                  maxLines: 2,
                  style: AppTextStyles.input(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Tell us more (optional)...',
                    hintStyle: AppTextStyles.hint(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                    ),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E1C2A) : Colors.white,
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // Consequences / Warning Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF2A1515)
                      : const Color(0xFFFFF0F0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.35),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.error,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Consequences of Deletion',
                          style: AppTextStyles.cardTitle(
                            color: AppColors.error,
                          ).copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildWarningBullet(
                      'All wallet cashback and pending rewards will be forfeited.',
                      isDark,
                    ),
                    const SizedBox(height: 4),
                    _buildWarningBullet(
                      'Your order history, coupons, and referral bonuses will be deleted.',
                      isDark,
                    ),
                    const SizedBox(height: 4),
                    _buildWarningBullet(
                      'You cannot recover or reactivate this account once deleted.',
                      isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Acknowledge Checkbox
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                value: _confirmAcknowledge,
                activeColor: AppColors.error,
                onChanged: _isDeleting
                    ? null
                    : (val) => setState(() => _confirmAcknowledge = val ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  'I understand that this action is permanent and all my cashback data will be lost.',
                  style: AppTextStyles.caption(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ).copyWith(fontSize: 12),
                ),
              ),

              const SizedBox(height: 18),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isDeleting ? null : () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
                        ),
                        side: BorderSide(
                          color: isDark ? AppColors.darkBorder : AppColors.border,
                        ),
                      ),
                      child: Text(
                        'Keep Account',
                        style: AppTextStyles.buttonText(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ).copyWith(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (_confirmAcknowledge && !_isDeleting)
                          ? _handleDelete
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        disabledBackgroundColor: AppColors.error.withValues(alpha: 0.3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
                        ),
                      ),
                      child: _isDeleting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Delete Account',
                              style: AppTextStyles.buttonText(
                                color: Colors.white,
                              ).copyWith(fontSize: 14),
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWarningBullet(String text, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• ',
          style: TextStyle(
            color: AppColors.error.withValues(alpha: 0.8),
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption(
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ).copyWith(fontSize: 11.5),
          ),
        ),
      ],
    );
  }
}
