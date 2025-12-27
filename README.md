# PurePlate: Personalized Recipe Recommendation App

### Developed by:
**Mustafa Derin (32272)** | **Simay Otlaca (30804)** | **Ali Berkay Şahin (33996)**  
**Ceren Şenol (33914)** | **Ahmet Mert Kara (32443)**

---

## Project Overview

**PurePlate** is a mobile application that helps users **track their daily calorie intake** and receive **personalized recipe suggestions** based on:
- Remaining calorie budget  
- Available ingredients  
- Preferred preparation time  

With its **dynamic calorie visualization ring**, users receive instant visual feedback about how each recipe fits within their calorie goals — making healthy eating easier, faster, and waste-free.

---

## Problem & Solution

### The Problem
In today’s fast-paced world, individuals struggle to:
- Find recipes that match their **nutritional goals**,  
- Fit their **limited time**, and  
- Utilize **ingredients they already have** at home.  

This often leads to wasted food, time, and failed diet adherence.

### The Solution
**PurePlate** combines **three essential filters** — calories, time, and ingredients — to provide recipes that perfectly fit user constraints.  
It dynamically visualizes calorie usage, helping users stay on track while minimizing waste and cooking effort.

---

## Team Roles

| Member | Role |
|--------|------|
| **Mustafa Derin** | Integration & Repository Lead |
| **Simay Otlaca** | Documentation & Submission Lead |
| **Ahmet Mert Kara** | Testing & Quality Assurance Lead |
| **Ceren Şenol** | Learning & Research Lead |
| **Ali Berkay Şahin** | Project Coordinator |

---

## Target Audience

- **University Students & Working Adults** – Seeking fast, healthy, and affordable meals.  
- **Calorie-Conscious Individuals** – Wanting recipes that fit their daily calorie goals.  
- **Waste-Conscious Consumers** – Hoping to use ingredients efficiently and reduce waste.

---

## Core Features

### 1. Calorie Tracking
Users can log daily meals and their estimated calorie values.

### 2. Dynamic Calorie Visualization Ring (NEW)
A circular progress ring visually displays:
- Remaining daily calorie budget  
- Instant feedback on how much each suggested recipe will “fill up” that budget

### 3. Calorie-Based Recipe Suggestions
Recommends recipes that stay within or below the remaining daily calorie limit.

### 4. Time-Based Filtering
Users can set a **maximum preparation time** (e.g., 10, 20 minutes) for fast, efficient meal options.

### 5. Ingredient-Based Filtering
Select ingredients currently available (e.g., chicken, rice, eggs) and receive recipes using those items only.

---

## Nice-to-Have Features (Future Enhancements)

- **Recipe Modifier:** Adjust portion size and substitute ingredients with automatic calorie recalculation.  
- **Quick Log from History:** Instantly log calories from previously cooked/saved recipes.  
- **Preference Learning:** Prioritize favorite ingredients/categories without ML (score-based system).  
- **Meal Scheduling & Reminders:** Plan meals and receive notifications.  
- **Pantry Score Gamification:** Earn badges and scores for minimizing food waste.  
- **Photo Ingredient Recognition (Optional):** Detect fridge/pantry ingredients using photos.

---

## Platform & Data Storage

### Platform
- Developed with **Flutter** for cross-platform mobile deployment (Android & iOS).

### Data Storage
Using **Firebase Firestore (NoSQL)** to store:
| Data Type | Description |
|------------|--------------|
| **User Profiles** | Credentials, dietary preferences, allergies, and cuisine choices. |
| **Calorie Logs** | Daily meal and calorie data for computing remaining intake. |
| **Recipe Catalog** | Recipe name, steps, calories, prep time, and ingredients. |
| **User History** | Favorite, tried, or rated recipes for personalization. |

---

## Potential Challenges

1. **Recipe-Ingredient-Calorie Alignment:** Building a consistent dataset that accurately links ingredients, calories, and cooking time.  
2. **User Input Normalization:** Handling diverse formats like “1 handful of nuts” or “100g chicken.”  
3. **Efficient Filtering Logic:** Designing algorithms that handle calorie/time/ingredient filtering fast and efficiently.  
4. **Preference Tracking (Non-ML):** Creating an effective scoring-based personalization system.

---

## Unique Selling Point (USP)

PurePlate stands out by combining **three simultaneous filters**:
1. **Calorie Goal**  
2. **Time Limit**  
3. **Available Ingredients**

While other recipe apps typically focus on only one or two of these, PurePlate delivers **a real-time, dynamic, and personalized recommendation** system.  

Combined with its **Calorie Visualization Ring**, it uniquely helps users stay mindful of health goals while minimizing waste — **without needing heavy AI or ML models**.

---

## Tech Stack Summary

| Category | Tools/Frameworks |
|-----------|------------------|
| **Frontend** | Flutter |
| **Backend** | Firebase Firestore (NoSQL) |
| **Authentication** | Firebase Auth |
| **Data Management** | Firestore Collections & Documents |
| **UI Components** | Flutter Widgets, Custom Calorie Ring Visualization |

---

## Example User Flow

1. **User logs in** and enters their daily calorie goal.  
2. **User logs meals** and remaining calories update visually via the progress ring.  
3. **User selects ingredients and time limit.**  
4. **PurePlate suggests recipes** that fit within calorie and time constraints using available ingredients.  
5. **User saves or logs recipes** for future quick selection.

---

## Contribution Breakdown by Team Member

This section summarizes each contributor’s responsibilities and major contributions based on the Git commit history.

---

## Mustafa Derin

### Architecture & State Management
- Implemented `MealLogProvider` with dependency injection  
- Designed and integrated `RecipeProvider` and `UserProvider`  
- Refactored providers for cleaner separation of concerns  
- This work significantly improved modularity and made state management easier to test and maintain.

### Data Models & Backend Integration
- Created core data models such as `MealLog` and `UserProfile`  
- Implemented service-layer abstractions for meals, recipes, and users  
- Removed deprecated user data structures and cleaned legacy code  
- These changes ensured a clear contract between UI, providers, and Firebase services.

### Testing Infrastructure
- Added `mocktail` dependency  
- Implemented unit tests for `MealLogProvider`  
- Improved testability by decoupling providers from Firebase  
- This laid the foundation for reliable automated testing without external dependencies.

### Project Documentation
- Wrote and revised `README.md` multiple times  
- Added testing overview and developer contribution list  
- Improved clarity and structure of documentation  
- The documentation now clearly communicates setup, usage, and testing expectations.

### Project Initialization & Maintenance
- Initial project setup and repository structure  
- Managed uploads of initial assets and source files  
- Maintained project consistency across refactors  
- These efforts ensured long-term maintainability and onboarding ease for new contributors.

---

## Berkay Şahin

### Authentication & Firebase Integration
- Implemented login, logout, and signup functionality  
- Fixed and improved `AuthProvider`  
- Performed Firebase setup and configuration  
- This ensured a stable and secure authentication flow throughout the application.

### Navigation & Routing
- Fixed routing issues across multiple screens  
- Prevented onboarding screen from reappearing after login  
- Managed navigation stack issues in filtering flows  
- These changes improved user experience by eliminating unexpected navigation behavior.

### UI & UX Improvements
- Enhanced home screen layout and responsiveness  
- Improved compatibility with global theme  
- Made screens landscape-orientation friendly  
- The application became more visually consistent and usable across devices.

### Recipe & Feature Enhancements
- Implemented `FilteredRecipesScreen`  
- Added favorite recipe functionality  
- Added time indicators for scheduled recipes  
- These features increased usability and personalization for end users.

### Bug Fixes & Code Cleanup
- Fixed UI rendering bugs  
- Corrected typos and minor logic errors  
- Performed general refactoring and cleanup  
- Continuous cleanup reduced technical debt and improved code stability.

---

## Simay Otlaca

### Authentication Screens
- Updated `login_screen.dart` multiple times  
- Improved login UI and validation logic  
- Enhanced error handling and user feedback  
- These improvements made authentication clearer and more user-friendly.

### Home & Records Screens
- Updated `home_screen.dart`  
- Updated `records_screen.dart`  
- Improved layout and screen consistency  
- The screens now follow a more uniform design and interaction pattern.

### Recipe Screens
- Refactored `recipe_filtering_screen.dart`  
- Updated `recipes_screen.dart` and `recipe_details_screen.dart`  
- Improved styling and readability with comments  
- This made recipe-related screens easier to understand and extend.

### Error Handling
- Improved error handling in `AuthProvider`  
- Addressed runtime issues during authentication flow  
- Reduced crashes and unexpected behavior during user login  
- These changes increased overall app reliability.

### Code Quality Improvements
- Fixed TODO typos  
- Improved code readability and maintainability  
- Verified commits to ensure repository integrity  
- This contributed to a cleaner and more professional codebase.

---

## Ahmet Mert Kara

### User Profile & Registration
- Updated `register_screen.dart`  
- Updated `profile_screen.dart` and `edit_profile_screen.dart`  
- Added user profile provider and model  
- This enabled more complete and editable user profile management.

### Meal Logging & Nutrition Logic
- Created `MealLog` model  
- Updated `meal_log_provider.dart`  
- Added dynamic protein goals  
- These changes improved nutritional tracking accuracy and flexibility.

### Scheduled Recipes
- Implemented functionality to upload scheduled recipes to Firestore  
- Fixed issues related to dynamic data updates  
- Ensured scheduled data stayed synchronized with the backend  
- This feature enhanced planning and automation for users.

### Project Configuration
- Updated `pubspec.yaml`  
- Added `devtools_options.yaml`  
- Fixed `.gitignore`  
- Proper configuration ensured smoother development and debugging workflows.

### General Maintenance
- Performed code cleanup  
- Reverted problematic changes when necessary  
- Assisted in merging branches  
- These actions helped maintain repository stability during rapid development.

---

## Ceren Şenol

### Firebase Setup
- Set up Firebase configuration files  
- Added `firebase_options.dart`  
- Assisted in initial Firebase integration  
- This work was essential for enabling backend connectivity early in development.

### Recipe Data & Models
- Updated `recipe.dart`  
- Updated `recipe_provider.dart`  
- Improved recipe-related data handling  
- These updates ensured recipes were consistently modeled and managed.

### UI Screen Updates
- Updated `recipes_screen.dart`  
- Updated `recipe_details_screen.dart`  
- Improved screen layout and behavior  
- The changes enhanced usability and visual clarity for recipe browsing.

### Theme & Visual Updates
- Updated `theme.dart`  
- Ensured UI consistency with global theme  
- Helped unify the visual identity of the application  
- This resulted in a more polished and cohesive look.

### Early Project Development
- Added initial user and recipe data  
- Created early versions of screens and models  
- Assisted with repository merges  
- These contributions played a key role in establishing the project’s initial foundation.


## Setup & Run Instructions

### Prerequisites

Flutter SDK >= 3.9.2
Dart SDK (bundled with Flutter)
Android Studio or VS Code

Firebase project with:
Firebase Authentication enabled
Cloud Firestore enabled

### Firebase Configuration

Create a Firebase project
Add Android and/or iOS apps

Download and place:
google-services.json (Android)
GoogleService-Info.plist (iOS)

Enable:
Email/Password Authentication
Firestore Database

### Install Dependencies
flutter pub get

### Run the Application
flutter run

## Testing

### Running All Tests
flutter test

## Testing Overview

This project includes both unit tests and a widget test to verify core application behavior.

### Unit Tests – MealLogProvider

The unit tests focus on the business logic and state management of MealLogProvider by mocking external dependencies (AuthProvider and MealService).
They cover:
1. Initial state validation: 
Ensures the provider starts with an empty meal list and is not loading when no user is logged in.
2. Meal loading behavior
Verifies that meals are correctly loaded from a stream when a user exists and that the loading state updates properly.
3. Daily nutrition calculations
Confirms that todayCalories and todayProtein only count meals logged on the current day.

Service interaction methods
Ensures that:
1. logMeal calls MealService.addMeal
2. updateMeal calls MealService.updateMeal
3. deleteMeal calls MealService.deleteMeal with the correct user ID and parameters.

All external services are mocked to keep the tests isolated and deterministic.

### Widget Test – Smoke Test

The widget test verifies that the main application UI builds correctly and basic user interaction works.
It covers:
1. Successful rendering of the app (MyApp)
2. Correct initial UI state
3. UI update after a button tap (counter increment)
4. This serves as a basic smoke test to ensure the app launches and responds to user interaction.

## Future Work

- Implement real-time notifications for planned meals.  
- Add gamified scoring and achievement badges.  
- Develop an image recognition module for ingredient detection.  
- Expand the recipe database with verified nutritional data.

---

## License
This project is developed as part of a **university course project** and is currently intended for educational and demonstration purposes only.

---

## Acknowledgements
We thank our course instructors and peers for their feedback and support during the project development phase.

---

### Summary
**PurePlate = Simplicity + Personalization + Awareness**  
A smart and healthy way to plan your next meal — faster, cheaper, and greener.
