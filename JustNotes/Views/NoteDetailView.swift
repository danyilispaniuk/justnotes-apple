import SwiftUI
import SwiftData

// Read-only for phase 1; becomes the editor in phase 2.
struct NoteDetailView: View {
    let note: Note

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(note.title)
                    .font(.largeTitle.bold())

                Text("Updated \(note.updated.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(note.text)
                    .font(.body)
                    .textSelection(.enabled)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        NoteDetailView(note: SampleNotes.make()[2])
    }
    .modelContainer(previewContainer)
}
