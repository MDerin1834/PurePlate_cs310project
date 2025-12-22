import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_plate/widgets/pureplate_app_scaffold.dart';
import 'package:pure_plate/providers/user_profile_provider.dart';
import 'package:pure_plate/models/user_profile.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _dietTypeController;
  late TextEditingController _calorieTargetController;
  late TextEditingController _proteinTargetController;

  late bool _isGlutenFree;
  late bool _isVegetarian;
  late bool _isLactoseFree;
  late bool _isLowCarb;

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final userProfileProvider = context.watch<UserProfileProvider>();
      final profile = userProfileProvider.userProfile;

      if (profile != null) {
        _nameController = TextEditingController(text: profile.name);
        _ageController = TextEditingController(text: profile.age.toString());
        _dietTypeController = TextEditingController(text: profile.dietType);
        _calorieTargetController =
            TextEditingController(text: profile.calorieTarget.toString());
        _proteinTargetController =
            TextEditingController(text: profile.proteinTarget.toString());

        _isGlutenFree = profile.isGlutenFree;
        _isVegetarian = profile.isVegetarian;
        _isLactoseFree = profile.isLactoseFree;
        _isLowCarb = profile.isLowCarb;

        _isInitialized = true;
      }
    }
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _nameController.dispose();
      _ageController.dispose();
      _dietTypeController.dispose();
      _calorieTargetController.dispose();
      _proteinTargetController.dispose();
    }
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final userProfileProvider = context.read<UserProfileProvider>();
    final currentProfile = userProfileProvider.userProfile;

    if (currentProfile == null) return;

    final updatedProfile = currentProfile.copyWith(
      name: _nameController.text.trim(),
      age: int.tryParse(_ageController.text) ?? currentProfile.age,
      dietType: _dietTypeController.text.trim(),
      calorieTarget: int.tryParse(_calorieTargetController.text) ??
          currentProfile.calorieTarget,
      proteinTarget: int.tryParse(_proteinTargetController.text) ??
          currentProfile.proteinTarget,
      isGlutenFree: _isGlutenFree,
      isVegetarian: _isVegetarian,
      isLactoseFree: _isLactoseFree,
      isLowCarb: _isLowCarb,
    );

    await userProfileProvider.updateProfile(updatedProfile);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Profile updated successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context);
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 3,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildPreferenceSwitch({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyLarge,
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: theme.colorScheme.primary,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProfileProvider = context.watch<UserProfileProvider>();

    if (userProfileProvider.isLoading || !_isInitialized) {
      return PurePlateAppScaffold(
        pageIndex: 2,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return PurePlateAppScaffold(
      pageIndex: 2,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    'Edit Profile',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 48),
              ],
            ),
            SizedBox(height: 20),

            // Profile Image
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: theme.colorScheme.primary,
                  child: Icon(
                    Icons.account_circle,
                    size: 120,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: theme.colorScheme.primary,
                    radius: 20,
                    child: IconButton(
                      icon: Icon(Icons.camera_alt, size: 20, color: Colors.white),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Image picker not implemented yet')),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            // Editable Fields
            _buildTextField(
              label: 'Name',
              controller: _nameController,
            ),
            SizedBox(height: 15),

            _buildTextField(
              label: 'Age',
              controller: _ageController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 15),

            _buildTextField(
              label: 'Diet Type',
              controller: _dietTypeController,
            ),
            SizedBox(height: 15),

            _buildTextField(
              label: 'Calorie Target',
              controller: _calorieTargetController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 25),

            // Dietary Preferences Block
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary,
                  width: 3,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.restaurant_menu,
                        color: theme.colorScheme.primary,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Dietary Preferences',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    'These preferences affect recipe recommendations',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 15),
                  _buildPreferenceSwitch(
                    label: 'Gluten-free',
                    value: _isGlutenFree,
                    onChanged: (val) => setState(() => _isGlutenFree = val),
                  ),
                  Divider(),
                  _buildPreferenceSwitch(
                    label: 'Vegetarian',
                    value: _isVegetarian,
                    onChanged: (val) => setState(() => _isVegetarian = val),
                  ),
                  Divider(),
                  _buildPreferenceSwitch(
                    label: 'Lactose-free',
                    value: _isLactoseFree,
                    onChanged: (val) => setState(() => _isLactoseFree = val),
                  ),
                  Divider(),
                  _buildPreferenceSwitch(
                    label: 'Low-carb',
                    value: _isLowCarb,
                    onChanged: (val) => setState(() => _isLowCarb = val),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),

            // Protein Target
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.green.shade700,
                  width: 3,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.flag,
                        color: Colors.green.shade700,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Daily Goals',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  _buildTextField(
                    label: 'Daily Protein Target (g)',
                    controller: _proteinTargetController,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Save Changes Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _saveChanges,
                icon: Icon(Icons.save),
                label: Text(
                  'Save Changes',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}