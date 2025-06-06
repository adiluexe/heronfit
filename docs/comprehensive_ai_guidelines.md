# HeronFit: Comprehensive AI Development Guidelines

**Document Version:** 2.0
**Date:** April 11, 2025 (Consolidated from v1.x documents)

## 1. Introduction

This document provides comprehensive, consolidated guidance for the AI-assisted development of the HeronFit mobile application. It merges and refines insights from previous guidance documents (`custom_instructions.md`, `ai_coding_guidelines.md`, `context.md`, `commit_message_instructions.md`) and aligns with the project charter. The goal is to ensure consistent, high-quality, maintainable, and scalable code that adheres to the project's vision and technical requirements.

**Assume:** Familiarity with the project charter, core technologies (Flutter, Dart, Riverpod, Supabase), the existing codebase structure, and the project's current status (post-60% completion).

## 2. Project Overview & Goals

- **Project:** HeronFit - A Flutter mobile application for the University of Makati gym.
- **Primary Goal:** Streamline gym operations and enhance user experience through features like session booking, real-time occupancy updates, workout tracking, and progress monitoring.
- **Target Users:** University students, faculty, and staff.
- **Backend:** Supabase (Authentication, Database, Real-time).
- **Key Technologies:** Flutter, Dart, Riverpod, Supabase.
- **Admin Web App:** Remember an associated Admin Web App interacts with the same Supabase backend. Ensure mobile app development considers potential impacts or shared data structures.
- **External Data:** `yuhonas/free-exercise-db` (Ensure proper attribution and integration strategy).

## 3. Core Principles & Non-Functional Requirements (NFRs)

Adhere strictly to the following principles and NFRs:

- **Maintainability:** Write clean, readable, and well-documented code. Use meaningful names. Keep functions short and focused. Refactor code where necessary for clarity.
- **Reusability:** Create reusable widgets, functions, and services. Leverage Flutter's composable nature. Abstract common patterns.
- **Modularity:** Design features and components in a modular way using the defined project structure. Ensure low coupling between modules.
- **Modifiability:** Structure code to be easily adaptable to future changes (e.g., fitness challenges, social integrations). Ensure the architecture supports modifications and scalability.

## 4. Architecture & Project Structure (Features-First)

Follow a **features-first** project structure:

- `lib/main.dart`: App entry point, initialization (Supabase, dotenv, Riverpod ProviderScope).
- `lib/app.dart`: MaterialApp setup, routing, theme configuration.
- `lib/core/`: Truly cross-cutting concerns.
  - `constants/`: App-wide constants.
  - `theme/`: Centralized theme (`theme.dart`).
  - `services/`: Base services/wrappers (e.g., Supabase client access, centralized error handling).
  - `utils/`: Global utility functions, formatters.
  - `guards/`: Route guards (e.g., `auth_guard.dart`).
- `lib/widgets/`: Highly reusable, generic UI components (e.g., `CustomButton`, `LoadingIndicator`, `ReusableCard`).
- `lib/features/`: Individual feature modules.
  - `<feature_name>/` (e.g., `auth`, `booking`, `home`, `profile`, `workout`, `progress`, `onboarding`, `splash`)
    - `controllers/`: Riverpod providers/controllers for state and logic.
    - `models/`: Data models specific to the feature.
    - `views/`: UI screens/pages.
    - `widgets/`: Widgets specific to the feature.
    - `services/` (Optional): Services specific to the feature if complex.
- `lib/models/`: (Optional) Core, shared data models (e.g., `UserModel`) if used across _many_ features. Prefer placing models within their primary feature module.

## 5. State Management (Riverpod)

- **Standardize on Riverpod:** Use Riverpod for all application state management. Replace any remaining `setState` calls used for managing application state. Keep `setState` _only_ for local, ephemeral UI state within `StatefulWidget`s or `ConsumerStatefulWidget`s if absolutely necessary, but strongly prefer Riverpod.
- **Provider Placement:** Define providers within the `controllers` directory of their respective feature.
- **Provider Types:** Use appropriate provider types (`Provider`, `StateProvider`, `StateNotifierProvider`, `FutureProvider`, `StreamProvider`) based on the state's nature and complexity.
- **Async State:** Handle asynchronous operations (fetching data, Supabase calls) using `FutureProvider` or `StreamProvider`. Leverage `AsyncValue` (`data`, `loading`, `error` states) in the UI (`.when()` method) for clean handling of different states.
- **Immutability:** Ensure state managed by Riverpod is immutable. Use immutable data classes (e.g., with `copyWith` methods) within `StateNotifier`s.

## 6. Coding Standards & Conventions

- **Language:** Dart (latest stable SDK specified in `pubspec.yaml`).
- **Style:** Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style) and Flutter lint rules defined in `analysis_options.yaml`. Run `flutter analyze` frequently.
- **Naming:**
  - `UpperCamelCase` for classes, enums, typedefs, and extensions.
  - `lowerCamelCase` for variables, parameters, and function/method names.
  - `lowercase_with_underscores` for file names and directories.
  - Prefix private members (`_`) only when necessary to enforce privacy within a library.
- **Comments:** Add comments for complex logic, public APIs (`///` for documentation comments), and `// TODO:` markers. Avoid redundant comments. Document public classes and methods.
- **Immutability:** Prefer immutable state and variables. Use `final` extensively.
- **`const`:** Use `const` constructors for widgets and objects wherever possible to improve performance and reduce rebuilds.
- **Null Safety:** Leverage Dart's sound null safety features fully. Avoid unnecessary null checks (`!`) and handle potential null values gracefully.

## 7. UI/UX Guidelines

- **Consistency:** Adhere strictly to the Figma design system (components, styles, spacing, typography). Perform UI audits against Figma. Refine design inconsistencies.
- **Theme:** Use `lib/core/theme/theme.dart` for all colors, typography, and widget styling. Avoid hardcoding style values directly in widgets.
- **Responsiveness:** Design layouts that adapt reasonably to different screen sizes and orientations.
- **Widgets:** Build UI by composing small, reusable widgets. Place generic widgets in `lib/widgets/` and feature-specific ones in `lib/features/<feature_name>/widgets/`. Prefer `StatelessWidget` or `ConsumerWidget` (Riverpod). Use `StatefulWidget` or `ConsumerStatefulWidget` sparingly for local UI state.
- **Loading/Error States:** Implement clear loading indicators (e.g., `CircularProgressIndicator`, skeleton screens) and user-friendly error messages/widgets, especially when handling `AsyncValue` from Riverpod.
- **Clarity:** Provide clearer labels and instructions throughout the app. Improve the onboarding flow. Review all user-facing text.
- **Assets:** Manage assets (images, fonts, `.env`) correctly via `pubspec.yaml`. Use `flutter_dotenv` for environment variables.

## 8. Backend Integration (Supabase)

- **Client:** Use the initialized Supabase client (`Supabase.instance.client`). Consider a wrapper service in `lib/core/services/supabase_service.dart` for easier testing, management, and potential abstraction.
- **Authentication:** Implement auth logic within `lib/features/auth/controllers/`. Utilize Supabase Auth features (email/pass, email verification, password recovery).
- **Database:** Interact with PostgreSQL via `supabase_flutter`. Define data models in `models/` or feature folders. Handle data operations (CRUD) within Riverpod controllers/notifiers, potentially delegating to feature-specific services.
- **Real-time:** Utilize Supabase Realtime subscriptions for live updates (e.g., gym occupancy, booking status) via `StreamProvider` in Riverpod. Ensure subscriptions are properly managed and disposed.
- **Edge Functions:** If used (e.g., for simple backend logic or proxying), define clear API endpoints, manage dependencies, and ensure secure invocation from the Flutter app.
- **Data Models:** Finalize PostgreSQL table schemas, ensuring appropriate relationships, constraints, and indexing for performance.
  - **Workout History Update:** The schema now includes `workouts`, `exercises`, `workout_exercises`, and `exercise_sets` tables to store detailed workout history. A Supabase database function `save_full_workout` is used for transactional saving of workout data.
- **Security:**
  - Implement and test comprehensive Row Level Security (RLS) policies for all tables containing user-specific or sensitive data. Ensure users can only access their own data or data they are permitted to see.
  - Use `.env` files for Supabase URL and Anon Key. Do not commit `.env` files.

## 9. Error Handling

- **Robustness:** Implement comprehensive error handling, especially for network requests (Supabase calls) and user input validation.
- **`try-catch`:** Wrap potentially failing operations (especially async calls like Supabase interactions) in `try-catch` blocks within controllers or services.
- **UI Feedback:** Display user-friendly error messages using dedicated widgets, dialogs, or SnackBars. Avoid showing raw exception messages or stack traces to the user. Leverage Riverpod's `AsyncValue.error` state for displaying errors related to async operations.
- **Logging:** Implement robust logging (e.g., using the `logging` package). Consider integrating a remote logging service (like Sentry) for production monitoring and diagnosing component failures.
- **Centralized Service (Optional):** Consider an error handling service in `lib/core/services/` to standardize logging and potentially user notification logic.

## 10. Performance Optimization

- **Widget Builds:** Use `const` widgets extensively. Minimize widget rebuilds using appropriate Riverpod providers (`.autoDispose`, `.family`) and `ref.watch` / `ref.select` judiciously.
- **Lists:** Implement pagination or infinite scrolling (`FutureProvider.family` with page/offset parameters) for long lists (e.g., workout history, exercises). Use `ListView.builder`. Use keys (`ValueKey`) if list items have stable identities and might change order.
- **Images:** Use `cached_network_image` for efficient loading and caching of network images. Optimize image sizes and formats before uploading. Consider lazy loading images within lists. Replace static images with GIFs for exercises where appropriate.
- **Async:** Avoid blocking the UI thread. Use `async/await` correctly. Offload heavy computations to isolates if necessary (though prefer backend processing).
- **Profiling:** Use Flutter DevTools (CPU profiler, memory profiler, widget rebuild tracker) to identify and fix performance bottlenecks.

## 11. Feature Implementation Guidance (Remaining 40% Focus)

Prioritize based on project milestones and address charter recommendations.

- **Follow Architecture:** Implement all features within their dedicated folders (`lib/features/<feature_name>/`). Break down large features into smaller tasks.
- **Booking System Refinements:**
  - Implement same-day ticket ID validation logic (clarify Admin vs. User flow).
  - Implement Admin approval/decline flow.
  - Implement robust waitlist logic (joining, notifications via push/in-app, Admin monitoring).
  - Ensure Supabase real-time subscriptions correctly display live gym occupancy (define update mechanism - likely Admin input).
  - Implement booking restriction to university students (validation during registration/booking).
  - Implement option to request trainer assistance during booking (UI + notification flow).
- **Workout Tracking Enhancements:**
  - Fully integrate `yuhonas/free-exercise-db` with efficient searching/filtering.
  - Replace static images with GIFs for exercises (source/create GIFs).
  - Implement exercise filtering based on available university gym equipment (requires mapping data).
  - Complete "Customize Your Workout" and "Recommended/All Programs" sections.
- **Recommendation System:**
  - **Backend Focus:** Implement core logic (content-based, collaborative filtering, hybrid) as a **separate backend service** (Python/Flask/FastAPI preferred, or Supabase Edge Functions for simpler logic/proxy). Leverage libraries like `scikit-learn`, `pandas`.
  - **Flutter Role:** Make HTTP requests to the recommendation API endpoint (e.g., `/recommendations?userId=<user_id>`). Receive recommendations (e.g., list of workout/program IDs). Fetch details for these IDs from Supabase and display them.
  - **Data:** Ensure the backend service has secure access to necessary user data (profile, goals, history, ratings if any) and exercise data.
  - **Triggering:** Decide when recommendations are generated (on-demand, background task?).
  - **Enhancements:** Improve algorithm for beginner workouts based on fitness levels (requires capturing/using this data). Allow user preferences and feedback loops.
- **Profile:** Implement all sections (My Bookings categorization, Workout History details, Notifications settings, Contact Us, Privacy Policy).
- **Admin Module Awareness:** While developing user features, be mindful of related Admin needs (Analytics, Session Attendance Tracking, Targeted Alerts) when designing shared Supabase tables and logic.

## 12. Testing

- **Unit Tests:** Test business logic within Riverpod controllers/notifiers, services, and utility functions (`test` package). Mock dependencies (Supabase client, repositories) using packages like `mockito` or `mocktail`.
- **Widget Tests:** Test individual widgets and simple screen flows (`flutter_test` package). Verify UI elements render correctly based on state provided by mocked Riverpod providers.
- **Integration Tests:** Test critical end-to-end user flows spanning multiple screens and interacting with a real (or mocked) backend (`integration_test` package). Focus on complex interactions: Booking, Waitlists, Real-time updates, Workout saving, Login/Registration.
- **Coverage:** Aim for good test coverage, especially for core logic and critical features.

## 13. Accessibility (A11y)

- **Semantics:** Use `Semantics` widgets and properties (`label`, `hint`, `button`, etc.) to provide context for screen readers.
- **Contrast:** Ensure sufficient color contrast between text and background, adhering to WCAG guidelines. Use the theme colors defined in `HeronFitTheme`.
- **Touch Targets:** Ensure buttons, icons, and other interactive elements have minimum touch target sizes (>= 48x48 dp). Use `Padding` or `SizedBox` if needed.
- **Dynamic Text:** Test the app with larger font sizes enabled in system settings to ensure layouts adapt gracefully. Use relative font sizes from the theme.
- **Consider Diverse Users:** Incorporate recommendations for users with various disabilities where applicable.

## 14. Security

- **Input Validation:** Sanitize and validate all user input on both the client and backend (if applicable) to prevent injection attacks.
- **API Calls:** Use HTTPS for all communication with backend services (Supabase, recommendation engine).
- **Dependencies:** Keep Flutter and package dependencies updated (`flutter pub upgrade --major-versions`). Regularly check for known vulnerabilities.
- **RLS:** Rigorously enforce and test Supabase Row Level Security policies.
- **Authentication/Authorization:** Implement robust authentication using Supabase Auth. Ensure authorization checks are performed where necessary (e.g., before allowing data modification).
- **Secrets Management:** Use `.env` files via `flutter_dotenv` for sensitive keys (Supabase URL/Key). **Never commit `.env` files to version control.**

## 15. Version Control (Git) & Commit Messages

- **Branching:** Use a branching strategy (e.g., Gitflow - `main`, `develop`, `feature/`, `fix/`, `release/`).
- **Commits:** Commit frequently with clear, concise messages following the Conventional Commits format.
- **Code Reviews:** Conduct code reviews for feature branches before merging into `develop`.

### Commit Message Format (Conventional Commits)

Follow the [Conventional Commits specification](https://www.conventionalcommits.org/).

**Basic Format:**

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Header (`<type>[optional scope]: <description>`)**

- **Type:** Must be one of:
  - `feat`: A new feature for the user.
  - `fix`: A bug fix for the user.
  - `build`: Changes affecting the build system or external dependencies (e.g., `pubspec.yaml`, `gradle`).
  - `chore`: Other changes that don't modify `src` or `test` files (e.g., updating dependencies, documentation).
  - `ci`: Changes to CI configuration files/scripts.
  - `docs`: Documentation only changes.
  - `perf`: A code change that improves performance.
  - `refactor`: A code change that neither fixes a bug nor adds a feature.
  - `revert`: Reverts a previous commit.
  - `style`: Code style changes (formatting, whitespace).
  - `test`: Adding missing tests or correcting existing tests.
- **Scope (Optional):** Noun describing the affected codebase section (e.g., `auth`, `booking`, `workout`, `profile`, `core`, `theme`, `ci`, `deps`). Use lowercase.
- **Description:** Short, imperative mood summary (e.g., "add login screen"). Use lowercase. No period at the end.

**Example Headers:**

- `feat(auth): add email verification screen`
- `fix(workout): correct total weight calculation`
- `refactor(core): simplify supabase service wrapper`
- `docs: update comprehensive ai guidelines`
- `chore(deps): update riverpod to 2.5.1`
- `style(theme): adjust primary color shade`
- `test(booking): add unit tests for booking controller`

**Body (Optional)**

- Explain **why** the change was made, providing context.
- Describe previous behavior if fixing a bug.
- Use bullet points for lists.
- Reference issue numbers (`Closes #123`, `Refs #456`).

**Footer (Optional)**

- **Breaking Changes:** Start with `BREAKING CHANGE:` followed by details.
- **Issue References:** `Closes #12`, `Refs #34, #56`.

**General Commit Guidelines:**

- **Comprehensive:** Message reflects _all_ changes in the commit.
- **Explain "Why":** Focus on motivation.
- **Imperative Mood:** "fix bug" not "fixed bug".
- **Keep Lines Short:** Aim for ~72 characters in body/footer.

## 16. Tooling

- **Version Control:** Git & GitHub.
- **IDE:** VS Code / Android Studio. Use recommended extensions (Dart, Flutter).
- **Design:** Figma (Primary source for UI/UX).
- **Backend:** Supabase (Primary App Backend), Separate Service/Functions (Recommendation Engine).
- **Project Management:** Plane (Refer for tasks and milestones).

## 17. Final Check

Before completing tasks or submitting code for review:

- Does the implementation adhere to the NFRs (Maintainability, Reusability, Modularity, Modifiability)?
- Does it follow the features-first architecture?
- Is Riverpod used correctly for state management?
- Does it meet coding standards and UI/UX guidelines?
- Is error handling robust and user-friendly?
- Are performance considerations addressed?
- Is the code adequately tested?
- Are accessibility and security requirements met?
- Does the commit message follow the Conventional Commits format?
