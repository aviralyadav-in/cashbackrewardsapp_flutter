import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';

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

    final phoneDigits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    final cleanPhone = phoneDigits.isNotEmpty ? '+91$phoneDigits' : '';

    // Avatar URL: if user removed it, pass null (or empty); otherwise the current URL
    final String? avatarToSave = _currentAvatarUrl;

    final success = await userProvider.updateUserProfile(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: cleanPhone,
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

                    // ── Phone Number Field ───────────────────────────────────
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
                      buildCounter: (context,
                              {required currentLength,
                              required isFocused,
                              maxLength}) =>
                          null,
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
                    const SizedBox(height: 16),
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
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
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
          color: isDark ? AppColors.darkPrimary : AppColors.accentBlue,
          width: 1.5,
        ),
      ),
    );
  }
}
