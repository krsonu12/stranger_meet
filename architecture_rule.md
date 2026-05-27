# Flutter Enterprise Engineering Rules (Mandatory)

Version: 1.0  
Architecture Style: Clean Architecture + Feature First + Modular Scalable Structure

---

# CORE ENGINEERING PRINCIPLES

Every feature and module in the project MUST follow:

- Clean Architecture
- OOPs Concept
- SOLID Principles
- DRY Principle
- Separation of Concerns
- Feature-first structure
- Scalable folder organization
- Predictable state management
- Testability
- Reusability
- Maintainability
- Dependency inversion

Dependencies must always point inward.

Architecture Flow:

UI
→ State Management
→ UseCase
→ Repository Interface
→ Repository Implementation
→ Datasource
→ API / Local DB

Data Mapping Flow:

JSON
→ DTO
→ Entity
→ UI

---

# 1. PROJECT ARCHITECTURE

The project MUST strictly contain 3 layers:

1. Presentation Layer
2. Domain Layer
3. Data Layer

Shared/global reusable modules must live inside:
lib/core/

Feature-specific code must live inside:
lib/features/

---

# 2. PRESENTATION LAYER RULES

Location:
features/<feature>/presentation/

---

## Allowed

- Screens / Pages
- Widgets
- BLoC 
- Providers
- ViewModels
- UI States
- UI Events
- Form Controllers
- Navigation triggers
- UI validation

---

## Responsibilities

- Render UI
- Handle user interactions
- Observe state
- Trigger UseCases
- Handle navigation
- Display loading/error/success states

---

## Must NOT contain

❌ Business logic  
❌ Repository implementations  
❌ API calls  
❌ Database queries  
❌ Dio usage  
❌ Hive usage  
❌ Complex data transformation  
❌ Direct datasource access  

---

## Rules

- Prefer StatelessWidget
- Keep widgets reusable
- Extract reusable components
- Avoid large build methods
- One widget should have one responsibility
- Use const constructors whenever possible
- No business rules inside widgets

---

# 3. DOMAIN LAYER RULES

Location:
features/<feature>/domain/

---

## Allowed

- Entities
- Repository Interfaces
- UseCases
- Business Rules
- Validation Logic

---

## Responsibilities

- Business logic
- Application workflows
- Validation rules
- Domain rules

---

## Must NOT contain

❌ Flutter imports  
❌ UI code  
❌ Dio imports  
❌ Hive imports  
❌ API logic  
❌ Local storage logic  
❌ Framework-specific code  

---

## Rules

- Domain layer must remain platform independent
- UseCases should contain single responsibility
- Entities must be immutable
- Repository contracts belong only here

---

# 4. DATA LAYER RULES

Location:
features/<feature>/data/

---

## Allowed

- Repository Implementations
- Remote Datasources
- Local Datasources
- DTOs
- Models
- Mappers
- API Services
- Cache handlers

---

## Responsibilities

- API communication
- Local storage handling
- Data serialization
- DTO ↔ Entity mapping
- Error transformation
- Caching

---

## Must NOT contain

❌ Widgets  
❌ UI logic  
❌ BLoC logic  
❌ Navigation logic  
❌ Presentation state logic  

---

## Rules

- RepositoryImpl must implement Domain repository interfaces
- DTOs must never reach UI directly
- Always map DTO → Entity
- Datasources should remain isolated

---

# 5. CORE SHARED MODULES RULES

Location:
lib/core/

Core contains reusable shared services and global app-level utilities.

---

## Allowed Shared Services

- Dio client
- Logger service
- Analytics service
- Connectivity service
- SharedPreferences service
- Hive service
- Secure storage
- Theme service
- App configuration
- Session manager
- Cache manager
- Environment manager
- Localization service
- Permission service
- API interceptors
- Common validators
- Date utilities
- Global extensions
- Event bus
- Encryption utilities

---

## Shared Properties

Global shared properties may include:

- App constants
- API endpoints
- Typography system
- Color palettes
- Spacing system
- Asset paths
- Shared enums
- Shared styles
- Global utility methods

---

## Core Rules

- Shared services must remain reusable
- Shared services must remain feature-independent
- No feature-specific business logic inside core
- No BuildContext inside core services
- No circular dependencies

---

# 6. STATE MANAGEMENT RULES

## Mandatory

Use one of:
- flutter_bloc
- Riverpod

Preferred:
- flutter_bloc

---

## No setState for Business Logic

`setState()` is NOT allowed for:

❌ API handling  
❌ Authentication logic  
❌ Search logic  
❌ Pagination  
❌ Form submission  
❌ State synchronization  
❌ Business workflows  

---

## setState Allowed Only For

- Animation state
- UI-only toggle state
- Temporary local UI interaction

---

# 7. FREEZED RULES (MANDATORY)

Mandatory packages:

- freezed
- freezed_annotation
- json_serializable
- json_annotation

---

## Freezed Must Be Used For

- DTOs
- State classes
- Union states
- Immutable models

---

## State Requirements

Every async feature MUST support:

- initial
- loading
- success
- error
- refreshing

---

## Forbidden State Patterns

❌ Multiple loading booleans  
❌ Nullable hacks  
❌ Dynamic state objects  
❌ Mutable state classes  

---

# 8. DEPENDENCY INJECTION RULES

## Mandatory

Use:
- get_it

Optional:
- injectable

---

## Registration Rules

### registerLazySingleton

Use for:

- Repositories
- Dio
- API services
- Hive services
- SharedPreferences
- Secure storage
- Network clients
- Shared services

---

### registerFactory

Use for:

- BLoCs
- Cubits
- ViewModels
- Providers

---

### registerSingleton

Use only for:
- Pre-initialized app-wide services

---

## Rules

❌ No direct dependency creation inside widgets  
❌ No repository initialization inside UI  
❌ No service initialization inside presentation layer  

All dependencies MUST come from get_it.

Recommended location:
lib/core/di/injection.dart

---

# 9. NAVIGATION RULES

## Mandatory

Use:
- GoRouter

---

## Rules

- Centralized routing
- Route guards
- Typed routes preferred
- Deep linking support
- Auth redirect handling

---

## Avoid

❌ Navigator.push scattered everywhere  
❌ Hardcoded route strings  
❌ Navigation logic inside repositories  

---

# 10. LOCAL STORAGE RULES

## SharedPreferences

Use only for:

- Theme mode
- Small settings
- Lightweight flags

Mandatory:
Theme state persistence across app restarts.

---

## Hive

Use for:

- Offline caching
- Session storage
- Structured local persistence
- Large local datasets

Do NOT use SharedPreferences for objects.

---

# 11. API & NETWORK RULES

## Mandatory

Use:
- Dio

Optional:
- Retrofit

---

## API Rules

- Centralized Dio configuration
- Use interceptors
- Global timeout configuration
- Auth token injection
- Logging interceptor (debug only)

---

## Mandatory Error Handling

Handle:

- Timeout exceptions
- No internet
- Unauthorized access
- Parsing failures
- Server errors
- Unknown exceptions

---

## Forbidden

❌ Throwing raw Dio exceptions to UI  
❌ Exposing backend response structures directly  
❌ API calls inside widgets  

---

## Recommended Pattern

Use:
- Failure classes
OR
- Result/Either wrapper

---

# 12. LOADING UI RULES

Every async/network screen MUST include:

- Shimmer loading placeholders

Do NOT:

❌ Show blank screens  
❌ Depend only on CircularProgressIndicator  

Shimmer UI should resemble final UI.

Recommended package:
- shimmer

---

# 13. THEME MANAGEMENT RULES

Theme mode MUST:

- Persist using SharedPreferences
- Support light theme
- Support dark theme
- Be globally accessible

Theme state should use:
- BLoC
- Cubit
- Riverpod
- ViewModel

---

# 14. FOLDER STRUCTURE (MANDATORY)

lib/
│
├── core/
│   ├── config/
│   ├── constants/
│   ├── di/
│   ├── errors/
│   ├── extensions/
│   ├── localization/
│   ├── network/
│   ├── services/
│   ├── storage/
│   ├── theme/
│   ├── utils/
│   └── widgets/
│
├── features/
│   └── feature_name/
│       ├── data/
│       │   ├── datasources/
│       │   ├── dto/
│       │   ├── mappers/
│       │   ├── models/
│       │   └── repositories/
│       │
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       │
│       └── presentation/
│           ├── bloc/
│           ├── pages/
│           ├── providers/
│           ├── viewmodels/
│           └── widgets/
│
├── routes/
├── generated/
└── main.dart

---

# 15. NAMING CONVENTIONS

## File Naming

Use snake_case only.

Examples:
- auth_repository.dart
- login_screen.dart
- profile_bloc.dart

---

## Class Naming

### Repository Interface
UserRepository

### Repository Implementation
UserRepositoryImpl

### DTO
UserDto

### Entity
UserEntity

### UseCase
GetUserUseCase

### State
AuthState

### Event
AuthEvent

---

# 16. PERFORMANCE RULES

Mandatory:

- Pagination for large lists
- Debounced API search
- Dispose controllers properly
- Avoid unnecessary rebuilds
- Image caching
- Lazy loading

---

## Preferred

- Selectors
- Memoization
- const constructors
- RepaintBoundary where needed

---

# 17. UI ENGINEERING RULES

Mandatory:

- Responsive UI
- Reusable components
- Consistent spacing system
- Centralized typography/colors
- Design system consistency

---

## Avoid

❌ Hardcoded dimensions everywhere  
❌ Massive widgets  
❌ Inline business logic  
❌ Repeated UI code  

---

# 18. ERROR HANDLING RULES

Mandatory centralized:

- Failure classes
- Error mappers
- Exception handlers

Presentation layer must receive:
- User-friendly messages only

Never expose:
- Stack traces
- Raw exceptions
- Internal backend messages

---

# 19. SECURITY RULES

Mandatory:

- Secure token storage
- API timeout configuration
- Input validation
- Environment separation

Avoid:

❌ Hardcoded secrets  
❌ API keys in UI layer  
❌ Plain-text sensitive storage  

---

# 20. TESTING RULES

Preferred tests:

- UseCase unit tests
- Repository tests
- Widget tests
- Datasource tests
- Mock API tests

---

## Rules

- Business logic must remain independently testable
- Avoid tightly coupled architecture

---

# 21. RECOMMENDED PACKAGES

## State Management
- flutter_bloc
- bloc
- equatable

## Networking
- dio
- retrofit

## Serialization
- freezed
- json_serializable

## Dependency Injection
- get_it
- injectable

## Navigation
- go_router

## Local Storage
- hive
- hive_flutter
- shared_preferences

## UI
- shimmer

## Utilities
- connectivity_plus
- flutter_secure_storage

---

# 22. FORBIDDEN PRACTICES

❌ Business logic inside Widgets  
❌ Direct API calls from UI  
❌ Direct DB access from Presentation  
❌ Massive StatefulWidgets  
❌ Mutable states  
❌ Hardcoded strings everywhere  
❌ setState for async logic  
❌ Tight coupling between layers  
❌ Navigation inside repositories  
❌ Returning DTOs directly to UI  
❌ Direct Dio usage inside widgets  
❌ Creating repositories inside screens  
❌ Using BuildContext inside Domain/Data layers  
❌ Feature-specific logic inside core shared services  
❌ Direct datasource usage inside Presentation  
❌ God classes with too many responsibilities  

---

# 23. BUILD RUNNER RULES

Whenever models/states are updated, run:

flutter pub run build_runner build --delete-conflicting-outputs

For continuous generation:

flutter pub run build_runner watch --delete-conflicting-outputs

---

# 24. FINAL ENGINEERING STANDARDS

The codebase must always prioritize:

- Scalability
- Maintainability
- Testability
- Readability
- Reusability
- Modularization
- Predictable state management
- Clean dependency flow
- Long-term maintainability

Every feature added to the application MUST follow these rules without exception.
