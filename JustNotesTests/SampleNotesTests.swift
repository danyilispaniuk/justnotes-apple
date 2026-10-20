import Foundation
import SwiftData
import Testing
@testable import JustNotes

@MainActor
struct SampleNotesTests {
    let container: ModelContainer
    let defaults: UserDefaults

    init() throws {
        container = try ModelContainer(
            for: Note.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let suiteName = "SampleNotesTests-\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
    }

    private var context: ModelContext { container.mainContext }

    private func noteCount() throws -> Int {
        try context.fetchCount(FetchDescriptor<Note>())
    }

    @Test func seedsEmptyStoreOnce() throws {
        #expect(try SampleNotes.seedIfNeeded(context: context, defaults: defaults))
        #expect(try noteCount() == SampleNotes.make().count)

        #expect(try !SampleNotes.seedIfNeeded(context: context, defaults: defaults))
        #expect(try noteCount() == SampleNotes.make().count)
    }

    @Test func doesNotSeedStoreWithNotes() throws {
        context.insert(Note(title: "Mine", text: ""))
        try context.save()

        #expect(try !SampleNotes.seedIfNeeded(context: context, defaults: defaults))
        #expect(try noteCount() == 1)
    }

    @Test func doesNotReseedAfterUserDeletesAll() throws {
        try SampleNotes.seedIfNeeded(context: context, defaults: defaults)
        try context.delete(model: Note.self)
        try context.save()

        #expect(try !SampleNotes.seedIfNeeded(context: context, defaults: defaults))
        #expect(try noteCount() == 0)
    }
}
