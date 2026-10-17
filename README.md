# Locked In

Habit tracker for iPhone, for you and a small crew of friends. See [PROJECT.md](PROJECT.md) for the product description, epics and tasks.

## Coding style

We follow the [Google Swift Style Guide](https://google.github.io/swift/). These are the rules that matter most day to day.

### Naming

| What | Case | Example |
|------|------|---------|
| Types, protocols, enums, structs, classes | `UpperCamelCase` | `HabitRow`, `ScoreCalculating` |
| Functions, methods, properties, variables | `lowerCamelCase` | `weekScore`, `toggleCheckIn(for:)` |
| Enum cases | `lowerCamelCase` | `.done`, `.missed`, `.future` |
| Constants, including globals | `lowerCamelCase`, no `k`/`g` prefix, no `ALL_CAPS` | `defaultAccent`, not `kDefaultAccent` |
| Static instance of own type | no type suffix | `Color.volt`, `Store.shared` |

- No `snake_case` anywhere in Swift code.
- Follow Apple's [API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/): names read like English at the call site, and acronyms are all one case (`habitID`, `urlString`).
- Don't use a `_` prefix to hide things. Use `private` or `fileprivate`.
- Init parameters that map to a property keep the same name: `self.name = name`.

### Files and folders

- **Files:** `UpperCamelCase.swift`, named after the main type they contain: `HabitRow.swift`.
- **Extensions:** `Type+Protocol.swift` for a conformance (`Habit+Codable.swift`), `Type+Additions.swift` for a mix of helpers.
- **Files without a main type:** a descriptive name, e.g. `Math.swift`.
- **Folders:** `UpperCamelCase`, grouped by feature (`Today`, `Week`, `NewHabit`, `Insights`, `Shared`). The Google guide doesn't cover folders; this follows Xcode convention.
- UTF-8, spaces only, no tabs.

### Formatting

- Indent with **2 spaces**.
- Lines are at most **100 columns** long.
- K&R braces: `{` on the same line, `} else {` on one line.
- No semicolons. One statement per line.
- One `let`/`var` per declaration.
- No parentheses around conditions: `if isDone {`, not `if (isDone) {`.
- Write `[String: Int]` with a space after `:` and never before it.
- A list is either all on one line, or has one item per line with a trailing comma.
- Use `// MARK: -` to split a file into sections.

### Language rules

- Use `guard` for early exits, so the main path isn't nested.
- Don't force-unwrap (`!`), use `try!` or force-cast (`as!`), except in tests or with a comment that explains why it's safe.
- Avoid implicitly unwrapped optionals (`T!`).
- Return `nil` (an `Optional`) for a missing value, never a sentinel like `-1`. Use `throws` when there are several ways to fail.
- Write `[T]`, `[K: V]` and `T?`, not `Array<T>` or `Optional<T>`.
- Leave out `-> Void` on functions, and `get {}` on read-only computed properties.
- Leave out default access levels (`internal`).
- Code compiles with no warnings.

### Exceptions to the Google guide

We deliberately don't follow these two rules:

- **Access modifiers on extensions are allowed.** `private extension HabitRow { ... }` is fine. You don't have to put the modifier on each member.
- **Trailing closures are up to you.** You don't have to use trailing-closure syntax for a final closure argument, and you don't have to label every closure when there are several.

### Comments

- Use `//` only, never `/* */`.
- Doc comments use `///` and start with a one-sentence summary ending in a period.
- Document parameters in this order: `- Parameter(s):`, then `- Returns:`, then `- Throws:`.

## Git workflow

### Branch names

Every branch starts from an issue and is named:

```
<type>/<issue-number>-<title>
```

- **type:** `bugfix` if the issue has the `bug` label, `feature` if it has `feature`, otherwise `task`.
- **issue-number:** the GitHub issue number, e.g. `62` (not the `T1.4.8` id).
- **title:** the part of the issue title after the first `:`, as lowercase words joined by `-`.

Example: issue #62 `[T1.4.8] iOS: Insights loading state` → `feature/62-insights-loading-state`.

### Creating a branch

[scripts/issue-branch.sh](scripts/issue-branch.sh) builds the name from the issue's labels and title. It creates the branch on GitHub from `main`, links it to the issue, and checks it out locally.

```bash
scripts/issue-branch.sh 62
```

To print the name without creating anything:

```bash
scripts/issue-branch.sh 62 --dry-run
```

It needs the [GitHub CLI](https://cli.github.com) (`gh`) and an issue with a `bug`, `feature` or `task` label.

To make it available as `gh branch <number>`, add an alias:

```bash
gh alias set --shell branch '"$(git rev-parse --show-toplevel)/scripts/issue-branch.sh" "$@"'
```
