# Task it; A simple Task Manager App written with Flutter

A Simple Task Management App

## Development Phases
### A:
1. Set up folders
2. Create Classes
3. Implement UIs
4. Add Repositories

### B:
6. Couple the classes
7. Integrate storage

### C:
8. Test with Mock data
9. Beutify UI
10. Write Tests

## Milestones:
1. Add Task [Done; Tested]
2. Delete Task [Done; Tested]
3. Edit Task [Done; Tested]
4. Display Tasks [Done; Tested]
5. Mark Tasks as completed [Done; Tested]
6. Store Locally [Done; Tested]
7. Use proper state management library (GetX) [Done; Tested]
8. Filter tasks by status: All, Active, Completed [Done; Tested]
9. Sort tasks by due date or creation date [Done; Tested] 
10. Responsive and polished UI with light/dark themes [Done; Tested]
11. Basic animations for task actions [Done; Tested]

## Instructions

### Build APK:
```
flutter build apk --release --target=lib\presentation\screen\main.dart
```

### Run Debug
```
flutter run --target=lib\presentation\screen\main.dart
```

### Run Test
```
flutter test test/task_repository_tests/mock_flutter_secure_storage.dart
```

### APKs are available at:
`/builds`

### State Management :
🧠 State Management Approach in This Project
In this project, we adopted the GetX state management solution to manage the app's logic, reactivity, and dependency injection in a clean, scalable, and testable way.

✅ Why GetX?
We chose GetX for its simplicity, minimal boilerplate, and powerful integration of:

* State management

* Navigation

* Dependency injection

This helped us keep the codebase lean while still supporting advanced features like dynamic filtering, live task updates, and UI reactivity with minimal effort.

🔁 Reactive State Management
We used GetX’s reactive programming model via .obs to automatically update the UI whenever task data changes.

Example:

```RxList<TaskItem> filteredAndSortedResults = <TaskItem>[].obs;```
This enables widgets to reactively rebuild using Obx():

```
Obx(() => ListView(
    children: controller.filteredAndSortedResults
        .map((task) => TaskCard(task))
        .toList(),
))
```

📦 Controller-Driven Architecture
Each feature screen (e.g., task list, add form) is powered by a dedicated TasksController, which:

* Handles all business logic like adding, editing, deleting tasks.

* Talks to the `TaskRepository` interface defined in the `domain` layer.

* Maintains all reactive state.

Example Responsibilities:
* `addTask()`: Adds a task via the repository and refreshes UI

* `sortAndFilter()`: Applies user-defined filtering/sorting rules

* `fetchTasksFromDevice()`: Loads and syncs tasks from local storage

This separation ensures that the UI remains dumb, and all logic stays inside the controller.

🧩 Dependency Injection with GetX
Instead of manually wiring dependencies, we used Get.put() to inject and register instances like so:

```
Get.put<TaskRepository>(TaskRepositoryImpl());
Get.put(TasksController());
```
This allowed us to easily mock dependencies in tests using Get.replace() or Get.put(MockRepo()).

🧪 Testability Benefits
Thanks to this architecture:

* Controller tests can mock the repository to test logic in isolation.

* Widget tests use GetX keys and injected dependencies to simulate real interactions.

* Dialog and form tests are deterministic and repeatable.

### 🧱 Architecture Summary
This project follows a clean layered architecture divided into three main layers:

1. Presentation Layer
* Built with Flutter widgets and GetX controllers.

* Handles UI rendering and user interaction.

* Uses Obx() and .obs for reactive updates.

* Example: TasksController manages task state and UI actions.

2. Domain Layer
* Contains entities, use cases, and abstract repositories.

* Defines the business logic without knowing how or where data is stored.

* Example: TaskRepository defines methods like addTask() and getAllTasks().

3. Data Layer
* Implements domain contracts using FlutterSecureStorage.

* Handles JSON serialization, local persistence, and API interaction (if needed).

* Example: TaskRepositoryImpl reads/writes task data securely.

🧠 Why This Matters:
* Separation of concerns = cleaner, testable, and scalable code.

* UI doesn’t depend on storage or business logic details.

* Easy to replace storage (e.g., switch to Firebase or SQLite) with zero UI changes.

### Beyond Requirements: 
Testing the APK on multiple devices using firebase Test Lab:
* I ran and tested the APK on firebase test lab. This allowed me to test on a variety of devices virtual and real devices
* I tested different device layouts, lifecycle changes, ANR, memory constraints and on slow devices.
* After running, the reports were sent to my email.

#### Image 1 (Email report after running first tests):
![a.png](imgs%2Fa.png)

#### Image 2 (Report from my firebase console):
![b.png](imgs%2Fb.png)


