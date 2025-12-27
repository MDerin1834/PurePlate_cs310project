import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pure_plate/models/meal_log.dart';
import 'package:pure_plate/providers/meal_log_provider.dart';
import 'package:pure_plate/providers/auth_provider.dart';
import 'package:pure_plate/services/meal_service.dart';

/// --------------------
/// MOCKS
/// --------------------

class MockAuthProvider extends Mock implements AuthProvider {}

class MockMealService extends Mock implements MealService {}

class FakeUser {
  final String uid;
  FakeUser(this.uid);
}

void main() {
  late MockAuthProvider mockAuthProvider;
  late MockMealService mockMealService;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
    mockMealService = MockMealService();
  });

  test('initial state: empty meals & not loading when user is null', () {
    when(() => mockAuthProvider.user).thenReturn(null);

    final provider = MealLogProvider(mockAuthProvider, mockMealService);

    expect(provider.mealLogs, isEmpty);
    expect(provider.isLoading, false);
  });

  test('loads meals when user exists', () async {
    final fakeUser = FakeUser('user123');

    when(() => mockAuthProvider.user).thenReturn(fakeUser);

    final controller = StreamController<List<MealLog>>();

    when(
      () => mockMealService.getMeals('user123'),
    ).thenAnswer((_) => controller.stream);

    final provider = MealLogProvider(mockAuthProvider, mockMealService);

    // Should be loading initially
    expect(provider.isLoading, true);

    final meals = [
      MealLog(
        id: '1',
        recipeName: 'Chicken',
        calories: 500,
        protein: 40,
        createdAt: DateTime.now(),
      ),
    ];

    controller.add(meals);
    await Future.delayed(Duration.zero);

    expect(provider.isLoading, false);
    expect(provider.mealLogs.length, 1);
    expect(provider.mealLogs.first.calories, 500);

    await controller.close();
  });

  test('todayCalories and todayProtein only count today meals', () {
    when(() => mockAuthProvider.user).thenReturn(null);

    final provider = MealLogProvider(mockAuthProvider, mockMealService);

    final now = DateTime.now();

    provider
      ..mealLogs.addAll([
        MealLog(
          id: '1',
          recipeName: 'Today meal',
          calories: 300,
          protein: 20,
          createdAt: now,
        ),
        MealLog(
          id: '2',
          recipeName: 'Yesterday meal',
          calories: 700,
          protein: 50,
          createdAt: now.subtract(const Duration(days: 1)),
        ),
      ]);

    expect(provider.todayCalories, 300);
    expect(provider.todayProtein, 20);
  });

  test('logMeal calls MealService.addMeal', () async {
    final fakeUser = FakeUser('user123');

    when(() => mockAuthProvider.user).thenReturn(fakeUser);
    when(
      () => mockMealService.addMeal(any(), any(), any(), any()),
    ).thenAnswer((_) async {});

    final provider = MealLogProvider(mockAuthProvider, mockMealService);

    await provider.logMeal('Salad', 200, 10);

    verify(
      () => mockMealService.addMeal('user123', 'Salad', 200, 10),
    ).called(1);
  });

  test('updateMeal calls MealService.updateMeal', () async {
    final fakeUser = FakeUser('user123');

    when(() => mockAuthProvider.user).thenReturn(fakeUser);
    when(
      () => mockMealService.updateMeal(any(), any(), any(), any(), any()),
    ).thenAnswer((_) async {});

    final provider = MealLogProvider(mockAuthProvider, mockMealService);

    await provider.updateMeal('meal1', 'Pasta', 600, 25);

    verify(
      () => mockMealService.updateMeal('user123', 'meal1', 'Pasta', 600, 25),
    ).called(1);
  });

  test('deleteMeal calls MealService.deleteMeal', () async {
    final fakeUser = FakeUser('user123');

    when(() => mockAuthProvider.user).thenReturn(fakeUser);
    when(
      () => mockMealService.deleteMeal(any(), any()),
    ).thenAnswer((_) async {});

    final provider = MealLogProvider(mockAuthProvider, mockMealService);

    await provider.deleteMeal('meal1');

    verify(() => mockMealService.deleteMeal('user123', 'meal1')).called(1);
  });
}
