import Foundation
import SwiftData

@Model
final class Note {
    @Attribute(.unique) var id: UUID
    var title: String
    var text: String
    var created: Date
    var updated: Date

    init(id: UUID = UUID(), title: String, text: String, created: Date = .now, updated: Date? = nil) {
        self.id = id
        self.title = title
        self.text = text
        self.created = created
        self.updated = updated ?? created
    }
}

extension Note {
    /// Case-insensitive match on title or text. A blank query matches every note.
    func matches(_ query: String) -> Bool {
        let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return true }
        return title.localizedCaseInsensitiveContains(query)
            || text.localizedCaseInsensitiveContains(query)
    }
}
