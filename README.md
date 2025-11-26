# 🧩 Clean Code Flutter Task Tracker Kata (TDD + Cubit)


## ✍️ Commit Message Conventions

Writing clear and consistent commit messages is crucial for collaboration and maintaining a readable project history. This project adheres to the **Conventional Commits** specification.

### Structure

```
<type>[optional scope]: <description>

[optional body]

[optional footer]
```

### Types

*   **feat**: A new feature.
*   **fix**: A bug fix.
*   **refactor**: A code change that neither fixes a bug nor adds a feature.
*   **docs**: Documentation only changes.
*   **style**: Changes that do not affect the meaning of the code (white-space, formatting, etc.).
*   **test**: Adding missing tests or correcting existing tests.
*   **chore**: Changes to the build process or auxiliary tools.

### Example

```
refactor(auth): implement dependency injection with get_it

Previously, dependencies were created and passed down manually. This commit introduces `get_it` and `injectable` to manage dependencies automatically, making the setup more scalable.
```

---

## 🏗️ Architecture

This project follows the **Clean Architecture** principles to ensure separation of concerns, testability, and scalability.

### Layers

1.  **Domain Layer** (`lib/domain/`)
    *   **Entities**: Core business objects (e.g., `Task`).
    *   **Repositories**: Abstract interfaces defining data operations.
    *   **Use Cases**: Encapsulate specific business rules (e.g., `AddTask`, `GetTasks`).
    *   *Note: This layer is independent of external frameworks.*

2.  **Data Layer** (`lib/data/`)
    *   **Repositories**: Implementations of domain repositories (e.g., `InMemoryTaskRepository`).
    *   Responsible for data retrieval and persistence.

3.  **Presentation Layer** (`lib/presentation/`)
    *   **State Management**: Uses **Cubit** (`flutter_bloc`) to manage UI state.
    *   **Widgets**: UI components that observe state changes.

### Key Libraries & Tools

*   **[flutter_bloc](https://pub.dev/packages/flutter_bloc)**: State management.
*   **[get_it](https://pub.dev/packages/get_it) & [injectable](https://pub.dev/packages/injectable)**: Dependency Injection.
*   **[equatable](https://pub.dev/packages/equatable)**: Value equality for classes.