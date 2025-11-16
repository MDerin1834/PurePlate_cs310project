# PurePlate: Personalized Recipe Recommendation App

### Developed by:
**Mustafa Derin (32272)** | **Simay Otlaca (30804)** | **Ali Berkay Şahin (33996)**  
**Elif Defne Çelik (32233)** | **Ceren Şenol (33914)** | **Ahmet Mert Kara (32443)**

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
| **Elif Defne Çelik** | Presentation & Communication Lead |
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
