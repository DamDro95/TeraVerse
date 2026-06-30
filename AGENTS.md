# AGENTS.md for TeraVerse Project
This file contains high-signal facts to accelerate agent performance in this repository.

## Investigation Priority
1.  **Source First:** `README`, manifest files, and task runner configs are highest priority. If conflicts arise, trust executable sources over prose docs.
2.  **Architecture Check:** Inspect representative entry points (`character.gd`) rather than random leaf files to understand wiring.

## High-Signal Extraction
*   **Commands:** Learn exact command sequences (e.g., `lint -> typecheck -> test`).
*   **Boundaries:** Identify monorepo/package ownership based on core directories: `/models` for assets, `/scenes` or relevant scripts for game logic components.
*   **Quirks:** Note framework-specific issues like auto-generated code or special environment loading quirks.

## Preservations
Retain only repo-specific "gotchas" and constraints (e.g., non-obvious conventions, exact setup requirements) that differ from language defaults. Leave generic advice out; it is better stored elsewhere.