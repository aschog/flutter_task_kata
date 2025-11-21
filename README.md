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

