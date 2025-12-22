import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_plate/providers/auth_provider.dart';
import 'package:pure_plate/providers/user_profile_provider.dart';
import 'package:pure_plate/widgets/pureplate_app_scaffold.dart';

class ProfileInfoCard extends StatelessWidget {
  final String title;
  final String value;

  const ProfileInfoCard({
    required this.title,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.primary,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class GoalsCard extends StatelessWidget {
  final String title;
  final List<String> goals;

  const GoalsCard({
    required this.title,
    required this.goals,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green.shade900,
            ),
          ),
          SizedBox(height: 10),
          ...goals.map((goal) => Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green.shade700,
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    goal,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProfileProvider = context.watch<UserProfileProvider>();
    final userProfile = userProfileProvider.userProfile;

    if (userProfileProvider.isLoading || userProfile == null) {
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
            Text(
              'My Profile',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // Profile Image
            CircleAvatar(
              radius: 60,
              backgroundColor: theme.colorScheme.primary,
              child: Icon(
                Icons.account_circle,
                size: 120,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),

            // Personal Info Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary,
                  width: 3,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal Info',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 15),
                  ProfileInfoCard(title: 'Name', value: userProfile.name),
                  SizedBox(height: 8),
                  ProfileInfoCard(title: 'Age', value: '${userProfile.age} years'),
                  SizedBox(height: 8),
                  ProfileInfoCard(title: 'Diet Type', value: userProfile.dietType),
                  SizedBox(height: 8),
                  ProfileInfoCard(
                    title: 'Calorie Target',
                    value: '${userProfile.calorieTarget} kcal',
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Email Label
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.email,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: 10),
                  Text(
                    userProfile.email,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Goals Section
            GoalsCard(
              title: 'Goals',
              goals: [
                'Daily calorie intake: ${userProfile.calorieTarget} kcal',
                'Daily protein intake: ${userProfile.proteinTarget}g',
              ],
            ),
            SizedBox(height: 30),

            // Edit Profile Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/edit-profile');
                },
                icon: Icon(Icons.edit),
                label: Text(
                  'Edit Profile',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await context.read<AuthProvider>().logout();
                  Navigator.popAndPushNamed(context, '/login');
                },
                icon: Icon(Icons.logout),
                label: Text(
                  'Log Out',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}