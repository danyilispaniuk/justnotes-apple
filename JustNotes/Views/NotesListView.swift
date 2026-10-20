import SwiftUI
import SwiftData

struct NotesListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Note.updated, order: .reverse) private var notes: [Note]
    @State private var searchText = ""

    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 12, alignment: .top)]

    private var filteredNotes: [Note] {
        notes.filter { $0.matches(searchText) }
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Recent notes")
                .navigationDestination(for: Note.self) { note in
                    NoteDetailView(note: note)
                }
                .searchable(text: $searchText, prompt: "Search")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: addNote) {
                            Label("New note", systemImage: "plus")
                        }
                    }
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if notes.isEmpty {
            ContentUnavailableView(
                "No notes yet",
                systemImage: "note.text",
                description: Text("Tap + to add your first note.")
            )
        } else if filteredNotes.isEmpty {
            ContentUnavailableView.search(text: searchText)
        } else {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(filteredNotes) { note in
                        NavigationLink(value: note) {
                            NoteCard(note: note)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
        }
    }

    // Placeholder until the note editor is added in phase 2.
    private func addNote() {
        withAnimation {
            modelContext.insert(Note(title: "New note", text: ""))
        }
    }
}

#Preview {
    NotesListView()
        .modelContainer(previewContainer)
}

#Preview("Empty") {
    NotesListView()
        .modelContainer(for: Note.self, inMemory: true)
}
