import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_plate/widgets/pureplate_app_scaffold.dart';
import 'package:pure_plate/providers/user_profile_provider.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white24),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              hintStyle: TextStyle(color: Colors.white30),
            ),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.tealAccent,
          inactiveTrackColor: Colors.white10,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = context.watch<UserProfileProvider>();

    if (userProfileProvider.isLoading || !_isInitialized) {
      return PurePlateAppScaffold(
        pageIndex: 2,
        body: Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.black)),
            Center(child: CircularProgressIndicator(color: Colors.tealAccent)),
          ],
        ),
      );
    }

    return PurePlateAppScaffold(
      pageIndex: 2,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=1353',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.95),
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.0,
                            shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 48),
                    ],
                  ),
                  SizedBox(height: 30),

                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.tealAccent.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            )
                          ],
                          border: Border.all(color: Colors.tealAccent, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.black54,
                          child: Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.tealAccent,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.camera_alt, size: 20, color: Colors.black),
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

                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white.withOpacity(0.15)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Personal Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 20),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.teal.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.restaurant_menu, color: Colors.tealAccent),
                                SizedBox(width: 10),
                                Text(
                                  'Dietary Preferences',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              'These affect recommendations',
                              style: TextStyle(
                                color: Colors.white54,
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 15),
                            _buildPreferenceSwitch(
                              label: 'Gluten-free',
                              value: _isGlutenFree,
                              onChanged: (val) => setState(() => _isGlutenFree = val),
                            ),
                            Divider(color: Colors.white24),
                            _buildPreferenceSwitch(
                              label: 'Vegetarian',
                              value: _isVegetarian,
                              onChanged: (val) => setState(() => _isVegetarian = val),
                            ),
                            Divider(color: Colors.white24),
                            _buildPreferenceSwitch(
                              label: 'Lactose-free',
                              value: _isLactoseFree,
                              onChanged: (val) => setState(() => _isLactoseFree = val),
                            ),
                            Divider(color: Colors.white24),
                            _buildPreferenceSwitch(
                              label: 'Low-carb',
                              value: _isLowCarb,
                              onChanged: (val) => setState(() => _isLowCarb = val),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.orangeAccent.withOpacity(0.5),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.flag,
                                  color: Colors.orangeAccent,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Daily Goals',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
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
                    ),
                  ),
                  SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _saveChanges,
                      icon: Icon(Icons.save),
                      label: Text(
                        'Save Changes',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.tealAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}