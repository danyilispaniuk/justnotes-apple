import SwiftUI
import SwiftData

@main
struct JustNotesApp: App {
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for: Note.self)
        } catch {
            fatalError("Failed to create model container: \(error)")
        }

        do {
            try SampleNotes.seedIfNeeded(context: container.mainContext)
        } catch {
            print("Failed to seed sample notes: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            NotesListView()
        }
        .modelContainer(container)
    }
}
