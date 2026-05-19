---
name: backend-feature-first-expert
description: Optimized architecture for Dart Frog with Injectable and GetIt. High separation of concerns.
---

# Backend Feature-First Architecture (Dart Frog)

This skill defines the architectural pattern for the Backend, emphasizing a "Feature-First" approach inspired by Clean Architecture and DDD-Lite, fully integrated with `injectable` and `get_it`.

## 📂 Core Structure Proposal

The following structure ensures scalability and clear boundaries between logic, data, and presentation (routes).

```text
lib/
├── core/                   # System-wide infrastructure
│   ├── di/                 # GetIt & Injectable configuration
│   ├── exceptions/         # Custom API/Business exceptions
│   ├── extensions/         # Dart extension types and helpers
│   ├── interceptors/       # Shared middleware logic
│   └── constants/          # Global keys and constants
│
├── db_client/              # Drift Database core
│   ├── schema/             # Table definitions
│   ├── daos/               # Data Access Objects (optionally moved to features)
│   └── db_client.dart      # Main Database class
│
├── features/               # Scalable feature-sliced modules
│   └── [feature_name]/     # e.g., auth, combat, arena, shop
│       ├── application/    # Feature-specific services & logic (e.g., MailingService)
│       ├── domain/         # Interfaces (Repository) & Entities (Models)
│       └── data/           # Repository Impls & Local/Remote Data Sources
│
├── ws/                     # WebSocket core infrastructure
│   ├── commands/           # Command handlers/dispatchers
│   └── socket_manager.dart # Real-time state management
│
└── main.dart               # Entry point (DI initialization)

routes/                     # Dart Frog Routing layer
├── _middleware.dart        # Global providers (using getIt)
└── api/
    └── [feature_name]/     # Route handlers (keep them thin!)
```

## 🏗 Layer Responsibilities

### 1. Presentation (routes/)
- **Goal**: Handle HTTP/WS transport.
- **Rule**: Handlers must be **THIN**. No business logic here.
- **Action**: Read parameters, call a Service/Repository from `context.read<T>()`, return a Response.

### 2. Application (lib/features/x/application/)
- **Goal**: Orchestrate business processes.
- **Example**: `MailingService`, `CombatSupervisor`.
- **Annotation**: Use `@lazySingleton` or `@injectable`.

### 3. Domain (lib/features/x/domain/)
- **Goal**: Define the "What".
- **Rule**: Contains abstract Repository classes and plain data models (DTOs).
- **Goal**: Zero dependencies on implementation details (Drift, IO, etc.).

### 4. Data (lib/features/x/data/)
- **Goal**: Implement the "How".
- **Example**: `UserRepositoryImpl`.
- **Rule**: Depends on `DbClient` or External APIs.
- **Annotation**: `@LazySingleton(as: InterfaceName)`.

## 💉 Dependency Injection Rules

- **Always inject via constructor**.
- **Use Interfaces**: Annotate implementations with `@LazySingleton(as: Interface)`.
- **Named Instances**: Use `@Environment('memory')` for testing or specific variants.
- **Post-Construct**: Use `@postConstruct` for initialization logic (e.g., creating default rooms) to keep constructors side-effect free.

## 🚀 Workflow: Creating a New Feature

1.  **Define Domain**: Create `lib/features/my_feature/domain/my_repository.dart`.
2.  **Define Data**: Create `lib/features/my_feature/data/my_repository_impl.dart` (inject `DbClient`).
3.  **Define Application**: (Optional) Create `lib/features/my_feature/application/my_service.dart`.
4.  **Register DI**: Run `dart run build_runner build`.
5.  **Expose in Middleware**: Add `provider<MyRepository>((_) => getIt<MyRepository>())` in `routes/_middleware.dart`.
6.  **Create Route**: Create handler in `routes/api/my_feature/index.dart`.

## 🧪 Testing Strategy
- Leverage `getIt.allowReassignment = true`.
- Use `ENV=memory` to run logic against an in-memory database without side effects.
