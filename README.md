🍽️ PurePlate: A Personalized Recipe Recommendation App
Team Members

Mustafa Derin (32272) – Integration & Repository Lead

Simay Otlaca (30804) – Documentation & Submission Lead

Ali Berkay Şahin (33996) – Project Coordinator

Elif Defne Çelik (32233) – Presentation & Communication Lead

Ceren Şenol (33914) – Learning & Research Lead

Ahmet Mert Kara (32443) – Testing & Quality Assurance Lead

🧩 Project Overview

PurePlate is a mobile application that helps users track their daily calorie intake and receive personalized recipe recommendations dynamically filtered based on:

Remaining daily calorie budget

Available ingredients at home

Preferred preparation time

It also includes a Dynamic Calorie Visualization Ring that provides immediate visual feedback, helping users plan meals that are healthy, quick, and waste-reducing.

🎯 Problem Statement

Modern lifestyles make it difficult for users to find recipes that:

Fit within their nutritional and calorie goals

Can be prepared within limited time constraints

Utilize ingredients they already have

This often leads to diet inconsistencies, time waste, and food waste.

💡 Our Solution

PurePlate tackles these challenges by dynamically filtering recipes according to three main constraints:

Remaining daily calories

Maximum preparation time

Available ingredients

The result is an instant list of personalized, relevant recipes that:

Fit within the user’s nutritional limits

Can be made quickly

Reduce ingredient waste

👥 Target Audience
Group	Description
University Students & Working Adults	Want fast, affordable, and easy-to-prepare meals.
Calorie-Conscious Users	Need recipes that fit precise calorie limits.
Waste-Conscious Consumers	Want to use ingredients they already have efficiently.
⚙️ Core Features
1. Calorie Tracking

Users can log daily meals and calories to monitor progress toward their daily goal.

2. Dynamic Calorie Visualization (NEW)

A circular progress ring visually displays remaining calories.
Each recipe shows how much it would “fill” the user’s remaining budget.

3. Calorie-Based Recipe Suggestions

PurePlate automatically recommends recipes that match or stay under the user’s calorie allowance.

4. Time-Based Filtering

Users can specify a maximum prep/cook time (e.g., 10–20 minutes).

5. Ingredient-Based Filtering

Users select ingredients they have, and PurePlate suggests recipes using those only.

🌟 Nice-to-Have Features (Planned Enhancements)
Feature	Description
Recipe Modifier	Adjust portions, recalculate calories, or swap ingredients.
Quick Log from History	Quickly log meals previously cooked or saved.
Preference Learning (Non-ML)	Prioritize recipes based on user history using a lightweight scoring system.
Meal Scheduling & Reminders	Plan meals for specific times and receive notifications.
Pantry Score (Gamification)	Earn badges for reducing food waste through efficient ingredient usage.
Photo-Based Ingredient Recognition (Optional)	Detect fridge/pantry ingredients through photo input (future feature).
🧠 Technical Overview
Platform

Developed using Flutter for cross-platform deployment (Android & iOS).

Ensures smooth, consistent user experience across devices.

Data Storage

Uses Firebase Firestore (NoSQL) for fast and flexible cloud data management.

Data Type	Description
User Profiles & Preferences	Stores dietary restrictions, cuisine types, and personal info.
Calorie Logs	Tracks daily meals and calorie totals.
Recipe Catalog	Includes recipe details: ingredients, calories, and preparation steps.
User Interaction History	Keeps track of favorites, attempted recipes, and ratings.
⚠️ Potential Challenges
Challenge	Description
Recipe-Ingredient-Calorie Alignment	Building a consistent dataset with accurate calorie, time, and ingredient details.
User Input Normalization	Handling inconsistent user inputs like "a handful of nuts" or "medium apple."
Efficient Filtering	Combining calorie, ingredient, and time filters efficiently without slowing the app.
Preference Tracking Without ML	Implementing a lightweight recommendation system using frequency scoring.
💎 Unique Selling Proposition (USP)

PurePlate stands out because it combines three major filters simultaneously:

Daily calorie goal

Time constraint

Available ingredients

Most existing recipe apps use one or two of these factors.
PurePlate’s unique triple-filter approach, coupled with the Dynamic Calorie Visualization Ring, makes meal planning faster, more relevant, and health-aware—without the complexity of heavy machine learning models.

🧰 Tech Stack
Layer	Technology
Frontend (Mobile)	Flutter
