# JustNotes for iOS / iPadOS

A native SwiftUI notes app for iPhone and iPad, modelled on the Android app in `../justnotes-android`. Unlike the Android version, it has **no API or network layer**: all notes are stored locally on the device.

## Keeping this file current

**Update this file after every major implementation** (a finished phase, a new screen, a model or storage change, a new dependency). In the same change:
1. Tick the finished items in **Roadmap** and add any new follow-ups.
2. Update **Architecture** and **File layout** to match the code.
3. Add a dated entry to **Changelog** (newest first): what changed and anything not done or not verified.
4. Record any new conventions or decisions under **Decisions**.

Keep it short and true to the code. Remove anything that is no longer accurate.

## Scope

- Each note has a **title** and **text**, plus `created` / `updated` dates.
- Local storage only. No accounts, sync or backend.
- The Android app's "Notepads" (note groups) are **out of scope** for now.
- Android → iOS naming: `header` → `title`, `notes` → `text`.

## Tech stack

- Swift, SwiftUI, SwiftData
- Deployment target: iOS / iPadOS 17.0 (needed for SwiftData)
- Devices: iPhone and iPad (universal app)
- No third-party dependencies
- Needs macOS with Xcode to build and run. The main dev machine is Windows, so Swift files can be written there but must be built on a Mac.
- Tests use Swift Testing (`import Testing`, Xcode 16+).

## Build and run (on a Mac)

The Xcode project is generated from `project.yml` with [XcodeGen](https://github.com/yonaskolb/XcodeGen), so the `.xcodeproj` is not hand-written:

```bash
brew install xcodegen
xcodegen generate
open JustNotes.xcodeproj
```

Re-run `xcodegen generate` after adding or removing files. Tests: `Cmd+U` in Xcode, or
`xcodebuild test -scheme JustNotes -destination 'platform=iOS Simulator,name=iPhone 16'`.

## Architecture

- **Model:** `Note` is a SwiftData `@Model` with `id: UUID` (unique), `title`, `text`, `created: Date`, `updated: Date`. `Note.matches(_:)` holds the search rule (case-insensitive on title or text, blank query matches all) so it can be unit-tested.
- **Storage:** `JustNotesApp` creates a `ModelContainer(for: Note.self)` and passes it with `.modelContainer(_:)`. Views read with `@Query` and write via `@Environment(\.modelContext)`.
- **Sample data:** `SampleNotes.seedIfNeeded(context:defaults:)` runs in `JustNotesApp.init`. It inserts the 8 sample notes once, only when the `didSeedSampleNotes` `UserDefaults` flag is unset and the store is empty, then sets the flag, so deleted samples never come back. Previews use the in-memory `previewContainer`.
- **Main page (`NotesListView`):** `NavigationStack` titled "Recent notes", `@Query` sorted by `updated` descending, `.searchable` using `Note.matches`, a **+** toolbar button (inserts a placeholder "New note" until phase 2), and an adaptive `LazyVGrid` (`GridItem(.adaptive(minimum: 150))`): 2 columns on iPhone, more on iPad. `ContentUnavailableView` for no notes and for no search results. Tapping a card pushes `NoteDetailView` via `navigationDestination(for: Note.self)`.
- **Card (`NoteCard`):** bold title (2 lines max), text (6 lines max, hidden if empty), formatted `updated` date, rounded `secondarySystemBackground`.
- **Detail (`NoteDetailView`):** read-only title, updated date and selectable text.

## File layout

```
project.yml                  XcodeGen spec (app + test targets, iOS 17, iPhone + iPad)
JustNotes/
  JustNotesApp.swift         app entry, model container, first-launch seeding
  Models/Note.swift          SwiftData model + search matching
  Data/SampleNotes.swift     sample notes, seeding, preview container
  Views/NotesListView.swift  main page (grid, search, + button, empty states)
  Views/NoteCard.swift       grid card
  Views/NoteDetailView.swift read-only note view
JustNotesTests/
  NoteSearchTests.swift      search matching
  SampleNotesTests.swift     seeding runs once, only on an empty store
```

## Roadmap

### Phase 1: main page with sample notes (code written, not yet built)
- [x] Project spec (`project.yml`, XcodeGen); `.xcodeproj` still to be generated on a Mac
- [x] `Note` model
- [x] Sample notes, seeded once on first launch, plus preview container
- [x] `NotesListView`: title, newest-first sort, search, adaptive grid, empty states (`ContentUnavailableView`)
- [x] `NoteCard`
- [x] Tap opens read-only `NoteDetailView`
- [x] **+** button (placeholder until phase 2)
- [x] Tests: search filter; seeding runs only on an empty store
- [ ] Build on a Mac and fix any compile errors; run the tests
- [ ] Check on iPhone and iPad simulators, portrait and landscape; relaunch keeps notes and doesn't re-seed
- [ ] App icon from `../justnotes-android/justnotes-big.png` (no asset catalog yet)

### Phase 2: create and edit
- [ ] New note screen (title + text)
- [ ] Edit note screen; save on back, editing bumps `updated` so the note moves to the top

### Phase 3: delete and iPad layout
- [ ] Delete with confirmation, plus swipe / context-menu actions
- [ ] iPad `NavigationSplitView` (grid or list + editor side by side)

### Later / ideas
- [ ] True masonry (staggered) grid like Android, using a custom `Layout`
- [ ] Notepads (note groups) if wanted

## Decisions

- **SwiftData over a JSON file:** sorting, `@Query` and live UI updates come built in, and it scales to edit and delete.
- **Regular grid first:** SwiftUI has no built-in staggered grid, so phase 1 uses `LazyVGrid` with top-aligned cards.
- **XcodeGen instead of a committed hand-written `.xcodeproj`:** the project can be described as text from Windows and regenerated on a Mac. Keep `project.yml` in sync when adding targets or build settings.
- **Seeding flag in `UserDefaults`:** seeding checks both the flag and an empty store, so samples are added only on the very first launch.

## Changelog

- **2026-10-19:** Phase 1 code written: `Note` model, sample notes with one-time seeding, main page with grid, search and empty states, `NoteCard`, read-only `NoteDetailView`, placeholder **+** button, Swift Testing tests, and `project.yml`. Written on Windows: **not compiled, run or tested yet**. No app icon.
- **2026-10-19:** Created CLAUDE.md with the project description and the phase 1 plan. No app code yet.
