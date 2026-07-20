---
name: token-dotnet
description: Load when working on any C# or .NET project. Provides grep patterns with build directory exclusion, C# code structure search patterns, generated file handling, and .NET project exploration strategy. Complements token-efficiency (decision tree) and token-codebase-exploration (workflow).
version: 1.0.0
allowed-tools: Bash, Read, Grep, Glob
---

# Token Efficiency — .NET / C# Specifics

## Always Exclude Build Directories from Search

.NET projects generate `bin/`, `obj/`, and `.vs/` during compilation. These contain
binary assemblies, Roslyn-generated C#, and Visual Studio metadata. Without exclusion,
grep scans binary noise and produces false results at extra token cost.

Add these flags to every search:

```bash
# Single-directory grep
grep -rn "pattern" --include="*.cs" \
  --exclude-dir=bin --exclude-dir=obj --exclude-dir=.vs src/

# find equivalent
find . -name "*.cs" \
  -not -path "*/bin/*" -not -path "*/obj/*" -not -path "*/.vs/*" \
  | head -30
```

## Generated Files — Read Only, Never Edit

These files are regenerated on build. Editing them is overwritten silently:

- `*.g.cs` — Roslyn source generators (e.g., strongly-typed resources, gRPC stubs)
- `*.Designer.cs` — WinForms / WPF designer output
- `Migrations/*.cs` — Entity Framework migration files (edit via `dotnet ef` instead)

If you need to understand what a generator produces, Read it. Never Edit or sed it.

## C# Code Search Patterns

Use anchored patterns to exclude comment lines (tested: unanchored patterns match
`// comment text containing the pattern`).

```bash
BASE="--include=*.cs --exclude-dir=bin --exclude-dir=obj --exclude-dir=.vs"

# Find an interface definition
grep -rn "^\s*public interface IAuth" $BASE src/ | head -10

# Find all implementations of an interface
grep -rn "^\s*public.*class .* : IRepository" $BASE src/ | head -20

# Find abstract base classes
grep -rn "^\s*public abstract class" $BASE src/ | head -10

# Find all usages of a method call
grep -rn "\.Authenticate(" $BASE | head -30

# Find all thrown exception types
grep -rn "throw new" $BASE src/ | head -30

# Find TODO and FIXME comments
grep -rn "// TODO\|// FIXME" $BASE | head -20

# Find files containing a concept (list files only)
grep -rl "JwtBearer\|AddAuthentication" $BASE src/

# Find most-imported namespaces (reveals core modules)
grep -r "^using " $BASE src/ \
  | sed 's/.*using //' | cut -d';' -f1 \
  | sort | uniq -c | sort -rn | head -15
```

## Namespace Safety with sed

Sed on C# is dangerous when the replacement term is adjacent to other namespace
segments. Tested empirically: replacing `DroneCtrl.Legacy` with `MissionControl.Core`
in a file containing `DroneCtrl.Legacy.Core.Auth` produces `MissionControl.Core.Core.Auth`
— an invalid namespace that may compile but fails at runtime.

Default: use Read + Edit for all .cs files. The only safe sed exception is a standalone
token that cannot concatenate (e.g., a numeric version `1.0.0` surrounded by quotes in
`AssemblyInfo.cs`). Before using sed on any exception case, verify with grep that the
term appears only in isolation:

```bash
# Confirm the term has no adjacent structural tokens before sed
grep -rn "DroneCtrl\.Legacy" $BASE src/
# Review every match — if any appears inside a dotted path, abort and use Read+Edit.
```

## .NET Project Exploration

When entering Broad Exploration mode (see token-codebase-exploration):

**Phase 2 — Entry point:**

```bash
find . -name "Program.cs" -o -name "Startup.cs" | grep -vi test | head -5
find . -name "*.csproj" | head -5
```

Read the entry point — it shows the full DI configuration, which is the map of the project.

**Phase 3 — Core abstractions:**

```bash
grep -rn "^\s*public interface" $BASE src/ | head -20
grep -rn "^\s*public abstract class" $BASE src/ | head -10
```

**Phase 4 — Recent activity:**

```bash
git log --name-only --pretty=format: --since="1 month ago" \
  | grep "\.cs$" | sort | uniq -c | sort -rn | head -10
```

**Read order after README:** entry point (Program.cs or Startup.cs) → 1 core service
identified from DI configuration → 1 repository or infrastructure file used by that service.
