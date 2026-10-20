import SwiftUI
import SwiftData

struct NoteCard: View {
    let note: Note

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(note.title)
                .font(.headline)
                .lineLimit(2)

            if !note.text.isEmpty {
                Text(note.text)
                    .font(.subheadline)
                    .lineLimit(6)
            }

            Text(note.updated.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top, 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
        .contentShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NoteCard(note: Note(title: "Shopping list", text: "Milk\nEggs\nBread"))
        .frame(width: 180)
        .padding()
}
