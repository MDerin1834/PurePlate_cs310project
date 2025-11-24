import 'package:flutter/material.dart';
import 'package:pure_plate/widgets/pureplate_app_scaffold.dart';
import 'package:pure_plate/data/user_data.dart';

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
  late TextEditingController _passwordController;
  late TextEditingController _proteinTargetController;

  late bool _isGlutenFree;
  late bool _isVegetarian;
  late bool _isLactoseFree;
  late bool _isLowCarb;

  @override
  void initState() {
    super.initState();
    final user = currentUser;

    _nameController = TextEditingController(text: user.name);
    _ageController = TextEditingController(text: user.age.toString());
    _dietTypeController = TextEditingController(text: user.dietType);
    _calorieTargetController =
        TextEditingController(text: user.calorieTarget.toString());
    _passwordController = TextEditingController();
    _proteinTargetController =
        TextEditingController(text: user.proteinTarget.toString());

    _isGlutenFree = user.isGlutenFree;
    _isVegetarian = user.isVegetarian;
    _isLactoseFree = user.isLactoseFree;
    _isLowCarb = user.isLowCarb;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _dietTypeController.dispose();
    _calorieTargetController.dispose();
    _passwordController.dispose();
    _proteinTargetController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    currentUser = currentUser.copyWith(
      name: _nameController.text,
      age: int.tryParse(_ageController.text) ?? currentUser.age,
      dietType: _dietTypeController.text,
      calorieTarget:
      int.tryParse(_calorieTargetController.text) ?? currentUser.calorieTarget,
      proteinTarget:
      int.tryParse(_proteinTargetController.text) ?? currentUser.proteinTarget,
      isGlutenFree: _isGlutenFree,
      isVegetarian: _isVegetarian,
      isLactoseFree: _isLactoseFree,
      isLowCarb: _isLowCarb,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
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
          obscureText: obscureText,
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
                  child: ClipOval(
                    child: Image.asset(
                      'lib/assets/images/default_profile.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.account_circle,
                          size: 120,
                          color: Colors.white,
                        );
                      },
                    ),
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
                          SnackBar(content: Text('Image picker not implemented yet')),
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
            SizedBox(height: 15),

            _buildTextField(
              label: 'Password',
              controller: _passwordController,
              obscureText: true,
            ),
            SizedBox(height: 25),

            // Fixed Preferences Block
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

            // Editable Goals
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
                        'Goals',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  _buildTextField(
                    label: 'Daily Calorie Target (kcal)',
                    controller: _calorieTargetController,
                    keyboardType: TextInputType.number,
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