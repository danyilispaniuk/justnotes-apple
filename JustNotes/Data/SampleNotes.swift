import Foundation
import SwiftData

enum SampleNotes {
    static let seededKey = "didSeedSampleNotes"

    /// Notes of different lengths and ages, so the grid and sorting can be tested.
    static func make(now: Date = .now) -> [Note] {
        func daysAgo(_ days: Double) -> Date { now.addingTimeInterval(-days * 24 * 60 * 60) }

        return [
            Note(title: "Welcome to JustNotes",
                 text: "Your notes are stored only on this device. Use the search bar to find a note by its title or text.",
                 created: daysAgo(0.1)),
            Note(title: "Shopping list",
                 text: "Milk\nEggs\nBread\nApples\nCoffee beans\nOlive oil",
                 created: daysAgo(1)),
            Note(title: "Meeting notes",
                 text: "Discussed the iOS release plan. Phase 1 is the main page with sample notes, phase 2 adds creating and editing, phase 3 adds deleting and the iPad split view.",
                 created: daysAgo(2)),
            Note(title: "Idea",
                 text: "Masonry grid like on Android.",
                 created: daysAgo(3)),
            Note(title: "Books to read",
                 text: "1. The Pragmatic Programmer\n2. Clean Code\n3. Designing Data-Intensive Applications\n4. Thinking, Fast and Slow",
                 created: daysAgo(5)),
            Note(title: "Workout",
                 text: "Monday: legs\nWednesday: back and arms\nFriday: chest and shoulders",
                 created: daysAgo(8)),
            Note(title: "Travel checklist",
                 text: "Passport, charger, headphones, tickets, adapter, sunscreen. Check in online 24 hours before the flight and save the boarding pass offline.",
                 created: daysAgo(14)),
            Note(title: "Quote",
                 text: "Simplicity is prerequisite for reliability.",
                 created: daysAgo(30)),
        ]
    }

    /// Inserts the sample notes once, on first launch, if the store is empty.
    /// Returns true when notes were inserted.
    @MainActor
    @discardableResult
    static func seedIfNeeded(context: ModelContext, defaults: UserDefaults = .standard) throws -> Bool {
        guard !defaults.bool(forKey: seededKey) else { return false }
        defer { defaults.set(true, forKey: seededKey) }

        guard try context.fetchCount(FetchDescriptor<Note>()) == 0 else { return false }
        make().forEach(context.insert)
        try context.save()
        return true
    }
}

/// In-memory container with sample notes, for SwiftUI previews.
@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: Note.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        SampleNotes.make().forEach(container.mainContext.insert)
        return container
    } catch {
        fatalError("Failed to create preview container: \(error)")
    }
}()
